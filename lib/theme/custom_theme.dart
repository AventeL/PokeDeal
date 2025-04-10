import 'package:flutter/material.dart';
import 'package:pokedeal/core/utils/constants/color_constants.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: const Color(0xFFD9D9D9),
    brightness: Brightness.light,
    error: errorColor,
    tertiaryContainer: Colors.white,
  ),
  disabledColor: Color(0xFFBDBDBD),
  scaffoldBackgroundColor: bgLightColor,
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
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: const Color(0xFFD9D9D9),
    error: errorColor,
    brightness: Brightness.dark,
    tertiaryContainer: const Color(0xFF424242),
  ),
  disabledColor: Color(0xFFBDBDBD),
  scaffoldBackgroundColor: bgDarkColor,
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
