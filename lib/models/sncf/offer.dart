import 'dart:convert';

class Offer {
  String id;
  String travelClass;
  double amount;
  bool isDisabled;

  Offer({this.id, this.travelClass, this.amount, this.isDisabled});

  factory Offer.fromRawJson(String str) => Offer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        travelClass: json["travelClass"],
        amount: double.parse(json["amount"].toString()),
        isDisabled: json["isDisabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "travelClass": travelClass,
        "amount": amount,
        "isDisabled": isDisabled,
      };
}