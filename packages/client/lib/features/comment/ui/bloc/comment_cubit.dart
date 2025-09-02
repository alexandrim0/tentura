import 'package:tentura/consts.dart';

import 'comment_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(const CommentState());

  void showProfile(String id) => emit(
    state.copyWith(
      status: StateIsNavigating('$kPathProfileView/$id'),
    ),
  );
}
