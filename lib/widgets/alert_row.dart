import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tgv_max_alert/models/alert.dart';
import 'package:tgv_max_alert/screens/alert_trains_screen.dart';
import 'package:tgv_max_alert/utils/utils.dart';

typedef void OnEvent(Alert alert);

class AlertRow extends StatelessWidget {
  final Alert alert;
  final OnEvent onDelete;
  final OnEvent onLongPress;

  const AlertRow({
    Key key,
    @required this.alert,
    @required this.onLongPress,
    @required this.onDelete,
  }) : super(key: key);

  Future<bool> _showDeleteSnack(BuildContext context) async {
    final reason = await Scaffold.of(context)
        .showSnackBar(
          SnackBar(
            content: Text("Suppression de l'alerte..."),
            duration: const Duration(seconds: 2),
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
    return Dismissible(
      key: Key(alert.uuid),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return _showDeleteSnack(context);
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(right: 18.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 28.0,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AlertTrainsScreen(alert: alert),
          ));
        },
        onLongPress: () => onLongPress(alert),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                "assets/images/train_icon.png",
                height: 40,
                color: Colors.red,
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText(alert.origin),
                    const SizedBox(height: 3.0),
                    _buildText(alert.destination),
                    const SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today,
                            size: 13.0, color: Colors.grey[700]),
                        const SizedBox(width: 2.0),
                        Text(capitalize(formatMediumDate(alert.departureDate))),
                        const SizedBox(width: 12.0),
                        Icon(Icons.access_time,
                            size: 13.0, color: Colors.grey[700]),
                        const SizedBox(width: 2.0),
                        Text(formatHm(alert.departureDate)),
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
