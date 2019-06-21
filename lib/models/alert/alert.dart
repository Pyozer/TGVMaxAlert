import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class Alert {
  String uuid;
  String origin;
  String originCode;
  String destination;
  String destinationCode;
  DateTime departureDate;

  Alert({
    @required this.uuid,
    @required this.origin,
    @required this.originCode,
    @required this.destination,
    @required this.destinationCode,
    @required this.departureDate,
  });

  factory Alert.fromRawJson(String str) => Alert.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        uuid: json["uuid"],
        origin: json["origin"],
        originCode: json["originCode"],
        destination: json["destination"],
        destinationCode: json["destinationCode"],
        departureDate: DateTime.parse(json["departureDate"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "origin": origin,
        "originCode": originCode,
        "destination": destination,
        "destinationCode": destinationCode,
        "departureDate": departureDate.toIso8601String(),
      };

  Alert duplicate() => Alert(
        uuid: Uuid().v4(),
        departureDate: departureDate,
        destination: destination,
        destinationCode: destinationCode,
        origin: origin,
        originCode: originCode,
      );
}
