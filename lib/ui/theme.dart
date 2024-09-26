import 'package:flutter/material.dart';

const _primaryColor = Color(0xFF3A1E5C);

final colorSchemeLight = ColorScheme.fromSeed(
  seedColor: _primaryColor,
);

final colorSchemeDark = ColorScheme.fromSeed(
  seedColor: _primaryColor,
  brightness: Brightness.dark,
);

final themeLight = _createAppTheme(Brightness.light);
final themeDark = _createAppTheme(Brightness.dark);

ThemeData _createAppTheme(Brightness brightness) {
  final isDarkMode = brightness == Brightness.dark;
  final colorScheme = isDarkMode ? colorSchemeDark : colorSchemeLight;

  final textTheme = ThemeData().textTheme;

  return ThemeData().copyWith(
    brightness: brightness,
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
    textTheme: textTheme
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
          fontFamily: 'Roboto',
        ),
  );
}
