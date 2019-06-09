import 'package:flutter/material.dart';
import 'package:tgv_max_alert/screens/home_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TGVMax Alert',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF1A1A28),
      ),
      home: HomeScreen(),
    );
  }
}
