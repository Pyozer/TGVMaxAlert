import 'dart:convert';

import 'package:meta/meta.dart';

class Payload {
  String origin;
  String originCode;
  String destination;
  String destinationCode;
  bool directTravel;
  bool asymmetrical;
  bool professional;
  bool customerAccount;
  bool oneWayTravel;
  DateTime departureDate;
  String travelClass;
  List<Passenger> passengers;
  String outwardScheduleType;
  String inwardScheduleType;

  Payload({
    @required this.origin,
    @required this.originCode,
    @required this.destination,
    @required this.destinationCode,
    this.directTravel = false,
    this.asymmetrical = false,
    this.professional = false,
    this.customerAccount = true,
    this.oneWayTravel = true,
    @required this.departureDate,
    this.travelClass = "SECOND",
    @required this.passengers,
    this.outwardScheduleType = "BY_DEPARTURE_DATE",
    this.inwardScheduleType = "BY_DEPARTURE_DATE",
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "origin": origin,
        "originCode": originCode,
        "destination": destination,
        "destinationCode": destinationCode,
        "directTravel": directTravel,
        "asymmetrical": asymmetrical,
        "professional": professional,
        "customerAccount": customerAccount,
        "oneWayTravel": oneWayTravel,
        "departureDate": departureDate.toIso8601String().split('.')[0],
        "travelClass": travelClass,
        "passengers": List<dynamic>.from(passengers.map((x) => x.toJson())),
        "outwardScheduleType": outwardScheduleType,
        "inwardScheduleType": inwardScheduleType,
      };
}

class Passenger {
  String profile;
  DateTime birthDate;
  String commercialCardNumber;
  String commercialCardType;

  Passenger({
    this.profile = "YOUNG",
    @required this.birthDate,
    @required this.commercialCardNumber,
    this.commercialCardType = "HAPPY_CARD",
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "profile": profile,
        "birthDate": birthDate.toIso8601String().split('.')[0],
        "commercialCardNumber": commercialCardNumber,
        "commercialCardType": commercialCardType,
      };
}
