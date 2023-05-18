import 'package:savelife/constants/colors.dart';
import 'package:savelife/constants/sizes.dart';
import 'package:flutter/material.dart';

class AOutlinedButtonTheme {
  AOutlinedButtonTheme._(); //To Avoid Creating instance

  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      foregroundColor: aSecondaryCOlor,
      side: const BorderSide(color: aSecondaryCOlor),
      padding: const EdgeInsets.symmetric(vertical: aButtonHeight),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      foregroundColor: aSecondaryCOlor,
      side: const BorderSide(color: aSecondaryCOlor),
      padding: const EdgeInsets.symmetric(vertical: aButtonHeight),
    ),
  );
}
