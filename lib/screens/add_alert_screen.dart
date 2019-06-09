import 'package:flutter/material.dart';

class AddAlertScreen extends StatefulWidget {
  AddAlertScreen({Key key}) : super(key: key);

  _AddAlertScreenState createState() => _AddAlertScreenState();
}

class _AddAlertScreenState extends State<AddAlertScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add alert"),
      ),
    );
  }
}