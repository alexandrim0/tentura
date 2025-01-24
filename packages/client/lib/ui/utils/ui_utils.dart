import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tentura/consts.dart';

import '../bloc/state_base.dart';

const kSpacingSmall = 8.0;
const kSpacingMedium = 16.0;
const kSpacingLarge = 24.0;

const kPaddingAllS = EdgeInsets.all(kSpacingSmall);
// TBD: rename to kPaddingAllM
const kPaddingAll = EdgeInsets.all(kSpacingMedium);
const kPaddingAllL = EdgeInsets.all(kSpacingLarge);
// TBD: rename to kPaddingHM
const kPaddingH = EdgeInsets.symmetric(horizontal: kSpacingMedium);
// TBD: rename to kPaddingVM
const kPaddingV = EdgeInsets.symmetric(vertical: kSpacingMedium);
const kPaddingT = EdgeInsets.only(top: kSpacingMedium);

const kPaddingSmallT = EdgeInsets.only(top: kSpacingSmall);
const kPaddingSmallV = EdgeInsets.symmetric(vertical: kSpacingSmall);

/// 600px in MD guideline means large screen for vertical orientation
const kWebConstraints = BoxConstraints(minWidth: 600);
const kWebAspectRatio = 9 / 16;

final _fmtYMd = DateFormat.yMd();
final _fmtHm = DateFormat.Hm();

final _logger = GetIt.I<Logger>();

String dateFormatYMD(DateTime? dateTime) =>
    dateTime == null ? '' : _fmtYMd.format(dateTime);

String timeFormatHm(DateTime? dateTime) =>
    dateTime == null ? '' : _fmtHm.format(dateTime);

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
  BuildContext context, {
  String? text,
  List<TextSpan>? textSpans,
  Duration duration = kSnackBarDuration,
  bool isFloating = false,
  bool isError = false,
  Color? color,
}) {
  final theme = Theme.of(context);
  ScaffoldMessenger.of(context).clearSnackBars();
  if (isError) _logger.d(text);
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: isFloating ? SnackBarBehavior.floating : null,
    margin: isFloating ? kPaddingAll : null,
    duration: duration,
    backgroundColor: isError
        ? theme.colorScheme.error
        : color ?? theme.snackBarTheme.backgroundColor,
    content: RichText(
      text: TextSpan(
        text: text,
        children: textSpans,
        style: isError
            ? theme.snackBarTheme.contentTextStyle?.copyWith(
                color: theme.colorScheme.onError,
              )
            : theme.snackBarTheme.contentTextStyle,
      ),
    ),
  ));
}

@Deprecated('Use commonScreenBlocListener instead')
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBarError(
  BuildContext context,
  StateFetchMixin state,
) =>
    showSnackBar(
      context,
      isError: true,
      text: state.error?.toString() ?? 'Unknown error!',
    );

void commonScreenBlocListener(BuildContext context, StateBase state) =>
    switch (state.status) {
      final StateIsNavigating s => context.navigateNamedTo(s.path),
      final StateIsMessaging s => showSnackBar(
          context,
          text: s.message,
        ),
      final StateHasError s => showSnackBar(
          context,
          isError: true,
          text: s.error.toString(),
        ),
      _ => null,
    };

Future<({String name, Uint8List bytes})?> pickImage() async {
  final xFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    // TBD: resize and convert by package:image
    maxWidth: 600,
  );
  return xFile == null
      ? null
      : (
          name: xFile.name,
          bytes: await xFile.readAsBytes(),
        );
}
