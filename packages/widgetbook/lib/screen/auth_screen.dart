import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/features/auth/ui/screen/auth_login_screen.dart';

@UseCase(
  name: 'Default',
  type: AuthLoginScreen,
  path: '[screen]/login',
)
Widget defaultAuthLoginUseCase(BuildContext context) {
  return const AuthLoginScreen();
}
