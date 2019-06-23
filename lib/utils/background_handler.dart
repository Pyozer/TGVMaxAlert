import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tgv_max_alert/models/alert/alert.dart';
import 'package:tgv_max_alert/utils/api/api.dart';
import 'package:tgv_max_alert/utils/preferences.dart';
import 'package:tgv_max_alert/utils/utils.dart';

Future<void> _showNotification(Alert alert) async {
  var androidPlatform = AndroidNotificationDetails(
    "tgvmaxalerts",
    "Alertes TGVMax",
    "Notification lorsqu'une place TGVMax est disponible",
    importance: Importance.High,
    priority: Priority.High,
    ticker: 'ticker',
    style: AndroidNotificationStyle.BigText,
  );
  var iOSPlatform = IOSNotificationDetails();
  var platformChannel = NotificationDetails(androidPlatform, iOSPlatform);
  final microSeconds = DateTime.now().microsecondsSinceEpoch.toString();

  await FlutterLocalNotificationsPlugin().show(
    int.parse(microSeconds.substring(microSeconds.length - 5)),
    'Place TGVMax disponible !',
    'Trajet ${alert.origin} - ${alert.destination}, pour le ${capitalize(formatMediumDate(alert.departureDate))}.',
    platformChannel,
    payload: alert.toRawJson(),
  );
}

void handleBackgroundFetch() async {
  print('[BackgroundFetch] Event received');
  // Init preferences
  await initializeDateFormatting("fr_FR");
  final sharedPrefs = await SharedPreferences.getInstance();
  Preferences.sharedPreferences = sharedPrefs;
  Preferences.instance.initPrefs();
  // Fetch all alerts
  final alertsFetched = await Api.getAllAlerts();
  bool isTgvMax = false;
  for (final alertFetched in alertsFetched) {
    if (alertFetched.sncfResponse.isAtLeastOneTgvMax()) {
      isTgvMax = true;
      await _showNotification(alertFetched.alert);
      print("Notif sent");
    }
  }

  BackgroundFetch.finish(
    isTgvMax
        ? BackgroundFetch.FETCH_RESULT_NEW_DATA
        : BackgroundFetch.FETCH_RESULT_NO_DATA,
  );
}
