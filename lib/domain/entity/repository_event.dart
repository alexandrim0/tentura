import 'identifiable.dart';

sealed class RepositoryEvent<T extends Identifiable> implements Identifiable {
  const RepositoryEvent();
}

final class RepositoryEventCreate<T extends Identifiable>
    extends RepositoryEvent<T> {
  const RepositoryEventCreate(this.value);

  final T value;

  @override
  String get id => value.id;
}

final class RepositoryEventUpdate<T extends Identifiable>
    extends RepositoryEvent<T> {
  const RepositoryEventUpdate(this.value);

  final T value;

  @override
  String get id => value.id;
}

final class RepositoryEventDelete<T extends Identifiable>
    extends RepositoryEvent<T> {
  const RepositoryEventDelete(this.id);

  @override
  final String id;
}
