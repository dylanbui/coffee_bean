import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dictionary_data.g.dart';

@JsonSerializable()
class DictionaryData {
  final int id;
  final String label;
  final String value;
  final String dictType;

  DictionaryData({
    required this.id,
    required this.label,
    required this.value,
    required this.dictType,
  });

  factory DictionaryData.fromJson(Dictionary json) => _$DictionaryDataFromJson(json);

  Dictionary toJson() => _$DictionaryDataToJson(this);
}
