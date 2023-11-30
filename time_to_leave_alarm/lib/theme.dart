import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    primaryColor: const Color.fromRGBO(194, 123, 101, 1),
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(100, 194, 123, 101)),
    useMaterial3: true,
  );
}
