import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../theme.dart';

class QrCode extends StatelessWidget {
  const QrCode({
    required this.data,
    this.backgroundColor = Colors.transparent,
    super.key,
  });

  final String data;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => QrImageView(
        key: ValueKey(data),
        data: data,
        backgroundColor: backgroundColor,
        dataModuleStyle: QrDataModuleStyle(
          // We can`t read inverted QR
          color: themeLight.colorScheme.onSurface,
          dataModuleShape: QrDataModuleShape.square,
        ),
        eyeStyle: QrEyeStyle(
          // We can`t read inverted QR
          color: themeLight.colorScheme.onSurface,
          eyeShape: QrEyeShape.square,
        ),
      );
}
