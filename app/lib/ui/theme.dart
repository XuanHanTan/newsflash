import 'package:flutter/material.dart';

final defaultLightTheme = ThemeData.light();
final lightTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.yellow, brightness: Brightness.light),
  textTheme: defaultLightTheme.textTheme.copyWith(
    labelSmall: defaultLightTheme.textTheme.labelSmall!
        .copyWith(fontFamily: "Golos Text"),
    labelLarge: defaultLightTheme.textTheme.labelLarge!
        .copyWith(fontFamily: "Golos Text"),
    bodyMedium: defaultLightTheme.textTheme.bodyMedium!
        .copyWith(fontFamily: "Roboto Serif"),
    titleLarge: defaultLightTheme.textTheme.titleLarge!
        .copyWith(fontFamily: "Roboto Serif", fontWeight: FontWeight.w600),
    displaySmall: defaultLightTheme.textTheme.displaySmall!
        .copyWith(fontFamily: "Roboto Serif", fontWeight: FontWeight.w600),
    headlineMedium: defaultLightTheme.textTheme.headlineMedium!
        .copyWith(fontFamily: "Roboto Serif", fontWeight: FontWeight.w600),
    headlineLarge: defaultLightTheme.textTheme.headlineLarge!
        .copyWith(fontFamily: "Roboto Serif", fontWeight: FontWeight.bold),
  ),
);

final defaultDarkTheme = ThemeData.dark();
final darkTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.yellow, brightness: Brightness.dark),
  textTheme: defaultDarkTheme.textTheme.copyWith(
    labelSmall: defaultDarkTheme.textTheme.labelSmall!
        .copyWith(fontFamily: "Golos Text"),
    labelLarge: defaultDarkTheme.textTheme.labelLarge!
        .copyWith(fontFamily: "Golos Text", fontWeight: FontWeight.w600),
    bodyMedium: defaultDarkTheme.textTheme.bodyMedium!
        .copyWith(fontFamily: "Roboto Serif"),
    titleLarge: defaultDarkTheme.textTheme.titleLarge!
        .copyWith(fontFamily: "Roboto Serif", fontWeight: FontWeight.w600),
    displaySmall: defaultDarkTheme.textTheme.displaySmall!
        .copyWith(fontFamily: "Roboto Serif"),
    headlineMedium: defaultDarkTheme.textTheme.headlineMedium!
        .copyWith(fontFamily: "Roboto Serif", fontWeight: FontWeight.w600),
    headlineLarge: defaultDarkTheme.textTheme.headlineLarge!
        .copyWith(fontFamily: "Roboto Serif", fontWeight: FontWeight.bold),
  ),
);
