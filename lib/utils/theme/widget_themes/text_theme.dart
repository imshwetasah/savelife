import 'package:savelife/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* --Light and Dark Text Themes -- */
class ATextTheme {
  ATextTheme._(); //To avoid creating instances
  //Light Theme
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: aDarkColor),
    displayMedium: GoogleFonts.montserrat(
        fontSize: 24.0, fontWeight: FontWeight.w700, color: aDarkColor),
    displaySmall: GoogleFonts.montserrat(
        fontSize: 20.0, fontWeight: FontWeight.w700, color: aDarkColor),
    headlineLarge: GoogleFonts.poppins(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: aDarkColor),
    headlineMedium: GoogleFonts.poppins(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: aDarkColor),
    headlineSmall: GoogleFonts.poppins(
        fontSize: 14.0, fontWeight: FontWeight.w600, color: aDarkColor),
    titleLarge: GoogleFonts.lato(
        fontSize: 18.0, fontWeight: FontWeight.normal, color: aDarkColor),
    titleMedium: GoogleFonts.lato(
        fontSize: 16.0, fontWeight: FontWeight.normal, color: aDarkColor),
    titleSmall: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: aDarkColor),
    bodyLarge: GoogleFonts.lato(
        fontSize: 16.0, fontWeight: FontWeight.normal, color: aDarkColor),
    bodySmall: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: aDarkColor),
  );

  //Dark Theme
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: aDarkColor),
    displayMedium: GoogleFonts.montserrat(
        fontSize: 24.0, fontWeight: FontWeight.w700, color: aDarkColor),
    displaySmall: GoogleFonts.montserrat(
        fontSize: 20.0, fontWeight: FontWeight.w700, color: aDarkColor),
    headlineLarge: GoogleFonts.poppins(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: aDarkColor),
    headlineMedium: GoogleFonts.poppins(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: aDarkColor),
    headlineSmall: GoogleFonts.poppins(
        fontSize: 14.0, fontWeight: FontWeight.w600, color: aDarkColor),
    titleLarge: GoogleFonts.lato(
        fontSize: 18.0, fontWeight: FontWeight.normal, color: aDarkColor),
    titleMedium: GoogleFonts.lato(
        fontSize: 16.0, fontWeight: FontWeight.normal, color: aDarkColor),
    titleSmall: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: aDarkColor),
    bodyLarge: GoogleFonts.lato(
        fontSize: 16.0, fontWeight: FontWeight.normal, color: aDarkColor),
    bodySmall: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: aDarkColor),
  );
}
