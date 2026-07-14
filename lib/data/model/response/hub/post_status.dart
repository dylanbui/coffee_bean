import 'package:json_annotation/json_annotation.dart';

part 'post_status.g.dart';

@JsonSerializable()
class PostStatus {
  final bool? liked;
  final bool? favorited;
  final bool? followed;

  PostStatus({
    this.liked,
    this.favorited,
    this.followed,
  });

  factory PostStatus.fromJson(Map<String, dynamic> json) =>
      _$PostStatusFromJson(json);

  Map<String, dynamic> toJson() => _$PostStatusToJson(this);
}
