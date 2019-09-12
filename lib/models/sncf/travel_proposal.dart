import 'dart:convert';

import 'package:tgv_max_alert/models/sncf/class_offers.dart';
import 'package:tgv_max_alert/models/sncf/segment.dart';
import 'package:tgv_max_alert/models/sncf/travel_proposal_destination.dart';
import 'package:tgv_max_alert/models/sncf/unsellable_reason.dart';

class TravelProposal {
  String id;
  List<Segment> segments;
  ClassOffers firstClassOffers;
  ClassOffers secondClassOffers;
  UnsellableReason unsellableReason;
  String travelType;
  TravelProposalDestination origin;
  TravelProposalDestination destination;
  DateTime departureDate;
  DateTime arrivalDate;
  double minPrice;
  Duration duration;
  bool isIncomplete;
  bool isHighlight;

  TravelProposal({
    this.id,
    this.segments,
    this.firstClassOffers,
    this.secondClassOffers,
    this.unsellableReason,
    this.travelType,
    this.origin,
    this.destination,
    this.departureDate,
    this.arrivalDate,
    this.minPrice,
    this.duration,
    this.isIncomplete,
    this.isHighlight,
  });

  factory TravelProposal.fromRawJson(String str) =>
      TravelProposal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TravelProposal.fromJson(Map<String, dynamic> json) => TravelProposal(
        id: json["id"],
        segments: List<Segment>.from(
          json["segments"].map((x) => Segment.fromJson(x)),
        ),
        firstClassOffers: json["firstClassOffers"] != null
            ? ClassOffers.fromJson(json["firstClassOffers"])
            : null,
        secondClassOffers: json["secondClassOffers"] != null
            ? ClassOffers.fromJson(json["secondClassOffers"])
            : null,
        unsellableReason: json["unsellableReason"] != null
            ? UnsellableReason.fromJson(json["unsellableReason"])
            : null,
        travelType: json["travelType"],
        origin: TravelProposalDestination.fromJson(json["origin"]),
        destination: TravelProposalDestination.fromJson(json["destination"]),
        departureDate: DateTime.parse(json["departureDate"]),
        arrivalDate: DateTime.parse(json["arrivalDate"]),
        minPrice: double.parse(json["minPrice"].toString()),
        duration: Duration(seconds: json["duration"]),
        isIncomplete: json["isIncomplete"],
        isHighlight: json["isHighlight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "segments": List<dynamic>.from((segments ?? []).map((x) => x.toJson())),
        "firstClassOffers": firstClassOffers?.toJson(),
        "secondClassOffers": secondClassOffers?.toJson(),
        "unsellableReason": unsellableReason?.toJson(),
        "travelType": travelType,
        "origin": origin.toJson(),
        "destination": destination.toJson(),
        "departureDate": departureDate.toIso8601String(),
        "arrivalDate": arrivalDate.toIso8601String(),
        "minPrice": minPrice,
        "duration": duration.inSeconds,
        "isIncomplete": isIncomplete,
        "isHighlight": isHighlight,
      };

  bool isOffers() => firstClassOffers != null || secondClassOffers != null;

  bool isAtLeastOneTgvMax() => minPrice == 0.0;
}
