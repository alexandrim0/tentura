import 'identifiable.dart';

sealed class RepositoryEvent<T extends Identifiable> implements Identifiable {
  const RepositoryEvent(this.value);

  final T value;

  @override
  String get id => value.id;
}

final class RepositoryEventFetch<T extends Identifiable>
    extends RepositoryEvent<T> {
  const RepositoryEventFetch(super.value);
}

final class RepositoryEventCreate<T extends Identifiable>
    extends RepositoryEvent<T> {
  const RepositoryEventCreate(super.value);
}

final class RepositoryEventUpdate<T extends Identifiable>
    extends RepositoryEvent<T> {
  const RepositoryEventUpdate(super.value);
}

final class RepositoryEventDelete<T extends Identifiable>
    extends RepositoryEvent<T> {
  const RepositoryEventDelete(super.value);
}
