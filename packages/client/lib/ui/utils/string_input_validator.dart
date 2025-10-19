import 'package:tentura/ui/l10n/l10n.dart';

import 'package:tentura/consts.dart';

final _codePattern = RegExp(r'(I[a-f0-9]{12})');

mixin StringInputValidator {
  String? invitationCodeValidator(L10n l10n, String? input) {
    if (input == null || input.length < kIdLength) {
      return l10n.invitationCodeTooShort;
    }
    final match = _codePattern.firstMatch(input);
    if (match == null) {
      return l10n.invitationCodeWrongFormat;
    }
    final code = match.group(1)!;
    if (code.length != kIdLength || !code.startsWith('I')) {
      return l10n.invitationCodeWrongFormat;
    }
    return null;
  }

  String? titleValidator(L10n l10n, String? title) {
    if (title == null || title.length < kTitleMinLength) {
      return l10n.titleTooShort;
    }
    if (title.length > kTitleMaxLength) {
      return l10n.titleTooLong;
    }
    return null;
  }

  String? descriptionValidator(L10n l10n, String? description) {
    if (description != null && description.length > kDescriptionMaxLength) {
      return l10n.descriptionTooLong;
    }
    return null;
  }
}
