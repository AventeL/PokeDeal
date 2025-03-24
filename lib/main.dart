import 'package:flutter/material.dart';
import 'package:pokedeal/core/utils/constants/color_constants.dart';
import 'package:pokedeal/features/Authentication/presentation/pages/authentication_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeDeal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        scaffoldBackgroundColor: bgLightColor,
      ),
      home: AuthenticationPage(),
    );
  }
}
