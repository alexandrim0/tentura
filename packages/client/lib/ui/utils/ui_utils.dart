import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

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
  Color? color,
  bool isError = false,
  bool isFloating = false,
  List<TextSpan>? textSpans,
  Duration duration = const Duration(seconds: kSnackBarDuration),
}) {
  final theme = Theme.of(context);
  ScaffoldMessenger.of(context).clearSnackBars();
  if (isError) _logger.d(text);
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: isFloating ? SnackBarBehavior.floating : null,
      margin: isFloating ? kPaddingAll : null,
      duration: duration,
      backgroundColor:
          isError
              ? theme.colorScheme.error
              : color ?? theme.snackBarTheme.backgroundColor,
      content: RichText(
        text: TextSpan(
          text: text,
          children: textSpans,
          style:
              isError
                  ? theme.snackBarTheme.contentTextStyle?.copyWith(
                    color: theme.colorScheme.onError,
                  )
                  : theme.snackBarTheme.contentTextStyle,
        ),
      ),
    ),
  );
}

Widget separatorBuilder(_, _) => const Divider(endIndent: 20, indent: 20);

void commonScreenBlocListener(BuildContext context, StateBase state) =>
    switch (state.status) {
      final StateIsNavigating s =>
        s.path == kPathBack
            ? context.back()
            : context.navigateNamedTo(s.path, includePrefixMatches: true),
      final StateIsMessaging s => showSnackBar(context, text: s.message),
      final StateHasError s => showSnackBar(
        context,
        isError: true,
        text: s.error.toString(),
      ),
      _ => null,
    };
