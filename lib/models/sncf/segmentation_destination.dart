import 'dart:convert';

import 'package:tgv_max_alert/models/sncf/city.dart';

class SegmentDestination {
  City station;

  SegmentDestination({this.station});

  factory SegmentDestination.fromRawJson(String str) =>
      SegmentDestination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SegmentDestination.fromJson(Map<String, dynamic> json) =>
      SegmentDestination(station: City.fromJson(json["station"]));

  Map<String, dynamic> toJson() => {"station": station.toJson()};
}
