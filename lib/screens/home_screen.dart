import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tgv_max_alert/main.dart';
import 'package:tgv_max_alert/models/alert/alert.dart';
import 'package:tgv_max_alert/models/alert/alert_fetched.dart';
import 'package:tgv_max_alert/screens/add_alert_screen.dart';
import 'package:tgv_max_alert/screens/alert_trains_screen.dart';
import 'package:tgv_max_alert/utils/api/api.dart';
import 'package:tgv_max_alert/utils/preferences.dart';
import 'package:tgv_max_alert/widgets/alert_row.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<AlertFetched> _alerts = [];

  @override
  void initState() {
    super.initState();
    final initAndroid = AndroidInitializationSettings('ic_notif_train');
    final initIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    flutterLocalNotif.initialize(
      InitializationSettings(initAndroid, initIOS),
      onSelectNotification: onSelectNotification,
    );

    _initAlerts();
  }

  Future<void> onDidReceiveLocalNotification(
    int id,
    String title,
    String body,
    String payload,
  ) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () => onSelectNotification(payload),
              ),
            ],
          ),
    );
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload == null) return;

    try {
      Alert notifAlert = Alert.fromRawJson(payload);
      Alert alert = Preferences.instance.searchAlertById(notifAlert.uuid);

      if (alert == null) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => AlertTrainsScreen(data: AlertFetched(alert: alert)),
        ),
        (Route<dynamic> route) => route.isFirst,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _initAlerts() {
    _alerts = Preferences.instance.alerts
        .map((alert) => AlertFetched(alert: alert))
        .toList();
    _fetchAllAlerts();
  }

  Future<void> _fetchAllAlerts() async {
    List<AlertFetched> alerts = await Api.getAllAlerts();
    _alerts.clear();
    _alerts.addAll(alerts);
    setState(() {});
  }

  void _onAlertTap(AlertFetched alert) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AlertTrainsScreen(data: alert),
    ));
  }

  void _duplicateAlert(Alert alert) {
    Alert duplicate = alert.duplicate();
    _alerts.add(AlertFetched(alert: duplicate));
    Preferences.instance.addAlert(duplicate);
    setState(() {});
    _fetchAllAlerts();
  }

  void _deleteAlert(Alert alert) {
    Preferences.instance.removeAlert(alert);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        key: _scaffoldKey,
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
                child: RefreshIndicator(
                  onRefresh: _fetchAllAlerts,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 75),
                    itemCount: _alerts.length,
                    itemBuilder: (_, index) {
                      return AlertRow(
                        alertFetched: _alerts[index],
                        onLongPress: _duplicateAlert,
                        onDelete: _deleteAlert,
                        onTap: _onAlertTap,
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 0),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Ajouter"),
          icon: const Icon(Icons.add),
          onPressed: () async {
            Alert alert = await Navigator.of(context).push<Alert>(
              MaterialPageRoute(builder: (_) => AddAlertScreen()),
            );
            if (alert == null) return;
            Preferences.instance.addAlert(alert);
            _initAlerts();
          },
        ),
      ),
    );
  }
}
