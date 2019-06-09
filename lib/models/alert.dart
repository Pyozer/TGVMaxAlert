import 'dart:convert';

import 'package:meta/meta.dart';

class Alert {
  String origin;
  String originCode;
  String destination;
  String destinationCode;
  DateTime departureDate;

  Alert({
    @required this.origin,
    @required this.originCode,
    @required this.destination,
    @required this.destinationCode,
    @required this.departureDate,
  });

  factory Alert.fromRawJson(String str) => Alert.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        origin: json["origin"],
        originCode: json["originCode"],
        destination: json["destination"],
        destinationCode: json["destinationCode"],
        departureDate: DateTime.parse(json["departureDate"]),
      );

  Map<String, dynamic> toJson() => {
        "origin": origin,
        "originCode": originCode,
        "destination": destination,
        "destinationCode": destinationCode,
        "departureDate": departureDate.toIso8601String(),
      };
}
