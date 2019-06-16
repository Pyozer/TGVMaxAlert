import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tgv_max_alert/main.dart';
import 'package:tgv_max_alert/models/alert.dart';
import 'package:tgv_max_alert/utils/api/api.dart';
import 'package:tgv_max_alert/utils/utils.dart';

Future<void> _showNotification(Alert alert) async {
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
    int.parse(DateTime.now().microsecondsSinceEpoch.toString().substring(-6)),
    'Place TGVMax disponible !',
    'Trajet ${alert.origin} - ${alert.destination}, le ${formatMediumDate(alert.departureDate)}',
    platformChannel,
    payload: alert.toRawJson(),
  );
}

Future<int> handleBackgroundFetch() async {
  print('[BackgroundFetch] Event received');
  final alertsFetched = await Api.getAllAlerts();
  bool isTgvMax = false;
  for (final alertFetched in alertsFetched) {
    if (alertFetched.sncfResponse.isAtLeastOneTgvMax()) {
      isTgvMax = true;
      await _showNotification(alertFetched.alert);
      print("Notif sent");
    }
  }

  return isTgvMax
      ? BackgroundFetch.FETCH_RESULT_NEW_DATA
      : BackgroundFetch.FETCH_RESULT_NO_DATA;
}
