part of 'database.dart';

extension type const AccountX(Account i) {
  bool get hasImage => i.imageId.isNotEmpty;
}
