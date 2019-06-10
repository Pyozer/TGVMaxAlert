import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tgv_max_alert/models/alert.dart';
import 'package:tgv_max_alert/models/sncf_api_response.dart';
import 'package:tgv_max_alert/utils/api/api.dart';
import 'package:tgv_max_alert/utils/utils.dart';
import 'package:tgv_max_alert/widgets/a_to_b_painter.dart';
import 'package:tgv_max_alert/widgets/trains_details/train_proposal.dart';

class AlertTrainsScreen extends StatelessWidget {
  final Alert alert;

  AlertTrainsScreen({Key key, @required this.alert}) : super(key: key);

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
          "${capitalize(formatDate(alert.departureDate))} - ${formatHm(alert.departureDate)}",
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
                            alert.origin,
                            style: originStyle,
                            maxLines: 1,
                          ),
                        ),
                        Text("Départ", style: subtitleStyle),
                        const SizedBox(height: 24.0),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            alert.destination,
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
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: FutureBuilder<SncfApiResponse>(
                future: Api.getTrainsData(alert),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  if (snap.hasError) return Text(snap.error.toString());

                  if (snap.data.status == "NO_RESULTS")
                    return Center(child: Text("No result :/"));


                  return RefreshIndicator(
                    onRefresh: () => Api.getTrainsData(alert),
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
