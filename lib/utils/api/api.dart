import 'package:dio/dio.dart';
import 'package:tgv_max_alert/models/alert.dart';
import 'package:tgv_max_alert/models/alert_fetched.dart';
import 'package:tgv_max_alert/models/payload/payload.dart';
import 'package:tgv_max_alert/models/sncf_api_response.dart';
import 'package:tgv_max_alert/models/sncf_gare.dart';
import 'package:tgv_max_alert/utils/preferences.dart';

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

  static Future<List<SncfStation>> getStations(String q, bool isOrigin) async {
    final httpRes = await Dio().get(
      'https://booking.oui.sncf/booking/autocomplete-d2d',
      queryParameters: {
        'uc': 'fr-FR',
        'searchField': isOrigin ? 'origin' : 'destination',
        'searchTerm': q,
      },
    );

    return List<SncfStation>.from(
      httpRes.data.map((x) => SncfStation.fromJson(x)),
    ).where((s) => s.category == "station").toList();
  }

  static Future<List<SncfStation>> getDepartureStations(String search) async {
    return getStations(search, true);
  }

  static Future<List<SncfStation>> getArrivalStations(String search) async {
    return getStations(search, false);
  }

  static Future<List<AlertFetched>> getAllAlerts() async {
    final alerts = Preferences.instance.getAlerts();

    return await Future.wait<AlertFetched>(
      alerts.map<Future<AlertFetched>>((a) async {
        final sncfResponse = await Api.getTrainsData(a);
        return AlertFetched(alert: a, sncfResponse: sncfResponse);
      }),
    );
  }
}
