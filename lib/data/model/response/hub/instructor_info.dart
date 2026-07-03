import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instructor_info.g.dart';

@JsonSerializable()
class InstructorInfo {
  final int id;
  final String? instructorName;
  final String? instructorAvatar;
  final String? instructorTitle;
  final String? instructorDesc;
  final String? instructorSkill;

  InstructorInfo({
    required this.id,
    this.instructorName,
    this.instructorAvatar,
    this.instructorTitle,
    this.instructorDesc,
    this.instructorSkill,
  });

  factory InstructorInfo.fromJson(Dictionary json) => _$InstructorInfoFromJson(json);
  Dictionary toJson() => _$InstructorInfoToJson(this);
}
