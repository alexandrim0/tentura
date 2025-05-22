import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tentura/ui/utils/normalize.dart';

void main() {
  group(
    'calculateColor',
    () {
      test(
        'Lower bound',
        () {
          expect(
            calculateColor(
              isDark: true,
              weight: 0,
            ),
            Colors.deepPurple[50],
          );

          expect(
            calculateColor(
              isDark: true,
              weight: 1,
            ),
            Colors.deepPurple[50],
          );

          expect(
            calculateColor(
              isDark: true,
              weight: 10,
            ),
            Colors.deepPurple[100],
          );

          expect(
            calculateColor(
              isDark: true,
              weight: 11,
            ),
            Colors.deepPurple[100],
          );

          expect(
            calculateColor(
              isDark: true,
              weight: 20,
            ),
            Colors.deepPurple[200],
          );
        },
      );

      test(
        'Upper bound',
        () {
          expect(
            calculateColor(
              isDark: true,
              weight: 84,
            ),
            Colors.deepPurple[800],
          );

          expect(
            calculateColor(
              isDark: true,
              weight: 85,
            ),
            Colors.deepPurple[900],
          );

          expect(
            calculateColor(
              isDark: true,
              weight: 100,
            ),
            Colors.deepPurple[900],
          );
        },
      );
    },
  );

  group(
    'calculateRadius',
    () {
      const maxRadius = 20.0;
      const minRadius = 5.0;

      test(
        'Lower bounds',
        () {
          expect(
            calculateRadius(
              maxRadius: maxRadius,
              minRadius: minRadius,
              weight: 0,
            ),
            5,
          );

          expect(
            calculateRadius(
              maxRadius: maxRadius,
              minRadius: minRadius,
              weight: 1,
            ),
            5.15,
          );

          expect(
            calculateRadius(
              maxRadius: maxRadius,
              minRadius: minRadius,
              weight: 9,
            ),
            6.35,
          );

          expect(
            calculateRadius(
              maxRadius: maxRadius,
              minRadius: minRadius,
              weight: 10,
            ),
            6.5,
          );

          expect(
            calculateRadius(
              maxRadius: maxRadius,
              minRadius: minRadius,
              weight: 11,
            ),
            6.65,
          );
        },
      );

      test(
        'Upper bounds',
        () {
          expect(
            calculateRadius(
              maxRadius: maxRadius,
              minRadius: minRadius,
              weight: 100,
            ),
            20,
          );

          expect(
            calculateRadius(
              maxRadius: maxRadius,
              minRadius: minRadius,
              weight: 99,
            ),
            19.85,
          );

          expect(
            calculateRadius(
              maxRadius: maxRadius,
              minRadius: minRadius,
              weight: 91,
            ),
            18.65,
          );

          expect(
            calculateRadius(
              maxRadius: maxRadius,
              minRadius: minRadius,
              weight: 90,
            ),
            18.5,
          );

          expect(
            calculateRadius(
              maxRadius: maxRadius,
              minRadius: minRadius,
              weight: 89,
            ),
            18.35,
          );
        },
      );
    },
  );
}
