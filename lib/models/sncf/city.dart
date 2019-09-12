import 'dart:convert';

class City {
  String label;

  City({this.label});

  factory City.fromRawJson(String str) => City.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory City.fromJson(Map<String, dynamic> json) =>
      City(label: json["label"]);

  Map<String, dynamic> toJson() => {"label": label};
}
