import 'package:tentura_root/domain/entity/localizable.dart';

sealed class UserInputException extends LocalizableException {
  const UserInputException();
}

final class TitleTooShortException extends UserInputException {
  const TitleTooShortException();

  @override
  String get toEn => 'Title is too short';

  @override
  String get toRu => 'Название слишком короткое';
}
