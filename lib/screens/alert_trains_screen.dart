import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tgv_max_alert/models/alert_fetched.dart';
import 'package:tgv_max_alert/models/sncf_api_response.dart';
import 'package:tgv_max_alert/utils/api/api.dart';
import 'package:tgv_max_alert/utils/utils.dart';
import 'package:tgv_max_alert/widgets/a_to_b_painter.dart';
import 'package:tgv_max_alert/widgets/trains_details/train_proposal_row.dart';

class AlertTrainsScreen extends StatelessWidget {
  AlertTrainsScreen({Key key, @required this.data}) : super(key: key);

  final AlertFetched data;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<SncfApiResponse> _fetchData() async {
    _refreshKey?.currentState?.show();
    data.sncfResponse = await Api.getTrainsData(data.alert);
    return data.sncfResponse;
  }

  @override
  Widget build(BuildContext context) {
    const originStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w700,
    );
    final destinationStyle = originStyle.copyWith(
      color: Colors.amber[700],
    );

    const subtitleStyle = TextStyle(color: Colors.white70);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${capitalize(formatDate(data.alert.departureDate))} - ${formatHm(data.alert.departureDate)}",
        ),
        centerTitle: true,
        elevation: 0,
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
                            data.alert.origin,
                            style: originStyle,
                            maxLines: 1,
                          ),
                        ),
                        Text("Départ", style: subtitleStyle),
                        const SizedBox(height: 24.0),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            data.alert.destination,
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
              child: RefreshIndicator(
                key: _refreshKey,
                onRefresh: () => Api.getTrainsData(data.alert),
                child: FutureBuilder<SncfApiResponse>(
                    future: _fetchData(),
                    initialData: data.sncfResponse,
                    builder: (context, snap) {
                      if (!snap.hasData &&
                          snap.connectionState == ConnectionState.waiting)
                        return const Center(child: CircularProgressIndicator());
                      if (snap.hasError) return Text(snap.error.toString());

                      if (snap.data.status == "NO_RESULTS")
                        return Center(child: Text("No result :/"));

                      return ListView.separated(
                        itemCount: snap.data.trainProposals.length,
                        separatorBuilder: (_, __) => const Divider(height: 0),
                        itemBuilder: (_, index) {
                          return TrainProposalRow(
                            trainProposal: snap.data.trainProposals[index],
                            itineraryDetails: snap.data.itineraryDetails,
                          );
                        },
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
