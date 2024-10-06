import 'package:flutter/material.dart';

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
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
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
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        fontSize: 45,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
      ),
      headlineMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
      ),
    ).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
  );
}
