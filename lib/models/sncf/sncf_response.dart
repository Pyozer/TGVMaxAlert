import 'dart:convert';

import 'package:tgv_max_alert/models/sncf/itinary_details.dart';
import 'package:tgv_max_alert/models/sncf/message.dart';
import 'package:tgv_max_alert/models/sncf/travel_proposal.dart';

class SncfResponse {
  String wishId;
  List<Message> messages;
  List<TravelProposal> travelProposals;
  String status;
  ItineraryDetails itineraryDetails;

  SncfResponse({
    this.wishId,
    this.messages,
    this.travelProposals,
    this.status,
    this.itineraryDetails,
  });

  factory SncfResponse.fromRawJson(String str) =>
      SncfResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SncfResponse.fromJson(Map<String, dynamic> json) => SncfResponse(
        wishId: json["wishId"],
        messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
        travelProposals: List<TravelProposal>.from(
          (json["travelProposals"] ?? []).map(
            (x) => TravelProposal.fromJson(x),
          ),
        ),
        status: json["status"],
        itineraryDetails: json["itineraryDetails"] != null
            ? ItineraryDetails.fromJson(json["itineraryDetails"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "wishId": wishId,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
        "travelProposals": List.from(
          travelProposals.map((x) => x.toJson()),
        ),
        "status": status,
        "itineraryDetails": itineraryDetails.toJson(),
      };

  bool isAtLeastOneTgvMax() {
    return travelProposals.any((t) => t.isAtLeastOneTgvMax());
  }
}
