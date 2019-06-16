import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tgv_max_alert/app.dart';
import 'package:tgv_max_alert/utils/preferences.dart';
import 'package:background_fetch/background_fetch.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask() async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish();
}

void main() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initializeDateFormatting("fr_FR");

  Preferences.sharedPreferences = await SharedPreferences.getInstance();
  Preferences.instance.initPrefs();
  runApp(App());

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}
