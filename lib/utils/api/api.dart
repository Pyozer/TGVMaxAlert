import 'package:dio/dio.dart';
import 'package:tgv_max_alert/models/alert.dart';
import 'package:tgv_max_alert/models/payload/payload.dart';
import 'package:tgv_max_alert/models/sncf_api_response.dart';
import 'package:tgv_max_alert/models/sncf_gare.dart';

const API_URL = "https://www.oui.sncf/proposition/rest/search-travels/outward";

class Api {
  static Future<SncfApiResponse> getTrainsData(Alert alert) async {
    final httpRes = await Dio().post(
      API_URL,
      data: Payload(
        //origin: "PARIS (intramuros)",
        //originCode: "FRPMO",
        origin: alert.origin,
        originCode: alert.originCode,
        //destination: "LE MANS",
        //destinationCode: "FRAET",
        destination: alert.destination,
        destinationCode: alert.destinationCode,
        departureDate: alert.departureDate,
        passengers: [
          Passenger(
            birthDate: DateTime(1998, 05, 13),
            commercialCardNumber: "HC600394293",
          ),
        ],
      ).toJson(),
    );

    return SncfApiResponse.fromJson(httpRes.data);
  }

  static Future<List<SncfStation>> getStations(
    String search, [
    bool isOrigin = true,
  ]) async {
    final httpRes = await Dio().get(
      'https://booking.oui.sncf/booking/autocomplete-d2d',
      queryParameters: {
        'uc': 'fr-FR',
        'searchField': isOrigin ? 'origin' : 'destination',
        'searchTerm': search,
      },
    );

    return List<SncfStation>.from(
      httpRes.data.map((x) => SncfStation.fromJson(x)),
    );
  }
}
