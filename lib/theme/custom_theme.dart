import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: const Color(0xFFEE6B2F),
    secondary: const Color(0xFF30A7D7),
    tertiary: const Color(0xFFD9D9D9),
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: const Color(0xFFEE6B2F),
    secondary: const Color(0xFF30A7D7),
    tertiary: const Color(0xFFD9D9D9),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
);