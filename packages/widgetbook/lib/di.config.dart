// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart' as _i898;
import 'package:tentura/features/beacon/ui/bloc/beacon_cubit.dart' as _i234;
import 'package:tentura/features/chat/ui/bloc/chat_news_cubit.dart' as _i319;
import 'package:tentura/features/comment/ui/bloc/comment_cubit.dart' as _i537;
import 'package:tentura/features/context/ui/bloc/context_cubit.dart' as _i670;
import 'package:tentura/features/favorites/ui/bloc/favorites_cubit.dart'
    as _i673;
import 'package:tentura/features/friends/ui/bloc/friends_cubit.dart' as _i953;
import 'package:tentura/features/like/ui/bloc/like_cubit.dart' as _i1042;
import 'package:tentura/features/my_field/ui/bloc/my_field_cubit.dart'
    as _i1008;
import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart' as _i456;
import 'package:tentura_widgetbook/bloc/auth_cubit.dart' as _i823;
import 'package:tentura_widgetbook/bloc/beacon_cubit.dart' as _i967;
import 'package:tentura_widgetbook/bloc/chat_news_cubit.dart' as _i983;
import 'package:tentura_widgetbook/bloc/comment_cubit.dart' as _i625;
import 'package:tentura_widgetbook/bloc/context_cubit.dart' as _i729;
import 'package:tentura_widgetbook/bloc/favorites_cubit.dart' as _i47;
import 'package:tentura_widgetbook/bloc/friends_cubit.dart' as _i1063;
import 'package:tentura_widgetbook/bloc/like_cubit.dart' as _i708;
import 'package:tentura_widgetbook/bloc/my_field_cubit.dart' as _i337;
import 'package:tentura_widgetbook/bloc/profile_cubit.dart' as _i202;
import 'package:tentura_widgetbook/modules.dart' as _i24;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i974.Logger>(() => registerModule.logger);
    gh.singleton<_i234.BeaconCubit>(() => _i967.BeaconCubitMock());
    gh.singleton<_i953.FriendsCubit>(() => _i1063.FriendsCubitMock());
    gh.singleton<_i1008.MyFieldCubit>(() => _i337.MyFieldCubitMock());
    gh.singleton<_i673.FavoritesCubit>(() => _i47.FavoritesCubitMock());
    gh.singleton<_i898.AuthCubit>(() => _i823.AuthCubitMock());
    gh.singleton<_i456.ProfileCubit>(() => _i202.ProfileCubitMock());
    gh.singleton<_i670.ContextCubit>(() => _i729.ContextCubitMock());
    gh.singleton<_i1042.LikeCubit>(() => _i708.LikeCubitMock());
    gh.singleton<_i537.CommentCubit>(() => _i625.CommentCubitMock());
    gh.singleton<_i319.ChatNewsCubit>(() => _i983.ChatNewsCubitMock());
    return this;
  }
}

class _$RegisterModule extends _i24.RegisterModule {}
