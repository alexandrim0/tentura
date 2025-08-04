part of '_queries.dart';

const _newP2pMessagesCounts = '''
SELECT 
  m.sender_id,
  count(*)
FROM 
  p2p_messages m
WHERE
  m.receiver_id = ? AND m.status = ?
GROUP BY
  m.receiver_id;
''';
