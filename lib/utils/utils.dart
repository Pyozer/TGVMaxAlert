import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String capitalize(String text) {
  if (text.length < 2) return text.toUpperCase();
  return text.substring(0, 1).toUpperCase() + text.substring(1, text.length);
}

String formatPrice(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
}

String formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60);
  return "${duration.inHours}:${minutes.toString().padLeft(2, "0")}";
}

String formatHm(DateTime date) => DateFormat.Hm().format(date);
String formatTimeHm(TimeOfDay time) {
  return formatHm(DateTime(2019, 1, 1, time.hour, time.minute));
}

String formatDate(DateTime date) => DateFormat.MMMEd('fr_FR').format(date);
String formatDOBDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
String formatMediumDate(DateTime date) =>
    DateFormat.MMMMEEEEd('fr_FR').format(date);

DateTime mergeDateAndTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
