import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tgv_max_alert/models/sncf/itinary_details.dart';
import 'package:tgv_max_alert/models/sncf/travel_proposal.dart';
import 'package:tgv_max_alert/utils/utils.dart';

class TrainProposalRow extends StatelessWidget {
  final TravelProposal trainProposal;
  final ItineraryDetails itineraryDetails;

  const TrainProposalRow({
    Key key,
    this.trainProposal,
    this.itineraryDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      trailing: trainProposal.isOffers()
          ? Text(
              "${formatPrice(trainProposal.minPrice)}€",
              style: isTgvMax
                  ? baseTitleStyle.copyWith(color: Colors.green)
                  : baseTitleStyle,
            )
          : Text(
              trainProposal.unsellableReason?.label ?? "",
              style: priceStyle,
            ),
    );
  }
}
