import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/features/dev/ui/widget/colors_drawer.dart';

@UseCase(
  name: 'Default',
  type: ColorsDrawer,
  path: '[widget]/colors_drawer',
)
Widget colorsDrawerUseCase(BuildContext context) {
  return const ColorsDrawer();
}
