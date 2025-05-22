import 'dart:math';
import 'package:flutter/material.dart';

double calculateRadius({
  required double minRadius,
  required double maxRadius,
  required double weight,
}) =>
    min(
      maxRadius,
      (maxRadius - minRadius) * (weight / 100) + minRadius,
    );

Color calculateColor({
  required double weight,
  required bool isDark,
}) {
  final i = weight < 10 ? 50 : (weight / 10).round() * 100;
  return isDark
      ? Colors.deepPurple[i] ?? Colors.deepPurple[900]!
      : (Colors.amber[i] ?? Colors.amber[900]!);
}
