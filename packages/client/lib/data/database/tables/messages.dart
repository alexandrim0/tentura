import 'package:drift/drift.dart';

import 'package:tentura/domain/enum.dart';

@TableIndex(name: 'messages_object', columns: {#objectId})
@TableIndex(name: 'messages_subject', columns: {#subjectId})
@TableIndex(name: 'messages_updatedAt', columns: {#updatedAt})
class Messages extends Table {
  TextColumn get id => text()();

  TextColumn get subjectId => text()();

  TextColumn get objectId => text()();

  TextColumn get content => text()();

  IntColumn get status => intEnum<ChatMessageStatus>()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => {id};
}
