import 'package:shared_preferences/shared_preferences.dart';
import 'package:tgv_max_alert/models/alert/alert.dart';

class Preferences {
  static SharedPreferences sharedPreferences;

  ///
  /// Singleton Factory
  ///
  static final instance = Preferences._internal();
  Preferences._internal();

  List<Alert> _alerts = [];
  List<String> _notifiedAlerts = [];

  /**
   * Handle TGVMAX alerts
   */
  List<Alert> get alerts => _alerts ?? [];

  set alerts(List<Alert> alerts) {
    _alerts = alerts;
    sharedPreferences.setStringList(
      "alerts",
      alerts.map((a) => a.toRawJson()).toList(),
    );
  }

  void addAlert(Alert alert) {
    if (alert == null) return;
    alerts = _alerts..add(alert);
  }

  void removeAlert(Alert alert) {
    alerts = _alerts..removeWhere((a) => a.uuid == alert.uuid);
  }

  Alert searchAlertById(String uuid) {
    return _alerts.firstWhere((a) => a.uuid == uuid, orElse: () => null);
  }

  void _filterAlerts() {
    final now = DateTime.now();
    _alerts?.sort((a, b) => a.departureDate.compareTo(b.departureDate));
    int oldLength = _alerts?.length ?? 0;
    _alerts?.removeWhere(
      (a) => a.departureDate.add(Duration(hours: 6)).isBefore(now),
    );
    if (oldLength != (_alerts?.length ?? 0)) {
      alerts = _alerts;
    }
  }

  /**
   * Handle notified alerts uuid
   */
  List<String> get notifiedAlerts => _notifiedAlerts ?? [];

  set notifiedAlerts(List<String> notifiedALerts) {
    _notifiedAlerts = notifiedALerts;
    sharedPreferences.setStringList("notified_alerts", _notifiedAlerts);
  }

  /**
   * Handle initialization of preferences
   */
  void initPrefs() {
    _alerts = (sharedPreferences.getStringList("alerts") ?? <String>[])
        .map((v) => Alert.fromRawJson(v))
        .toList();
    _filterAlerts();

    _notifiedAlerts = sharedPreferences.getStringList("notified_alerts") ?? <String>[];
  }
}
