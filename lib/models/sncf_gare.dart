import 'dart:convert';

class SncfStation {
  String category;
  String label;
  String id;
  double longitude;
  double latitude;

  SncfStation({
    this.category,
    this.label,
    this.id,
    this.longitude,
    this.latitude,
  });

  factory SncfStation.fromRawJson(String str) =>
      SncfStation.fromJson(json.decode(str));

  factory SncfStation.fromJson(Map<String, dynamic> json) => SncfStation(
        category: json["category"],
        label: json["label"],
        id: json["id"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "category": category,
        "label": label,
        "id": id,
        "longitude": longitude,
        "latitude": latitude,
      };
}
