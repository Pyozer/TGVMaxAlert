import 'package:shared_preferences/shared_preferences.dart';
import 'package:tgv_max_alert/models/alert.dart';

class Preferences {
  static SharedPreferences sharedPreferences;

  ///
  /// Singleton Factory
  ///
  static final instance = Preferences._internal();
  Preferences._internal();

  List<Alert> _alerts;

  List<Alert> getAlerts() {
    return _alerts ?? [];
  }

  void setAlerts(List<Alert> alerts) {
    _alerts = alerts;
    sharedPreferences.setStringList(
      "alerts",
      alerts.map((a) => a.toRawJson()).toList(),
    );
  }

  void addAlert(Alert alert) {
    if (alert == null) return;
    _alerts.add(alert);
    setAlerts(_alerts);
  }

  void initPrefs() {
    _alerts = (sharedPreferences.getStringList("alerts") ?? <String>[])
        .map((v) => Alert.fromRawJson(v))
        .toList();
  }
}
