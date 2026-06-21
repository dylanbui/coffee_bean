// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageResult<T> _$PageResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PageResult<T>(
  total: (json['total'] as num).toInt(),
  list: (json['list'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$PageResultToJson<T>(
  PageResult<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'total': instance.total,
  'list': instance.list.map(toJsonT).toList(),
};
