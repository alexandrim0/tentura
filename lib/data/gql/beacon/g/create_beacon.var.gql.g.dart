// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_beacon.var.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GCreateBeaconVars> _$gCreateBeaconVarsSerializer =
    new _$GCreateBeaconVarsSerializer();

class _$GCreateBeaconVarsSerializer
    implements StructuredSerializer<GCreateBeaconVars> {
  @override
  final Iterable<Type> types = const [GCreateBeaconVars, _$GCreateBeaconVars];
  @override
  final String wireName = 'GCreateBeaconVars';

  @override
  Iterable<Object?> serialize(Serializers serializers, GCreateBeaconVars object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'has_picture',
      serializers.serialize(object.has_picture,
          specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.place;
    if (value != null) {
      result
        ..add('place')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(_i1.Ggeography)));
    }
    value = object.timerange;
    if (value != null) {
      result
        ..add('timerange')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(_i1.Gtstzrange)));
    }
    return result;
  }

  @override
  GCreateBeaconVars deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GCreateBeaconVarsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'place':
          result.place.replace(serializers.deserialize(value,
                  specifiedType: const FullType(_i1.Ggeography))!
              as _i1.Ggeography);
          break;
        case 'timerange':
          result.timerange.replace(serializers.deserialize(value,
                  specifiedType: const FullType(_i1.Gtstzrange))!
              as _i1.Gtstzrange);
          break;
        case 'has_picture':
          result.has_picture = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$GCreateBeaconVars extends GCreateBeaconVars {
  @override
  final String title;
  @override
  final String description;
  @override
  final _i1.Ggeography? place;
  @override
  final _i1.Gtstzrange? timerange;
  @override
  final bool has_picture;

  factory _$GCreateBeaconVars(
          [void Function(GCreateBeaconVarsBuilder)? updates]) =>
      (new GCreateBeaconVarsBuilder()..update(updates))._build();

  _$GCreateBeaconVars._(
      {required this.title,
      required this.description,
      this.place,
      this.timerange,
      required this.has_picture})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'GCreateBeaconVars', 'title');
    BuiltValueNullFieldError.checkNotNull(
        description, r'GCreateBeaconVars', 'description');
    BuiltValueNullFieldError.checkNotNull(
        has_picture, r'GCreateBeaconVars', 'has_picture');
  }

  @override
  GCreateBeaconVars rebuild(void Function(GCreateBeaconVarsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GCreateBeaconVarsBuilder toBuilder() =>
      new GCreateBeaconVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GCreateBeaconVars &&
        title == other.title &&
        description == other.description &&
        place == other.place &&
        timerange == other.timerange &&
        has_picture == other.has_picture;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, place.hashCode);
    _$hash = $jc(_$hash, timerange.hashCode);
    _$hash = $jc(_$hash, has_picture.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GCreateBeaconVars')
          ..add('title', title)
          ..add('description', description)
          ..add('place', place)
          ..add('timerange', timerange)
          ..add('has_picture', has_picture))
        .toString();
  }
}

class GCreateBeaconVarsBuilder
    implements Builder<GCreateBeaconVars, GCreateBeaconVarsBuilder> {
  _$GCreateBeaconVars? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  _i1.GgeographyBuilder? _place;
  _i1.GgeographyBuilder get place =>
      _$this._place ??= new _i1.GgeographyBuilder();
  set place(_i1.GgeographyBuilder? place) => _$this._place = place;

  _i1.GtstzrangeBuilder? _timerange;
  _i1.GtstzrangeBuilder get timerange =>
      _$this._timerange ??= new _i1.GtstzrangeBuilder();
  set timerange(_i1.GtstzrangeBuilder? timerange) =>
      _$this._timerange = timerange;

  bool? _has_picture;
  bool? get has_picture => _$this._has_picture;
  set has_picture(bool? has_picture) => _$this._has_picture = has_picture;

  GCreateBeaconVarsBuilder();

  GCreateBeaconVarsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _description = $v.description;
      _place = $v.place?.toBuilder();
      _timerange = $v.timerange?.toBuilder();
      _has_picture = $v.has_picture;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GCreateBeaconVars other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GCreateBeaconVars;
  }

  @override
  void update(void Function(GCreateBeaconVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GCreateBeaconVars build() => _build();

  _$GCreateBeaconVars _build() {
    _$GCreateBeaconVars _$result;
    try {
      _$result = _$v ??
          new _$GCreateBeaconVars._(
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'GCreateBeaconVars', 'title'),
              description: BuiltValueNullFieldError.checkNotNull(
                  description, r'GCreateBeaconVars', 'description'),
              place: _place?.build(),
              timerange: _timerange?.build(),
              has_picture: BuiltValueNullFieldError.checkNotNull(
                  has_picture, r'GCreateBeaconVars', 'has_picture'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'place';
        _place?.build();
        _$failedField = 'timerange';
        _timerange?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GCreateBeaconVars', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
