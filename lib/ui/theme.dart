import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xFF3A1E5C);

final themeLight = _createAppTheme(ColorScheme.fromSeed(
  seedColor: primaryColor,
));
final themeDark = _createAppTheme(ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: primaryColor,
));

ThemeData _createAppTheme(ColorScheme colorScheme) {
  return ThemeData(
    colorScheme: colorScheme,
    brightness: colorScheme.brightness,
    canvasColor: colorScheme.surfaceTint,
    scaffoldBackgroundColor: colorScheme.surface,
    unselectedWidgetColor: colorScheme.onSurface,

    //Dialog
    dialogTheme: DialogTheme(
      backgroundColor: colorScheme.surfaceContainer,
    ),

    // Icon
    iconTheme: IconThemeData(
      color: colorScheme.onSurface,
    ),

    //Snack Bar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.primary,
      contentTextStyle: TextStyle(
        color: colorScheme.onPrimary,
      ),
    ),

    //Text
    textTheme: GoogleFonts.robotoTextTheme()
        .copyWith(
          displayMedium: const TextStyle(
            fontSize: 45,
          ),
          titleLarge: const TextStyle(
            fontSize: 22,
          ),
          titleMedium: const TextStyle(
            fontSize: 18,
          ),
          titleSmall: const TextStyle(
            fontSize: 14,
          ),
          headlineLarge: const TextStyle(
            fontSize: 22,
          ),
          headlineMedium: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          headlineSmall: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: const TextStyle(
            fontSize: 16,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
          ),
          bodySmall: const TextStyle(
            fontSize: 12,
          ),
        )
        .apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
  );
}
