import 'dart:convert';

class SncfApiResponse {
  List<TrainProposal> trainProposals;
  String status;
  List<ValidationError> validationErrors;
  ItineraryDetails itineraryDetails;
  bool containsFirstTrainOfDay;
  bool containsLastTrainOfDay;

  SncfApiResponse({
    this.trainProposals,
    this.status,
    this.validationErrors,
    this.itineraryDetails,
    this.containsFirstTrainOfDay,
    this.containsLastTrainOfDay,
  });

  factory SncfApiResponse.fromRawJson(String str) =>
      SncfApiResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SncfApiResponse.fromJson(Map<String, dynamic> json) =>
      SncfApiResponse(
        trainProposals: List<TrainProposal>.from(
          json["trainProposals"].map((x) => TrainProposal.fromJson(x)),
        ),
        status: json["status"],
        validationErrors: List<ValidationError>.from(
          json["validationErrors"].map((x) => ValidationError.fromJson(x)),
        ),
        itineraryDetails: json["itineraryDetails"] != null
            ? ItineraryDetails.fromJson(json["itineraryDetails"])
            : null,
        containsFirstTrainOfDay: json["containsFirstTrainOfDay"],
        containsLastTrainOfDay: json["containsLastTrainOfDay"],
      );

  Map<String, dynamic> toJson() => {
        "trainProposals": List<dynamic>.from(
          trainProposals?.map((x) => x.toJson()) ?? [],
        ),
        "status": status,
        "validationErrors": List<dynamic>.from(
          validationErrors?.map((x) => x.toJson()) ?? [],
        ),
        "itineraryDetails": itineraryDetails?.toJson(),
        "containsFirstTrainOfDay": containsFirstTrainOfDay,
        "containsLastTrainOfDay": containsLastTrainOfDay,
      };

  bool isAtLeastOneTgvMax() {
    return trainProposals.any((t) => t.isAtLeastOneTgvMax());
  }
}

class ItineraryDetails {
  Destination origin;
  Destination destination;

  ItineraryDetails({this.origin, this.destination});

  factory ItineraryDetails.fromRawJson(String str) =>
      ItineraryDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItineraryDetails.fromJson(Map<String, dynamic> json) =>
      ItineraryDetails(
        origin: Destination.fromJson(json["origin"]),
        destination: Destination.fromJson(json["destination"]),
      );

  Map<String, dynamic> toJson() => {
        "origin": origin.toJson(),
        "destination": destination.toJson(),
      };
}

class Destination {
  String cityCode;
  String cityLabel;
  String stationCode;
  String stationLabel;
  String zipCode;

  Destination({
    this.cityCode,
    this.cityLabel,
    this.stationCode,
    this.stationLabel,
    this.zipCode,
  });

  factory Destination.fromRawJson(String str) =>
      Destination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        cityCode: json["cityCode"],
        cityLabel: json["cityLabel"],
        stationCode: json["stationCode"],
        stationLabel: json["stationLabel"],
        zipCode: json["zipCode"],
      );

  Map<String, dynamic> toJson() => {
        "cityCode": cityCode,
        "cityLabel": cityLabel,
        "stationCode": stationCode,
        "stationLabel": stationLabel,
        "zipCode": zipCode,
      };
}

class TrainProposal {
  DateTime departureDate;
  DateTime arrivalDate;
  Duration duration;
  List<PriceProposal> priceProposals;
  List<Segment> segments;
  String originStationCode;
  String destinationStationCode;
  List<String> transporters;
  String id;

  TrainProposal({
    this.departureDate,
    this.arrivalDate,
    this.duration,
    this.priceProposals,
    this.segments,
    this.originStationCode,
    this.destinationStationCode,
    this.transporters,
    this.id,
  });

  factory TrainProposal.fromRawJson(String str) =>
      TrainProposal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TrainProposal.fromJson(Map<String, dynamic> json) => TrainProposal(
        departureDate: DateTime.parse(json["departureDate"]),
        arrivalDate: DateTime.parse(json["arrivalDate"]),
        duration: Duration(minutes: json["minuteDuration"]),
        priceProposals: List<PriceProposal>.from(
            json["priceProposals"].map((x) => PriceProposal.fromJson(x))),
        segments: List<Segment>.from(
            json["segments"].map((x) => Segment.fromJson(x))),
        originStationCode: json["originStationCode"],
        destinationStationCode: json["destinationStationCode"],
        transporters: List<String>.from(json["transporters"].map((x) => x)),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "departureDate": departureDate.toIso8601String(),
        "arrivalDate": arrivalDate.toIso8601String(),
        "minuteDuration": duration.inMinutes,
        "priceProposals": List<dynamic>.from(
          priceProposals.map((x) => x.toJson()),
        ),
        "segments": List<dynamic>.from(segments.map((x) => x.toJson())),
        "originStationCode": originStationCode,
        "destinationStationCode": destinationStationCode,
        "transporters": List<dynamic>.from(transporters.map((x) => x)),
        "id": id,
      };

  bool isAtLeastOneTgvMax() => priceProposals.any((p) => p.isTgvMax());
}

class PriceProposal {
  String id;
  double amount;
  String currency;
  String type;
  int remainingSeat;
  List<String> flags;

  PriceProposal({
    this.id,
    this.amount,
    this.currency,
    this.type,
    this.remainingSeat,
    this.flags,
  });

  factory PriceProposal.fromRawJson(String str) =>
      PriceProposal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PriceProposal.fromJson(Map<String, dynamic> json) => PriceProposal(
        id: json["id"],
        amount: json["amount"],
        currency: json["currency"],
        type: json["type"],
        remainingSeat: json["remainingSeat"],
        flags: List<String>.from(json["flags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "currency": currency,
        "type": type,
        "remainingSeat": remainingSeat,
        "flags": List<dynamic>.from(flags.map((x) => x)),
      };

  bool isTgvMax() => amount == 0.0 && remainingSeat > 0;
}

class Segment {
  int id;
  String originStationCode;
  DateTime departureDate;
  String destinationStationCode;
  DateTime arrivalDate;
  int minuteDuration;
  String trainType;
  String trainNumber;
  List<String> onboardServices;
  bool seatmapAvailable;
  String transporter;
  String functionnalId;

  Segment({
    this.id,
    this.originStationCode,
    this.departureDate,
    this.destinationStationCode,
    this.arrivalDate,
    this.minuteDuration,
    this.trainType,
    this.trainNumber,
    this.onboardServices,
    this.seatmapAvailable,
    this.transporter,
    this.functionnalId,
  });

  factory Segment.fromRawJson(String str) => Segment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Segment.fromJson(Map<String, dynamic> json) => Segment(
        id: json["id"],
        originStationCode: json["originStationCode"],
        departureDate: DateTime.parse(json["departureDate"]),
        destinationStationCode: json["destinationStationCode"],
        arrivalDate: DateTime.parse(json["arrivalDate"]),
        minuteDuration: json["minuteDuration"],
        trainType: json["trainType"],
        trainNumber: json["trainNumber"],
        onboardServices: List<String>.from(
          json["onboardServices"].map((x) => x),
        ),
        seatmapAvailable: json["seatmapAvailable"],
        transporter: json["transporter"],
        functionnalId: json["functionnalId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "originStationCode": originStationCode,
        "departureDate": departureDate.toIso8601String(),
        "destinationStationCode": destinationStationCode,
        "arrivalDate": arrivalDate.toIso8601String(),
        "minuteDuration": minuteDuration,
        "trainType": trainType,
        "trainNumber": trainNumber,
        "onboardServices": List<dynamic>.from(onboardServices.map((x) => x)),
        "seatmapAvailable": seatmapAvailable,
        "transporter": transporter,
        "functionnalId": functionnalId,
      };
}

class ValidationError {
  String label;
  String errorCode;

  ValidationError({this.label, this.errorCode});

  factory ValidationError.fromRawJson(String str) =>
      ValidationError.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      ValidationError(
        label: json["label"],
        errorCode: json["errorCode"],
      );

  Map<String, dynamic> toJson() => {"label": label, "errorCode": errorCode};
}
