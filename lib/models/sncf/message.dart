import 'dart:convert';

class Message {
  String body;
  String type;
  bool isHidden;

  Message({this.body, this.type, this.isHidden});

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        body: json["body"],
        type: json["type"],
        isHidden: json["isHidden"],
      );

  Map<String, dynamic> toJson() =>
      {"body": body, "type": type, "isHidden": isHidden};
}
