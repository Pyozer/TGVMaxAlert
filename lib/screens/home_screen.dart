import 'package:flutter/material.dart';
import 'package:tgv_max_alert/models/alert.dart';
import 'package:tgv_max_alert/screens/add_alert_screen.dart';
import 'package:tgv_max_alert/screens/alert_trains_screen.dart';
import 'package:tgv_max_alert/utils/preferences.dart';
import 'package:tgv_max_alert/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alerts = Preferences.instance.getAlerts();
    alerts.addAll(List.generate(
      10,
      (_) => Alert(
            origin: "Le Mans",
            originCode: "FRETK",
            destination: "Paris",
            destinationCode: "FRPMO",
            departureDate: DateTime(2019, 6, 10, 14),
          ),
    ));
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
              child: Text(
                "Alert",
                style: const TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 30.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
              child: Text(
                "TGVMax",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32.0,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: alerts.length,
                itemBuilder: (_, index) {
                  final alert = alerts[index];
                  return ListTile(
                    leading: Image.asset(
                      "assets/images/train_icon.png",
                      height: 40,
                      color: Colors.red,
                    ),
                    title: Text(
                      "${alert.origin} - ${alert.destination}",
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(capitalize(formatDate(alert.departureDate))),
                    trailing: Text(
                      formatHm(alert.departureDate),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AlertTrainsScreen(alert: alert),
                      ));
                    },
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Ajouter"),
        icon: const Icon(Icons.add_alert),
        onPressed: () async {
          final alert = await Navigator.of(context).push<Alert>(
            MaterialPageRoute(builder: (_) => AddAlertScreen()),
          );
          Preferences.instance.addAlert(alert);
        },
      ),
    );
  }
}
