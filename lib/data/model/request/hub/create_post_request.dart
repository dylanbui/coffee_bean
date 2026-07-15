import 'package:json_annotation/json_annotation.dart';

part 'create_post_request.g.dart';

@JsonSerializable()
class CreatePostRequest {
  @JsonKey(name: 'postTitle')
  final String postTitle;
  
  @JsonKey(name: 'postContent')
  final String postContent;
  
  @JsonKey(name: 'topicTags')
  final List<String> topicTags;
  
  @JsonKey(name: 'postCover')
  final String? postCover;

  CreatePostRequest({
    required this.postTitle,
    required this.postContent,
    required this.topicTags,
    this.postCover,
  });

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostRequestToJson(this);
}
