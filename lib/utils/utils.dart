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

String formatDate(DateTime date) => DateFormat.MMMEd('fr_FR').format(date);