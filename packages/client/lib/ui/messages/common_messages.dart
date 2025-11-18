import 'package:tentura_root/domain/entity/localizable.dart';

final class OkMessage extends LocalizableMessage {
  const OkMessage();

  @override
  String get toEn => 'Ok';

  @override
  String get toRu => 'Ок';
}

final class NoValidCodeMessage extends LocalizableMessage {
  const NoValidCodeMessage();

  @override
  String get toEn => 'No valid code';

  @override
  String get toRu => 'Нет действительного кода';
}

