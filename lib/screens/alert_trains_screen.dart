import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tgv_max_alert/models/payload/payload.dart';
import 'package:tgv_max_alert/models/sncf_api_response.dart';
import 'package:dio/dio.dart';
import 'package:tgv_max_alert/utils/utils.dart';
import 'package:tgv_max_alert/widgets/a_to_b_painter.dart';
import 'package:tgv_max_alert/widgets/trains_details/train_proposal.dart';

const API_URL = "https://www.oui.sncf/proposition/rest/search-travels/outward";

class AlertTrainsScreen extends StatefulWidget {
  AlertTrainsScreen({Key key}) : super(key: key);

  @override
  _AlertTrainsScreenState createState() => _AlertTrainsScreenState();
}

class _AlertTrainsScreenState extends State<AlertTrainsScreen> {
  Future<SncfApiResponse> _fetchApi() async {
    final httpRes = await Dio().post(
      API_URL,
      data: Payload(
        origin: "PARIS (intramuros)",
        originCode: "FRPMO",
        destination: "LE MANS",
        destinationCode: "FRAET",
        departureDate: DateTime(2019, 06, 9, 9),
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

  @override
  Widget build(BuildContext context) {
    const originStyle = TextStyle(
      color: Colors.white,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );
    final destinationStyle = originStyle.copyWith(
      color: Colors.amber[700],
    );

    const subtitleStyle = TextStyle(color: Colors.white70);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "${capitalize(formatDate(DateTime(2019, 6, 9, 9)))} - ${formatHm(DateTime(2019, 6, 9, 9))}",
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(39.0, 0.0, 23.0, 16.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  CustomPaint(
                    size: const Size(25, 110),
                    painter: AToBPainter(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Paris Montparnasse",
                            style: originStyle,
                            maxLines: 1,
                          ),
                        ),
                        Text("Départ", style: subtitleStyle),
                        const SizedBox(height: 24.0),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Gare Le Mans",
                            style: destinationStyle,
                            maxLines: 1,
                          ),
                        ),
                        Text("Arrivée", style: subtitleStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: FutureBuilder<SncfApiResponse>(
                future: _fetchApi(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  if (snap.hasError) return Text(snap.error.toString());

                  return RefreshIndicator(
                    onRefresh: _fetchApi,
                    child: ListView.separated(
                      itemCount: snap.data.trainProposals.length,
                      separatorBuilder: (_, __) => const Divider(height: 0),
                      itemBuilder: (_, index) {
                        return TrainProposalRow(
                          trainProposal: snap.data.trainProposals[index],
                          itineraryDetails: snap.data.itineraryDetails,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
