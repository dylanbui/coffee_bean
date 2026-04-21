

import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {

  // "userId": 1,
  // "id": 3,
  // "title": "ea molestias quasi exercitationem repellat qui ipsa sit aut",
  // "body": "et

  int? userId;
  int? id;
  String? title;
  String? body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

  // ... properties ...
  // Chúng ta ép kiểu dynamic -> Map tại đây để mapToData chạy mượt mà
  // static Post fromMap(dynamic json) => Post.fromJson(json as Map<String, dynamic>);
  // static List<Post> fromJsonList(dynamic json) => (json as List).map((e) => Post.fromJson(e)).toList();


  /**

  Real code
factory Post.fromJson(Map<String, dynamic> json)
  {
    return Post(
      userId: json["userId"],
      postId: json['id'],
      title: json["title"],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson()=>
      {
        'userId': userId,
        'id': postId,
        'title': title,
        'body': body,
      };



  * */

}