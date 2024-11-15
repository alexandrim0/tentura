import 'package:drift/drift.dart';

import 'package:tentura/domain/enum.dart';

@TableIndex(name: 'messages_object', columns: {#object})
@TableIndex(name: 'messages_subject', columns: {#subject})
@TableIndex(name: 'messages_updatedAt', columns: {#updatedAt})
class Messages extends Table {
  TextColumn get localId => text()();
  TextColumn get remoteId => text()();
  TextColumn get subject => text()();
  TextColumn get object => text()();
  TextColumn get content => text()();
  BoolColumn get isEncrypted => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get status => intEnum<MessageStatus>()();

  @override
  Set<Column> get primaryKey => {localId};
}
