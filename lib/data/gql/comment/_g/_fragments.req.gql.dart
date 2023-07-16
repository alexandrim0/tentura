// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:gql/ast.dart' as _i5;
import 'package:gravity/data/gql/_g/serializers.gql.dart' as _i6;
import 'package:gravity/data/gql/comment/_g/_fragments.ast.gql.dart' as _i4;
import 'package:gravity/data/gql/comment/_g/_fragments.data.gql.dart' as _i2;
import 'package:gravity/data/gql/comment/_g/_fragments.var.gql.dart' as _i3;

part '_fragments.req.gql.g.dart';

abstract class GcommentFieldsReq
    implements
        Built<GcommentFieldsReq, GcommentFieldsReqBuilder>,
        _i1.FragmentRequest<_i2.GcommentFieldsData, _i3.GcommentFieldsVars> {
  GcommentFieldsReq._();

  factory GcommentFieldsReq([Function(GcommentFieldsReqBuilder b) updates]) =
      _$GcommentFieldsReq;

  static void _initializeBuilder(GcommentFieldsReqBuilder b) => b
    ..document = _i4.document
    ..fragmentName = 'commentFields';
  @override
  _i3.GcommentFieldsVars get vars;
  @override
  _i5.DocumentNode get document;
  @override
  String? get fragmentName;
  @override
  Map<String, dynamic> get idFields;
  @override
  _i2.GcommentFieldsData? parseData(Map<String, dynamic> json) =>
      _i2.GcommentFieldsData.fromJson(json);
  static Serializer<GcommentFieldsReq> get serializer =>
      _$gcommentFieldsReqSerializer;
  Map<String, dynamic> toJson() => (_i6.serializers.serializeWith(
        GcommentFieldsReq.serializer,
        this,
      ) as Map<String, dynamic>);
  static GcommentFieldsReq? fromJson(Map<String, dynamic> json) =>
      _i6.serializers.deserializeWith(
        GcommentFieldsReq.serializer,
        json,
      );
}