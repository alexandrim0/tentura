// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:tentura_widgetbook/screen/auth_screen.dart' as _i3;
import 'package:tentura_widgetbook/screen/home_screen.dart' as _i2;
import 'package:tentura_widgetbook/widget/avatar_rated.dart' as _i4;
import 'package:tentura_widgetbook/widget/colors_drawer.dart' as _i5;
import 'package:widgetbook/widgetbook.dart' as _i1;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookCategory(
    name: 'screen',
    children: [
      _i1.WidgetbookFolder(
        name: 'home',
        children: [
          _i1.WidgetbookLeafComponent(
            name: 'HomeScreen',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i2.defaultHomeUseCase,
            ),
          )
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'login',
        children: [
          _i1.WidgetbookLeafComponent(
            name: 'AuthLoginScreen',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i3.defaultAuthLoginUseCase,
            ),
          )
        ],
      ),
    ],
  ),
  _i1.WidgetbookCategory(
    name: 'widget',
    children: [
      _i1.WidgetbookFolder(
        name: 'avatar',
        children: [
          _i1.WidgetbookLeafComponent(
            name: 'AvatarRated',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i4.avatarRatedUseCase,
            ),
          )
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'colors_drawer',
        children: [
          _i1.WidgetbookLeafComponent(
            name: 'ColorsDrawer',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i5.colorsDrawerUseCase,
            ),
          )
        ],
      ),
    ],
  ),
];
