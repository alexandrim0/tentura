import 'dart:ui';

sealed class ScreenSize {
  static ScreenSize get(Size size) => switch (size.height) {
        < ScreenSmall.height => ScreenSmall(size: size),
        < ScreenMedium.height => ScreenMedium(size: size),
        < ScreenLarge.height => ScreenLarge(size: size),
        _ => ScreenBig(size: size),
      };

  const ScreenSize({required this.size});

  final Size size;
}

class ScreenSmall extends ScreenSize {
  static const height = 600;

  const ScreenSmall({required super.size});
}

class ScreenMedium extends ScreenSize {
  static const height = 800;

  const ScreenMedium({required super.size});
}

class ScreenLarge extends ScreenSize {
  static const height = 1200;

  const ScreenLarge({required super.size});
}

class ScreenBig extends ScreenSize {
  static const height = 1600;

  const ScreenBig({required super.size});
}
