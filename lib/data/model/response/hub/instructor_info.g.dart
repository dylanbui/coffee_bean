// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorInfo _$InstructorInfoFromJson(Map<String, dynamic> json) =>
    InstructorInfo(
      id: (json['id'] as num).toInt(),
      instructorName: json['instructorName'] as String?,
      instructorAvatar: json['instructorAvatar'] as String?,
      instructorTitle: json['instructorTitle'] as String?,
      instructorDesc: json['instructorDesc'] as String?,
      instructorSkill: json['instructorSkill'] as String?,
    );

Map<String, dynamic> _$InstructorInfoToJson(InstructorInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instructorName': instance.instructorName,
      'instructorAvatar': instance.instructorAvatar,
      'instructorTitle': instance.instructorTitle,
      'instructorDesc': instance.instructorDesc,
      'instructorSkill': instance.instructorSkill,
    };
