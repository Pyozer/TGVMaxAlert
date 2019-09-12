import 'dart:convert';

class UnsellableReason {
  String code;
  String label;

  UnsellableReason({this.code, this.label});

  factory UnsellableReason.fromRawJson(String str) =>
      UnsellableReason.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UnsellableReason.fromJson(Map<String, dynamic> json) =>
      UnsellableReason(code: json["code"], label: json["label"]);

  Map<String, dynamic> toJson() => {"code": code, "label": label};
}
