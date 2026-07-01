import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final int id;
  final int parentId;
  final String name;
  final String picUrl;

  Category({
    required this.id,
    required this.parentId,
    required this.name,
    required this.picUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
