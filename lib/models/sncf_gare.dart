import 'dart:convert';

class SncfStation {
  String label;
  String id;
  double longitude;
  double latitude;

  SncfStation({this.label, this.id, this.longitude, this.latitude});

  factory SncfStation.fromRawJson(String str) =>
      SncfStation.fromJson(json.decode(str));

  factory SncfStation.fromJson(Map<String, dynamic> json) => SncfStation(
        label: json["label"],
        id: json["id"],
        longitude: json["longitude"].toDouble(),
        latitude: json["latitude"].toDouble(),
      );
      
  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "label": label,
        "id": id,
        "longitude": longitude,
        "latitude": latitude,
      };
}
