import 'package:flutter/material.dart';

class ThemeAstra extends StatelessWidget {
  const ThemeAstra({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
    child: child,
  );
}
