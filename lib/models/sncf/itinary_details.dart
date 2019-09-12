import 'dart:convert';

import 'package:tgv_max_alert/models/sncf/itinary_details_destination.dart';

class ItineraryDetails {
  ItineraryDetailsDestination origin;
  ItineraryDetailsDestination destination;
  bool international;

  ItineraryDetails({this.origin, this.destination, this.international});

  factory ItineraryDetails.fromRawJson(String str) =>
      ItineraryDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItineraryDetails.fromJson(Map<String, dynamic> json) =>
      ItineraryDetails(
        origin: ItineraryDetailsDestination.fromJson(json["origin"]),
        destination: ItineraryDetailsDestination.fromJson(json["destination"]),
        international: json["international"],
      );

  Map<String, dynamic> toJson() => {
        "origin": origin.toJson(),
        "destination": destination.toJson(),
        "international": international,
      };
}

