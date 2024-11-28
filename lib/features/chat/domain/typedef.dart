import 'package:tentura/domain/entity/profile.dart';

import 'entity/chat_message.dart';

typedef ChatFetchResult = ({
  Iterable<ChatMessage> messages,
  Profile profile,
});
