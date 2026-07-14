// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostStatus _$PostStatusFromJson(Map<String, dynamic> json) => PostStatus(
  liked: json['liked'] as bool?,
  favorited: json['favorited'] as bool?,
  followed: json['followed'] as bool?,
);

Map<String, dynamic> _$PostStatusToJson(PostStatus instance) =>
    <String, dynamic>{
      'liked': instance.liked,
      'favorited': instance.favorited,
      'followed': instance.followed,
    };
