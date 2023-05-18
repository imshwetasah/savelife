import 'package:savelife/utils/theme/widget_themes/elevated_btn_theme.dart';
import 'package:savelife/utils/theme/widget_themes/outlined_btn_theme.dart';
import 'package:savelife/utils/theme/widget_themes/text_field_theme.dart';
import 'package:savelife/utils/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class ATheme {
  //Light Theme
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.light,
    textTheme: ATextTheme.lightTextTheme,
    outlinedButtonTheme: AOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: AElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: ATextFormFieldTheme.lightInputDecorationTheme,
  );

  //Dark Theme
  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.light,
    textTheme: ATextTheme.lightTextTheme,
    outlinedButtonTheme: AOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: AElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: ATextFormFieldTheme.lightInputDecorationTheme,
  );
}



/*
    primarySwatch: const MaterialColor(0xFFF44336, <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    }),
 */
