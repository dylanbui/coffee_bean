import 'package:json_annotation/json_annotation.dart';

part 'file_upload_response.g.dart';

@JsonSerializable()
class FileUploadResponse {
  final String? originalname;
  final String? filename;
  final String? location;

  FileUploadResponse({this.originalname, this.filename, this.location});

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) => _$FileUploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadResponseToJson(this);
}
