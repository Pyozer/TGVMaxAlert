import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tgv_max_alert/app.dart';
import 'package:tgv_max_alert/utils/preferences.dart';

void main() async {
  initializeDateFormatting("fr_FR");

  Preferences.sharedPreferences = await SharedPreferences.getInstance();
  Preferences.instance.initPrefs();
  runApp(App());
}
