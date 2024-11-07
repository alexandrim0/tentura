typedef JWT = ({String id, String accessToken, DateTime expiresAt});

final jwtEmpty = (
  id: '',
  accessToken: '',
  expiresAt: DateTime.fromMillisecondsSinceEpoch(0)
);
