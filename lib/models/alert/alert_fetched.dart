import 'package:meta/meta.dart';
import 'package:tgv_max_alert/models/alert/alert.dart';
import 'package:tgv_max_alert/models/sncf/sncf_response.dart';

class AlertFetched {
  Alert alert;
  SncfResponse sncfResponse;

  AlertFetched({@required this.alert, this.sncfResponse});
}
