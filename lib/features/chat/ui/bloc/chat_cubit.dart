import 'package:get_it/get_it.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/profile/domain/entity/profile.dart';

import '../../domain/use_case/chat_case.dart';
import 'chat_state.dart';

export 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required String friendId,
    required Profile myProfile,
    ChatCase? chatCase,
  })  : _chatCase = chatCase ?? GetIt.I<ChatCase>(),
        super(ChatState(
          me: User(
            id: myProfile.id,
            firstName: myProfile.title,
            imageUrl: myProfile.imageId,
          ),
          friend: User(id: friendId),
          messages: [],
        ));

  final ChatCase _chatCase;

  void onSendPressed(PartialText text) => _chatCase.sendMessage(text.text);
}
