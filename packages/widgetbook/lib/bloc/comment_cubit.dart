import 'package:injectable/injectable.dart';

import 'package:tentura/features/comment/ui/bloc/comment_cubit.dart';

@Singleton(as: CommentCubit)
class CommentCubitMock extends Cubit<CommentState> implements CommentCubit {
  CommentCubitMock() : super(const CommentState());

  @override
  void showProfile(String id) {}
}
