import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/ui_utils.dart';

// const primaryColor = Color(0xFF3A1E5C);

// final themeLight = _createAppTheme(
//   ColorScheme.fromSeed(seedColor: primaryColor),
// );
// final themeDark = _createAppTheme(
//   ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: primaryColor),
// );

// core palette

const _cPrimary = Color(0xFF014F86);
const _cActiveIcon = Color(0xFF014F86);
const _cPrimaryDark = Color(0xFF6CBCE3);
// const _cSuccess = Color(0xFF00A676);
const _cError = Color(0xFFD14343);
const _cBgLight = Color(0xFFF4F4F4);
const _cBgDark = Color(0xFF0A1826);
const _cSecondaryTextLight = Color(0xFF4B5563);
const _cSecondaryTextDark = Color(0xFFE5E7EB);
const _cSurfaceContainerLight = Color(0xFFFFFFFF);
const _cSurfaceContainerDark = Color(0xFF1D2935);
const _cOnSurfaceLight = Color(0xFF1A1A1A);
const _cOnSurfaceDark = Color(0xFFE1E1E1);
const _cBordersLight = Color(0xFF4B5563);
const _cBordersDark = Color(0xFF444746);

// LIGHT scheme

const lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: _cPrimary,
  onPrimary: Color(0xFFE5E7EB),
  secondary: _cPrimaryDark,
  onSecondary: _cOnSurfaceDark,
  error: _cError,
  onError: Colors.white,
  surface: _cBgLight,
  surfaceContainer: _cSurfaceContainerLight,
  onSurface: _cOnSurfaceLight,
  onSurfaceVariant: _cSecondaryTextLight,
  outlineVariant: _cBordersLight,
  primaryFixed: _cActiveIcon,
);

// DARK scheme

const darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: _cPrimaryDark,
  onPrimary: _cBgDark,
  secondary: _cPrimaryDark,
  onSecondary: _cOnSurfaceDark,
  error: _cError,
  onError: Colors.white,
  surface: _cBgDark,
  surfaceContainer: _cSurfaceContainerDark,
  onSurface: _cOnSurfaceDark,
  onSurfaceVariant: _cSecondaryTextDark,
  outlineVariant: _cBordersDark,
  primaryFixed: _cActiveIcon,
);

final themeLight = _createAppTheme(lightScheme);
final themeDark = _createAppTheme(darkScheme);

ThemeData _createAppTheme(ColorScheme colorScheme) {
  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(kBorderRadius),
  );

  final expansionTileShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(kBorderRadius),
    side: BorderSide(color: colorScheme.outline),
  );

  return ThemeData(
    colorScheme: colorScheme,
    brightness: colorScheme.brightness,
    canvasColor: colorScheme.surfaceTint,
    scaffoldBackgroundColor: colorScheme.surface,
    unselectedWidgetColor: colorScheme.onSurface,

    //Dialog
    dialogTheme: DialogThemeData(backgroundColor: colorScheme.surfaceContainer),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(shape: buttonShape),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: buttonShape,
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    ),

    expansionTileTheme: ExpansionTileThemeData(
      collapsedShape: expansionTileShape,
      shape: expansionTileShape,
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ElevatedButton.styleFrom(shape: buttonShape),
    ),

    // Icon
    iconTheme: IconThemeData(color: colorScheme.primary),

    //Snack Bar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.primary,
      contentTextStyle: TextStyle(color: colorScheme.onPrimary),
    ),

    //Text
    textTheme: GoogleFonts.robotoTextTheme()
        .copyWith(
          displayMedium: const TextStyle(fontSize: 45),
          titleLarge: const TextStyle(fontSize: 22),
          titleMedium: const TextStyle(fontSize: 18),
          titleSmall: const TextStyle(fontSize: 14),
          headlineLarge: const TextStyle(fontSize: 22),
          headlineMedium: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          headlineSmall: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: const TextStyle(fontSize: 16),
          bodyMedium: const TextStyle(fontSize: 14),
          bodySmall: const TextStyle(fontSize: 12),
        )
        .apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
  );
}
