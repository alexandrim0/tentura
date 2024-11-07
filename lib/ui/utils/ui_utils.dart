import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tentura/consts.dart';

import '../bloc/state_base.dart';

const kSpacingSmall = 8.0;
const kSpacingMedium = 16.0;
const kSpacingLarge = 24.0;

const kPaddingAll = EdgeInsets.all(kSpacingMedium);
const kPaddingH = EdgeInsets.symmetric(horizontal: kSpacingMedium);
const kPaddingV = EdgeInsets.symmetric(vertical: kSpacingMedium);
const kPaddingT = EdgeInsets.only(top: kSpacingMedium);

const kPaddingSmallT = EdgeInsets.only(top: kSpacingSmall);
const kPaddingSmallV = EdgeInsets.symmetric(vertical: kSpacingSmall);

/// 600px in MD guideline means large screen for vertical orientation
const kWebConstraints = BoxConstraints(minWidth: 600);
const kWebAspectRatio = 9 / 16;

final _fYMD = DateFormat.yMd();
String fYMD(DateTime? dateTime) =>
    dateTime == null ? '' : _fYMD.format(dateTime);

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
  if (isError) if (kDebugMode) print(text);
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: isFloating ? SnackBarBehavior.floating : null,
    margin: isFloating ? const EdgeInsets.all(16) : null,
    duration: duration,
    backgroundColor: isError
        ? theme.colorScheme.error
        : color ?? theme.snackBarTheme.backgroundColor,
    action: kDebugMode
        ? SnackBarAction(
            label: 'print',
            // ignore: avoid_print
            onPressed: () => print(text),
          )
        : null,
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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBarError(
  BuildContext context,
  StateFetchMixin state,
) =>
    showSnackBar(
      context,
      isError: true,
      text: state.error?.toString() ?? 'Unknown error!',
    );

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
