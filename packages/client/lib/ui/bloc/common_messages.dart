import 'package:tentura_root/domain/entity/localizable.dart';

final class NoValidSeedMessage extends LocalizableMessage {
  const NoValidSeedMessage();

  @override
  String get toEn => 'There is no valid seed in clipboard';

  @override
  String get toRu => 'В буфере обмена нет корректной seed-фразы';
}

final class NoValidCodeMessage extends LocalizableMessage {
  const NoValidCodeMessage();

  @override
  String get toEn => 'There is no valid code in clipboard';

  @override
  String get toRu => 'В буфере обмена нет подходящего кода';
}
