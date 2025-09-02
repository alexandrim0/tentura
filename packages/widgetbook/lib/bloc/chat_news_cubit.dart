import 'package:injectable/injectable.dart';

import 'package:tentura/features/chat/ui/bloc/chat_news_cubit.dart';

import '_data.dart';

@Singleton(as: ChatNewsCubit)
class ChatNewsCubitMock extends Cubit<ChatNewsState> implements ChatNewsCubit {
  ChatNewsCubitMock()
    : super(
        ChatNewsState(
          myId: profileAlice.id,
          messages: {},
          lastUpdate: DateTime.timestamp(),
        ),
      );
}
