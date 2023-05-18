import 'package:savelife/constants/colors.dart';
import 'package:savelife/constants/sizes.dart';
import 'package:flutter/material.dart';

class AElevatedButtonTheme {
  AElevatedButtonTheme._(); //To Avoid Creating instance

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      foregroundColor: aWhiteColor,
      backgroundColor: aSecondaryCOlor,
      side: const BorderSide(color: aSecondaryCOlor),
      padding: const EdgeInsets.symmetric(vertical: aButtonHeight),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      foregroundColor: aWhiteColor,
      backgroundColor: aSecondaryCOlor,
      side: const BorderSide(color: aSecondaryCOlor),
      padding: const EdgeInsets.symmetric(vertical: aButtonHeight),
    ),
  );
}
