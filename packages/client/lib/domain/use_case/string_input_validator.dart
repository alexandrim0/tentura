import 'package:tentura/consts.dart';

mixin StringInputValidator {
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
