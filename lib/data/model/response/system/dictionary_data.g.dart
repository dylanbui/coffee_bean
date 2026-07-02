// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DictionaryData _$DictionaryDataFromJson(Map<String, dynamic> json) =>
    DictionaryData(
      id: (json['id'] as num).toInt(),
      label: json['label'] as String,
      value: json['value'] as String,
      dictType: json['dictType'] as String,
    );

Map<String, dynamic> _$DictionaryDataToJson(DictionaryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'value': instance.value,
      'dictType': instance.dictType,
    };
