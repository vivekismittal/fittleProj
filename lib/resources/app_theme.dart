import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

class AppTheme {
  late final TextTheme _textTheme;
  late final ThemeData themeData;
  late final ColorScheme _colorScheme;
  late final InputDecorationTheme _inputDecorationTheme;

  AppTheme() {
    _colorScheme = const ColorScheme.light(
      primary: AppColor.whiteColor,
      secondary: AppColor.whiteParaColor,
      tertiary: AppColor.callToActionColor,
    );

    _textTheme = TextTheme(
      displayLarge: GoogleFonts.montserrat(
          fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      displayMedium: GoogleFonts.montserrat(
          fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
      displaySmall:
          GoogleFonts.montserrat(fontSize: 48, fontWeight: FontWeight.w400),
      headlineMedium: GoogleFonts.montserrat(
          fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      headlineSmall: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _colorScheme.primary),
      titleLarge: GoogleFonts.poppins(
          fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      titleMedium: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
      titleSmall: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyLarge: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      bodyMedium: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
          color: _colorScheme.primary),
      bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _colorScheme.primary),
      labelSmall:
          GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400,color: _colorScheme.secondary),
    );

    _inputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(3),
      ),
      fillColor: _colorScheme.primary.withOpacity(0.3),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 4,
      ),
      
    );

    themeData = ThemeData(
      textTheme: _textTheme,
      colorScheme: _colorScheme,
      primaryColor: _colorScheme.primary,
      inputDecorationTheme: _inputDecorationTheme,
    );
  }
}
