import 'dart:convert';

import 'package:tgv_max_alert/models/sncf/offer.dart';

class ClassOffers {
  double minPrice;
  List<Offer> offers;
  bool hasMultipleOffers;
  bool isIncomplete;

  ClassOffers({
    this.minPrice,
    this.offers,
    this.hasMultipleOffers,
    this.isIncomplete,
  });

  factory ClassOffers.fromRawJson(String str) =>
      ClassOffers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClassOffers.fromJson(Map<String, dynamic> json) => ClassOffers(
        minPrice: double.tryParse(json["minPrice"].toString()),
        offers: List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
        hasMultipleOffers: json["hasMultipleOffers"],
        isIncomplete: json["isIncomplete"],
      );

  Map<String, dynamic> toJson() => {
        "minPrice": minPrice,
        "offers": List<dynamic>.from(offers.map((x) => x.toJson())),
        "hasMultipleOffers": hasMultipleOffers,
        "isIncomplete": isIncomplete,
      };
}
