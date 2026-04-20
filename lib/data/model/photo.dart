

import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {

  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);

  // ... properties ...
  // Chúng ta ép kiểu dynamic -> Map tại đây để mapToData chạy mượt mà
  static Photo fromMap(dynamic json) => Photo.fromJson(json as Map<String, dynamic>);
  static List<Photo> fromJsonList(dynamic json) => (json as List).map((e) => Photo.fromJson(e)).toList();

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