// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorProfileModel _$InstructorProfileModelFromJson(
  Map<String, dynamic> json,
) => InstructorProfileModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  avatar: json['avatar'] as String?,
  title: json['title'] as String?,
  postCount: (json['postCount'] as num?)?.toInt() ?? 0,
  followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
  followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
  bio: json['bio'] as String?,
  coverImages:
      (json['coverImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  isFollowed: json['isFollowed'] as bool? ?? false,
);

Map<String, dynamic> _$InstructorProfileModelToJson(
  InstructorProfileModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar': instance.avatar,
  'title': instance.title,
  'postCount': instance.postCount,
  'followerCount': instance.followerCount,
  'followingCount': instance.followingCount,
  'bio': instance.bio,
  'coverImages': instance.coverImages,
  'isFollowed': instance.isFollowed,
};
