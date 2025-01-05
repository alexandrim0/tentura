// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beacon_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BeaconEntity {
  String get id => throw _privateConstructorUsedError;
  UserEntity get author => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get context => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get hasPicture => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  DateTimeRange? get timerange => throw _privateConstructorUsedError;
  LatLng? get coordinates => throw _privateConstructorUsedError;

  /// Create a copy of BeaconEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BeaconEntityCopyWith<BeaconEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BeaconEntityCopyWith<$Res> {
  factory $BeaconEntityCopyWith(
          BeaconEntity value, $Res Function(BeaconEntity) then) =
      _$BeaconEntityCopyWithImpl<$Res, BeaconEntity>;
  @useResult
  $Res call(
      {String id,
      UserEntity author,
      DateTime createdAt,
      DateTime updatedAt,
      String title,
      String context,
      String description,
      bool hasPicture,
      bool isEnabled,
      DateTimeRange? timerange,
      LatLng? coordinates});

  $UserEntityCopyWith<$Res> get author;
}

/// @nodoc
class _$BeaconEntityCopyWithImpl<$Res, $Val extends BeaconEntity>
    implements $BeaconEntityCopyWith<$Res> {
  _$BeaconEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BeaconEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? title = null,
    Object? context = null,
    Object? description = null,
    Object? hasPicture = null,
    Object? isEnabled = null,
    Object? timerange = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserEntity,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      hasPicture: null == hasPicture
          ? _value.hasPicture
          : hasPicture // ignore: cast_nullable_to_non_nullable
              as bool,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      timerange: freezed == timerange
          ? _value.timerange
          : timerange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange?,
      coordinates: freezed == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as LatLng?,
    ) as $Val);
  }

  /// Create a copy of BeaconEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserEntityCopyWith<$Res> get author {
    return $UserEntityCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BeaconEntityImplCopyWith<$Res>
    implements $BeaconEntityCopyWith<$Res> {
  factory _$$BeaconEntityImplCopyWith(
          _$BeaconEntityImpl value, $Res Function(_$BeaconEntityImpl) then) =
      __$$BeaconEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      UserEntity author,
      DateTime createdAt,
      DateTime updatedAt,
      String title,
      String context,
      String description,
      bool hasPicture,
      bool isEnabled,
      DateTimeRange? timerange,
      LatLng? coordinates});

  @override
  $UserEntityCopyWith<$Res> get author;
}

/// @nodoc
class __$$BeaconEntityImplCopyWithImpl<$Res>
    extends _$BeaconEntityCopyWithImpl<$Res, _$BeaconEntityImpl>
    implements _$$BeaconEntityImplCopyWith<$Res> {
  __$$BeaconEntityImplCopyWithImpl(
      _$BeaconEntityImpl _value, $Res Function(_$BeaconEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BeaconEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? title = null,
    Object? context = null,
    Object? description = null,
    Object? hasPicture = null,
    Object? isEnabled = null,
    Object? timerange = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_$BeaconEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserEntity,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      hasPicture: null == hasPicture
          ? _value.hasPicture
          : hasPicture // ignore: cast_nullable_to_non_nullable
              as bool,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      timerange: freezed == timerange
          ? _value.timerange
          : timerange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange?,
      coordinates: freezed == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as LatLng?,
    ));
  }
}

/// @nodoc

class _$BeaconEntityImpl extends _BeaconEntity {
  const _$BeaconEntityImpl(
      {required this.id,
      required this.author,
      required this.createdAt,
      required this.updatedAt,
      this.title = '',
      this.context = '',
      this.description = '',
      this.hasPicture = false,
      this.isEnabled = false,
      this.timerange,
      this.coordinates})
      : super._();

  @override
  final String id;
  @override
  final UserEntity author;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String context;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final bool hasPicture;
  @override
  @JsonKey()
  final bool isEnabled;
  @override
  final DateTimeRange? timerange;
  @override
  final LatLng? coordinates;

  @override
  String toString() {
    return 'BeaconEntity(id: $id, author: $author, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, context: $context, description: $description, hasPicture: $hasPicture, isEnabled: $isEnabled, timerange: $timerange, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeaconEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.hasPicture, hasPicture) ||
                other.hasPicture == hasPicture) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.timerange, timerange) ||
                other.timerange == timerange) &&
            (identical(other.coordinates, coordinates) ||
                other.coordinates == coordinates));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      author,
      createdAt,
      updatedAt,
      title,
      context,
      description,
      hasPicture,
      isEnabled,
      timerange,
      coordinates);

  /// Create a copy of BeaconEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BeaconEntityImplCopyWith<_$BeaconEntityImpl> get copyWith =>
      __$$BeaconEntityImplCopyWithImpl<_$BeaconEntityImpl>(this, _$identity);
}

abstract class _BeaconEntity extends BeaconEntity {
  const factory _BeaconEntity(
      {required final String id,
      required final UserEntity author,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String title,
      final String context,
      final String description,
      final bool hasPicture,
      final bool isEnabled,
      final DateTimeRange? timerange,
      final LatLng? coordinates}) = _$BeaconEntityImpl;
  const _BeaconEntity._() : super._();

  @override
  String get id;
  @override
  UserEntity get author;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String get title;
  @override
  String get context;
  @override
  String get description;
  @override
  bool get hasPicture;
  @override
  bool get isEnabled;
  @override
  DateTimeRange? get timerange;
  @override
  LatLng? get coordinates;

  /// Create a copy of BeaconEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BeaconEntityImplCopyWith<_$BeaconEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
