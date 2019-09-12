import 'dart:convert';

import 'package:tgv_max_alert/models/sncf/city.dart';

class TravelProposalDestination {
  City station;
  City city;

  TravelProposalDestination({this.station, this.city});

  factory TravelProposalDestination.fromRawJson(String str) =>
      TravelProposalDestination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TravelProposalDestination.fromJson(Map<String, dynamic> json) =>
      TravelProposalDestination(
        station: City.fromJson(json["station"]),
        city: City.fromJson(json["city"]),
      );

  Map<String, dynamic> toJson() => {
        "station": station.toJson(),
        "city": city.toJson(),
      };
}
