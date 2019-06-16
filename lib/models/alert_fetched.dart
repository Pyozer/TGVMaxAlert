import 'package:meta/meta.dart';
import 'package:tgv_max_alert/models/alert.dart';
import 'package:tgv_max_alert/models/sncf_api_response.dart';

class AlertFetched {
  Alert alert;
  SncfApiResponse sncfResponse;

  AlertFetched({@required this.alert, this.sncfResponse});
}
