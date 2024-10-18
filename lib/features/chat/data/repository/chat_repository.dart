import 'package:injectable/injectable.dart';

@lazySingleton
class ChatRepository {
  ChatRepository();

  Future<void> sendMessage(String message) async {}
}
