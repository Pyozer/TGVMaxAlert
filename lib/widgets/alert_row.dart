import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tgv_max_alert/models/alert.dart';
import 'package:tgv_max_alert/models/alert_fetched.dart';
import 'package:tgv_max_alert/utils/utils.dart';

typedef void OnEvent(Alert alert);

class AlertRow extends StatelessWidget {
  final AlertFetched alertFetched;
  final OnEvent onDelete;
  final OnEvent onLongPress;
  final VoidCallback onTap;

  const AlertRow({
    Key key,
    @required this.alertFetched,
    @required this.onLongPress,
    @required this.onDelete,
    @required this.onTap,
  }) : super(key: key);

  Future<bool> _showDeleteSnack(BuildContext context) async {
    Scaffold.of(context).removeCurrentSnackBar();
    final reason = await Scaffold.of(context)
        .showSnackBar(
          SnackBar(
            content: Text("Suppression de l'alerte..."),
            duration: const Duration(milliseconds: 1500),
            action: SnackBarAction(
              label: "Annuler",
              textColor: Colors.yellow,
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar(
                  reason: SnackBarClosedReason.action,
                );
              },
            ),
          ),
        )
        .closed;
    return reason != SnackBarClosedReason.action;
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTgvMax = alertFetched.sncfResponse?.isAtLeastOneTgvMax();

    return Dismissible(
      key: Key(alertFetched.alert.uuid),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        bool isDeleted = await _showDeleteSnack(context);
        if (isDeleted) onDelete(alertFetched.alert);
        return isDeleted;
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(right: 18.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 28.0,
          ),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: () => onLongPress(alertFetched.alert),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              isTgvMax == null
                  ? const SizedBox(
                      width: 40.0,
                      child: CircularProgressIndicator(),
                    )
                  : Image.asset(
                      "assets/images/train_icon.png",
                      height: 40,
                      color: isTgvMax ? Colors.green : Colors.red,
                    ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText(alertFetched.alert.origin),
                    const SizedBox(height: 3.0),
                    _buildText(alertFetched.alert.destination),
                    const SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 13.0,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 2.0),
                        Text(capitalize(
                          formatMediumDate(alertFetched.alert.departureDate),
                        )),
                        const SizedBox(width: 12.0),
                        Icon(
                          Icons.access_time,
                          size: 13.0,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 2.0),
                        Text(formatHm(alertFetched.alert.departureDate)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
