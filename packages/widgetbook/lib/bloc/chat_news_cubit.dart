import 'package:injectable/injectable.dart';
import 'package:tentura/features/chat/domain/entity/chat_message.dart';

import 'package:tentura/features/chat/ui/bloc/chat_news_cubit.dart';

import 'package:tentura_widgetbook/bloc/_data.dart';

@Singleton(as: ChatNewsCubit)
class ChatNewsCubitMock extends Cubit<ChatNewsState> implements ChatNewsCubit {
  ChatNewsCubitMock()
      : super(ChatNewsState(
          myId: profileAlice.id,
          cursor: DateTime.now(),
          messages: {},
        ));

  @override
  void showChatWith(String id) {}

  @override
  void showProfile(String id) {}

  @override
  Stream<ChatMessage> get updates async* {
    // yield ChatMessage();
  }
}
