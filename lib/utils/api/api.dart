import 'package:dio/dio.dart';
import 'package:tgv_max_alert/models/alert/alert.dart';
import 'package:tgv_max_alert/models/alert/alert_fetched.dart';
import 'package:tgv_max_alert/models/payload/sncf_api_payload.dart';
import 'package:tgv_max_alert/models/sncf/sncf_response.dart';
import 'package:tgv_max_alert/models/sncf_gare.dart';
import 'package:tgv_max_alert/utils/preferences.dart';

const API_URL = "https://www.oui.sncf/proposition/rest/travels/outward/train/next";

class Api {
  static Future<SncfResponse> getTrainsData(Alert alert) async {
    final httpRes = await Dio().post(
      API_URL,
      data: SncfApiPayload(
        originCode: alert.originCode,
        destinationCode: alert.destinationCode,
        departureDate: alert.departureDate,
        dateOfBirth: DateTime(1998, 5, 13),
        tgvMaxNumber: "HC600394293",
      ).toJson(),
    );

    return SncfResponse.fromJson(httpRes.data);
  }

  static Future<List<SncfStation>> getStations(String q, bool isOrigin) async {
    final httpRes = await Dio().get(
      'https://www.oui.sncf/booking/autocomplete-d2d',
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
    final alerts = Preferences.instance.alerts;

    return await Future.wait<AlertFetched>(
      alerts.map<Future<AlertFetched>>((a) async {
        final sncfResponse = await Api.getTrainsData(a);
        return AlertFetched(alert: a, sncfResponse: sncfResponse);
      }),
    );
  }
}
