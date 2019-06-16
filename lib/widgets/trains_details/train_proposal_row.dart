import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tgv_max_alert/models/sncf_api_response.dart';
import 'package:tgv_max_alert/utils/utils.dart';

class TrainProposalRow extends StatelessWidget {
  final TrainProposal trainProposal;
  final ItineraryDetails itineraryDetails;

  const TrainProposalRow({
    Key key,
    this.trainProposal,
    this.itineraryDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    trainProposal.priceProposals.sort((a, b) => a.amount.compareTo(b.amount));
    final price = trainProposal.priceProposals.length > 0
        ? trainProposal.priceProposals[0]
        : null;

    final textTheme = Theme.of(context).textTheme;
    final baseTitleStyle = textTheme.title.copyWith(
      fontWeight: FontWeight.w700,
    );
    final priceStyle = baseTitleStyle.copyWith(fontSize: 16.0);
    final isTgvMax = trainProposal.isAtLeastOneTgvMax();

    return ListTile(
      title: Text(
        "${formatHm(trainProposal.departureDate)} - ${formatHm(trainProposal.arrivalDate)}",
        style: baseTitleStyle,
      ),
      subtitle: Text(
        "Durée ${formatDuration(trainProposal.duration)}",
        style: textTheme.caption,
      ),
      leading: Image.asset(
        "assets/images/train_icon.png",
        height: 40.0,
        color: isTgvMax ? Colors.green : Colors.red,
      ),
      trailing: price != null
          ? Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 5.0,
              children: [
                Text(
                  "${formatPrice(price.amount)}€",
                  style: isTgvMax
                      ? priceStyle.copyWith(color: Colors.green)
                      : priceStyle,
                ),
                Text("${price.remainingSeat} places", style: textTheme.caption),
              ],
            )
          : Text("Complet", style: priceStyle),
    );
  }
}
