import 'package:savelife/constants/colors.dart';
import 'package:flutter/material.dart';

class ATextFormFieldTheme {
  ATextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
          border: OutlineInputBorder(),
          prefixIconColor: aSecondaryCOlor,
          floatingLabelStyle: TextStyle(color: aSecondaryCOlor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: aSecondaryCOlor),
          ));

  static InputDecorationTheme darkInputDecorationTheme =
      const InputDecorationTheme(
          border: OutlineInputBorder(),
          prefixIconColor: aSecondaryCOlor,
          floatingLabelStyle: TextStyle(color: aSecondaryCOlor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: aSecondaryCOlor),
          ));
}
