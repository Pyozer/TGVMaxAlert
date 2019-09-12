import 'dart:convert';

class ItineraryDetailsDestination {
  String cityLabelFr;
  String stationCode;
  String stationLabelFr;
  String zipCode;
  bool outsideFrance;

  ItineraryDetailsDestination({
    this.cityLabelFr,
    this.stationCode,
    this.stationLabelFr,
    this.zipCode,
    this.outsideFrance,
  });

  factory ItineraryDetailsDestination.fromRawJson(String str) =>
      ItineraryDetailsDestination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItineraryDetailsDestination.fromJson(Map<String, dynamic> json) =>
      ItineraryDetailsDestination(
        cityLabelFr: json["cityLabelFr"],
        stationCode: json["stationCode"],
        stationLabelFr: json["stationLabelFr"],
        zipCode: json["zipCode"],
        outsideFrance: json["outsideFrance"],
      );

  Map<String, dynamic> toJson() => {
        "cityLabelFr": cityLabelFr,
        "stationCode": stationCode,
        "stationLabelFr": stationLabelFr,
        "zipCode": zipCode,
        "outsideFrance": outsideFrance,
      };
}
