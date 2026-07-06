import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instructor_profile_model.g.dart';

@JsonSerializable()
class InstructorProfileModel {
  final int id;
  final String name;
  final String? avatar;
  final String? title; // e.g., "Chuyên gia"
  final int postCount;
  final int followerCount;
  final int followingCount;
  final String? bio; // HTML content
  final List<String> coverImages;
  final bool isFollowed;

  InstructorProfileModel({
    required this.id,
    required this.name,
    this.avatar,
    this.title,
    this.postCount = 0,
    this.followerCount = 0,
    this.followingCount = 0,
    this.bio,
    this.coverImages = const [],
    this.isFollowed = false,
  });

  factory InstructorProfileModel.fromJson(Dictionary json) => _$InstructorProfileModelFromJson(json);
  Dictionary toJson() => _$InstructorProfileModelToJson(this);
}
