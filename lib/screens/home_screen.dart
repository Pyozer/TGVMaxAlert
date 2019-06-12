import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tgv_max_alert/main.dart';
import 'package:tgv_max_alert/models/alert.dart';
import 'package:tgv_max_alert/screens/add_alert_screen.dart';
import 'package:tgv_max_alert/utils/preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tgv_max_alert/widgets/alert_row.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Alert> _alerts = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _alerts = Preferences.instance.getAlerts();
  }

  void _duplicateAlert(Alert alert) {
    Alert duplicate = Alert.fromRawJson(alert.toRawJson());
    duplicate.uuid = Uuid().v4();

    setState(() {
      _alerts.add(duplicate);
      Preferences.instance.addAlert(duplicate);
    });
  }

  void _deleteAlert(Alert alert) {
    setState(() {
      _alerts.removeWhere((a) => a.uuid == alert.uuid);
      Preferences.instance.setAlerts(_alerts);
    });
  }

  Future<void> _showNotification() async {
    var androidPlatform = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.High,
      priority: Priority.High,
      ticker: 'ticker',
    );
    var iOSPlatform = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidPlatform, iOSPlatform);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Place TGVMax disponible !',
      'Trajet Le Mans - Paris, le Ven. 14 Juin',
      platformChannel,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                child: Text(
                  "Alert",
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 36.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
                child: Text(
                  "TGVMax",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 38.0,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 75),
                  itemCount: _alerts.length,
                  itemBuilder: (_, index) {
                    return AlertRow(
                      alert: _alerts[index],
                      onLongPress: _duplicateAlert,
                      onDelete: _deleteAlert,
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 0),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Ajouter"),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddAlertScreen()),
            );
          },
        ),
      ),
    );
  }
}
