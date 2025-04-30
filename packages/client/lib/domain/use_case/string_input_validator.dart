import 'package:tentura/consts.dart';

import '../enum.dart';

mixin StringInputValidator {
  StringInputValidatorErrors? invitationCodeValidator(String? code) {
    if (code == null || code.length < kTitleMinLength) {
      return StringInputValidatorErrors.tooShort;
    }
    if (code.length > kTitleMaxLength) {
      return StringInputValidatorErrors.tooLong;
    }
    if (!code.startsWith('I')) {
      return StringInputValidatorErrors.wrongFormat;
    }
    return null;
  }

  String? titleValidator(String? title) {
    if (title == null || title.length < kTitleMinLength) {
      return 'Title too short';
    }
    if (title.length > kTitleMaxLength) {
      return 'Title too long';
    }
    return null;
  }

  String? descriptionValidator(String? description) {
    if (description != null && description.length > kDescriptionMaxLength) {
      return 'Description too long';
    }
    return null;
  }
}
