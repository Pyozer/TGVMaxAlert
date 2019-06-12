import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tgv_max_alert/main.dart';
import 'package:tgv_max_alert/screens/add_alert_screen.dart';
import 'package:tgv_max_alert/screens/home_screen.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    final initAndroid = AndroidInitializationSettings('ic_notif_train');
    final initIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(initAndroid, initIOS),
      onSelectNotification: onSelectNotification,
    );
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
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAlertScreen(),
                    ),
                  );
                },
              )
            ],
          ),
    );
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddAlertScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TGVMax Alert',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF1A1A28),
      ),
      home: HomeScreen(),
    );
  }
}
