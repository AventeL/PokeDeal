import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: const Color(0xFFEE6B2F),
    secondary: const Color(0xFF30A7D7),
    tertiary: const Color(0xFFD9D9D9),
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Color(0xFFEE6B2F)),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFFEE6B2F),
    secondary: const Color(0xFF30A7D7),
    tertiary: const Color(0xFFD9D9D9),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Color(0xFFEE6B2F)),
    ),
  ),
);
