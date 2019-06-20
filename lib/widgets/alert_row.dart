import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tgv_max_alert/models/alert.dart';
import 'package:tgv_max_alert/models/alert_fetched.dart';
import 'package:tgv_max_alert/utils/utils.dart';

typedef void OnEvent(Alert alert);
typedef void OnTap(AlertFetched alertFetched);

class AlertRow extends StatelessWidget {
  final AlertFetched alertFetched;
  final OnEvent onDelete;
  final OnEvent onLongPress;
  final OnTap onTap;

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

  Widget _buildIcon() {
    final isTgvMax = alertFetched.sncfResponse?.isAtLeastOneTgvMax();
    final errors = alertFetched.sncfResponse?.validationErrors ?? [];

    if (isTgvMax == null) {
      return const SizedBox(
        width: 40.0,
        child: CircularProgressIndicator(),
      );
    }
    if (errors.isNotEmpty) {
      return const Icon(Icons.close, color: Colors.red, size: 40.0);
    }
    return Image.asset(
      "assets/images/train_icon.png",
      height: 40,
      color: isTgvMax ? Colors.green : Colors.red,
    );
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
        onTap: () => onTap(alertFetched),
        onLongPress: () => onLongPress(alertFetched.alert),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(child: _buildIcon(), width: 40.0, height: 40.0),
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
                        const SizedBox(width: 3.0),
                        Text(capitalize(formatMediumDate(
                          alertFetched.alert.departureDate,
                        ))),
                        const SizedBox(width: 8.0),
                        Icon(
                          Icons.access_time,
                          size: 13.0,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 3.0),
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
