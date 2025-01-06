// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;


final _privateConstructorUsedError = UnsupportedError('It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommentEntity {

 String get id => throw _privateConstructorUsedError; String get content => throw _privateConstructorUsedError; UserEntity get author => throw _privateConstructorUsedError; BeaconEntity get beacon => throw _privateConstructorUsedError; DateTime get createdAt => throw _privateConstructorUsedError;







/// Create a copy of CommentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
$CommentEntityCopyWith<CommentEntity> get copyWith => throw _privateConstructorUsedError;

}

/// @nodoc
abstract class $CommentEntityCopyWith<$Res>  {
  factory $CommentEntityCopyWith(CommentEntity value, $Res Function(CommentEntity) then) = _$CommentEntityCopyWithImpl<$Res, CommentEntity>;
@useResult
$Res call({
 String id, String content, UserEntity author, BeaconEntity beacon, DateTime createdAt
});


$UserEntityCopyWith<$Res> get author;$BeaconEntityCopyWith<$Res> get beacon;
}

/// @nodoc
class _$CommentEntityCopyWithImpl<$Res,$Val extends CommentEntity> implements $CommentEntityCopyWith<$Res> {
  _$CommentEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

/// Create a copy of CommentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? author = null,Object? beacon = null,Object? createdAt = null,}) {
  return _then(_value.copyWith(
id: null == id ? _value.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _value.content : content // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _value.author : author // ignore: cast_nullable_to_non_nullable
as UserEntity,beacon: null == beacon ? _value.beacon : beacon // ignore: cast_nullable_to_non_nullable
as BeaconEntity,createdAt: null == createdAt ? _value.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  )as $Val);
}
/// Create a copy of CommentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserEntityCopyWith<$Res> get author {
  
  return $UserEntityCopyWith<$Res>(_value.author, (value) {
    return _then(_value.copyWith(author: value) as $Val);
  });
}/// Create a copy of CommentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BeaconEntityCopyWith<$Res> get beacon {
  
  return $BeaconEntityCopyWith<$Res>(_value.beacon, (value) {
    return _then(_value.copyWith(beacon: value) as $Val);
  });
}
}


/// @nodoc
abstract class _$$CommentEntityImplCopyWith<$Res> implements $CommentEntityCopyWith<$Res> {
  factory _$$CommentEntityImplCopyWith(_$CommentEntityImpl value, $Res Function(_$CommentEntityImpl) then) = __$$CommentEntityImplCopyWithImpl<$Res>;
@override @useResult
$Res call({
 String id, String content, UserEntity author, BeaconEntity beacon, DateTime createdAt
});


@override $UserEntityCopyWith<$Res> get author;@override $BeaconEntityCopyWith<$Res> get beacon;
}

/// @nodoc
class __$$CommentEntityImplCopyWithImpl<$Res> extends _$CommentEntityCopyWithImpl<$Res, _$CommentEntityImpl> implements _$$CommentEntityImplCopyWith<$Res> {
  __$$CommentEntityImplCopyWithImpl(_$CommentEntityImpl _value, $Res Function(_$CommentEntityImpl) _then)
      : super(_value, _then);


/// Create a copy of CommentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? author = null,Object? beacon = null,Object? createdAt = null,}) {
  return _then(_$CommentEntityImpl(
id: null == id ? _value.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _value.content : content // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _value.author : author // ignore: cast_nullable_to_non_nullable
as UserEntity,beacon: null == beacon ? _value.beacon : beacon // ignore: cast_nullable_to_non_nullable
as BeaconEntity,createdAt: null == createdAt ? _value.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class _$CommentEntityImpl  implements _CommentEntity {
  const _$CommentEntityImpl({required this.id, required this.content, required this.author, required this.beacon, required this.createdAt});

  

@override final  String id;
@override final  String content;
@override final  UserEntity author;
@override final  BeaconEntity beacon;
@override final  DateTime createdAt;

@override
String toString() {
  return 'CommentEntity(id: $id, content: $content, author: $author, beacon: $beacon, createdAt: $createdAt)';
}


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _$CommentEntityImpl&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.author, author) || other.author == author)&&(identical(other.beacon, beacon) || other.beacon == beacon)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,content,author,beacon,createdAt);

/// Create a copy of CommentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@override
@pragma('vm:prefer-inline')
_$$CommentEntityImplCopyWith<_$CommentEntityImpl> get copyWith => __$$CommentEntityImplCopyWithImpl<_$CommentEntityImpl>(this, _$identity);








}


abstract class _CommentEntity implements CommentEntity {
  const factory _CommentEntity({required final  String id, required final  String content, required final  UserEntity author, required final  BeaconEntity beacon, required final  DateTime createdAt}) = _$CommentEntityImpl;
  

  

@override String get id;@override String get content;@override UserEntity get author;@override BeaconEntity get beacon;@override DateTime get createdAt;
/// Create a copy of CommentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
_$$CommentEntityImplCopyWith<_$CommentEntityImpl> get copyWith => throw _privateConstructorUsedError;

}
