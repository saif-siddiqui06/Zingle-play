import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const purple = Color(0xFF7C2CF5);
  static const violet = Color(0xFFA855F7);
  static const ink = Color(0xFF080A12);
  static const gold = Color(0xFFFFC34D);

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: purple,
      brightness: brightness,
      primary: purple,
      secondary: violet,
      surface: dark ? const Color(0xFF10131D) : Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? ink : const Color(0xFFF8F7FC),
      textTheme: GoogleFonts.interTextTheme(dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: purple,
        thumbColor: purple,
        overlayColor: purple.withValues(alpha: .16),
      ),
    );
  }
}
