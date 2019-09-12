import 'dart:convert';

import 'package:tgv_max_alert/models/sncf/segmentation_destination.dart';

class Segment {
  String type;
  String id;
  DateTime departureDate;
  DateTime arrivalDate;
  SegmentDestination origin;
  SegmentDestination destination;
  String segmentType;
  int duration;
  String transporter;
  String distributor;
  List<String> services;
  List<String> highlightFeatures;
  String vehicleNumber;
  String vehicleType;
  bool incomplete;
  int actualDuration;
  bool isFirst;
  bool isLast;
  bool hasPerturbations;
  bool isTransit;

  Segment({
    this.type,
    this.id,
    this.departureDate,
    this.arrivalDate,
    this.origin,
    this.destination,
    this.segmentType,
    this.duration,
    this.transporter,
    this.distributor,
    this.services,
    this.highlightFeatures,
    this.vehicleNumber,
    this.vehicleType,
    this.incomplete,
    this.actualDuration,
    this.isFirst,
    this.isLast,
    this.hasPerturbations,
    this.isTransit,
  });

  factory Segment.fromRawJson(String str) => Segment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Segment.fromJson(Map<String, dynamic> json) => Segment(
        type: json["@type"],
        id: json["id"],
        departureDate: DateTime.parse(json["departureDate"]),
        arrivalDate: DateTime.parse(json["arrivalDate"]),
        origin: SegmentDestination.fromJson(json["origin"]),
        destination: SegmentDestination.fromJson(json["destination"]),
        segmentType: json["type"],
        duration: json["duration"],
        transporter: json["transporter"],
        distributor: json["distributor"],
        services: List<String>.from((json["services"] ?? []).map((x) => x)),
        highlightFeatures: List<String>.from(
          (json["highlightFeatures"] ?? []).map((x) => x),
        ),
        vehicleNumber: json["vehicleNumber"],
        vehicleType: json["vehicleType"],
        incomplete: json["incomplete"],
        actualDuration: json["actualDuration"],
        isFirst: json["isFirst"],
        isLast: json["isLast"],
        hasPerturbations: json["hasPerturbations"],
        isTransit: json["isTransit"],
      );

  Map<String, dynamic> toJson() => {
        "@type": type,
        "id": id,
        "departureDate": departureDate.toIso8601String(),
        "arrivalDate": arrivalDate.toIso8601String(),
        "origin": origin.toJson(),
        "destination": destination.toJson(),
        "type": segmentType,
        "duration": duration,
        "transporter": transporter,
        "distributor": distributor,
        "services": List<dynamic>.from(services.map((x) => x)),
        "highlightFeatures": List<dynamic>.from(
          highlightFeatures.map((x) => x),
        ),
        "vehicleNumber": vehicleNumber,
        "vehicleType": vehicleType,
        "incomplete": incomplete,
        "actualDuration": actualDuration,
        "isFirst": isFirst,
        "isLast": isLast,
        "hasPerturbations": hasPerturbations,
        "isTransit": isTransit,
      };
}
