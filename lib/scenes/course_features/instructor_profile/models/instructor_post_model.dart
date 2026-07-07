import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instructor_post_model.g.dart';

@JsonSerializable()
class InstructorPostModel {
  final int id;
  final String title;
  final String? coverImage;
  final int viewCount;
  final String? authorName;
  final String? authorAvatar;
  final bool isVideo;

  InstructorPostModel({
    required this.id,
    required this.title,
    this.coverImage,
    this.viewCount = 0,
    this.authorName,
    this.authorAvatar,
    this.isVideo = false,
  });

  factory InstructorPostModel.fromJson(Dictionary json) => _$InstructorPostModelFromJson(json);
  Dictionary toJson() => _$InstructorPostModelToJson(this);
}
