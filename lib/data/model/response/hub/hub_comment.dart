import 'package:coffee_bean/scenes/comment_list/comment_constant.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hub_comment.g.dart';

@JsonSerializable()
class HubComment implements IComment {
  @override
  final int id;
  
  final int? userId;

  @JsonKey(name: 'userNickname', defaultValue: '')
  @override
  final String userNickname;

  @JsonKey(name: 'userAvatar', defaultValue: '')
  @override
  final String userAvatar;

  final int? resourceId;
  final int? parentId;
  final String? commentContent;
  
  @JsonKey(name: 'createTime')
  final int? createTimeInt;
  
  final List<HubComment>? replies;
  final bool? isOwn;

  HubComment({
    required this.id,
    this.userId,
    required this.userNickname,
    required this.userAvatar,
    this.resourceId,
    this.parentId,
    this.commentContent,
    this.createTimeInt,
    this.replies,
    this.isOwn,
  });

  @override
  String get content => commentContent ?? "";

  @override
  DateTime? get createTime => createTimeInt != null 
    ? DateTime.fromMillisecondsSinceEpoch(createTimeInt!) 
    : null;

  @override
  List<String> get picUrls => []; 

  @override
  int get scores => 0; 

  @override
  bool get replyStatus => replies != null && replies!.isNotEmpty;

  @override
  String? get replyContent => replyStatus ? replies![0].commentContent : null;

  @override
  DateTime? get replyTime => replyStatus ? (replies![0].createTimeInt != null ? DateTime.fromMillisecondsSinceEpoch(replies![0].createTimeInt!) : null) : null;

  String get displayCreateTime => createTimeInt != null 
    ? UtcUtils.toDateTimeStr(createTimeInt, format: AppDateTimeFormat.full) 
    : "";

  factory HubComment.fromJson(Map<String, dynamic> json) =>
      _$HubCommentFromJson(json);

  Map<String, dynamic> toJson() => _$HubCommentToJson(this);
}
