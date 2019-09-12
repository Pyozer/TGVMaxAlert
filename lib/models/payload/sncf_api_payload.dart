import 'dart:convert';

import 'package:tgv_max_alert/utils/utils.dart';

class SncfApiPayload {
  DateTime departureDate;
  String originCode;
  String destinationCode;
  String tgvMaxNumber;
  DateTime dateOfBirth;

  SncfApiPayload({
    this.departureDate,
    this.originCode,
    this.destinationCode,
    this.tgvMaxNumber,
    this.dateOfBirth,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "context": {
          "paginationContext": {
            "travelSchedule": {
              "departureDate": departureDate.toIso8601String(),
            }
          }
        },
        "wish": {
          "mainJourney": {
            "origin": {
              "code": originCode,
            },
            "destination": {
              "code": destinationCode,
            }
          },
          "schedule": {
            "outward": departureDate.toIso8601String(),
          },
          "travelClass": "SECOND",
          "passengers": [
            {
              "typology": "YOUNG",
              "discountCard": {
                "code": "HAPPY_CARD",
                "number": tgvMaxNumber,
                "dateOfBirth": formatDOBDate(dateOfBirth),
              }
            }
          ],
          "salesMarket": "fr-FR"
        }
      };
}
