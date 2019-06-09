import 'package:flutter/material.dart';
import 'package:tgv_max_alert/screens/alert_trains_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton.icon(
          icon: Icon(Icons.train),
          label: Text("Alert Details"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => AlertTrainsScreen()));
          },
        ),
      ),
    );
  }
}
