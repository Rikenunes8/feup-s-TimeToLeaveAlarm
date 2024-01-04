import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}

String formatTime(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime);
}

DateTime stringToDateTime(dateTime) {
  return DateFormat('dd/MM/yyyy HH:mm').parse(dateTime);
}

String timeFromDateTime(String dateTime) {
  return formatTime(stringToDateTime(dateTime));
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}