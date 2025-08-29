import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/likable.dart';

import 'package:tentura/features/like/ui/bloc/like_cubit.dart';

@Singleton(as: LikeCubit)
class LikeCubitMock extends Cubit<LikeState> implements LikeCubit {
  LikeCubitMock() : super(LikeState(updatedAt: DateTime.now()));

  @override
  Future<void> decrementLike(Likable entity) async {}

  @override
  Future<void> incrementLike(Likable entity) async {}
}
