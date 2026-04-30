// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileUploadResponse _$FileUploadResponseFromJson(Map<String, dynamic> json) =>
    FileUploadResponse(
      originalname: json['originalname'] as String?,
      filename: json['filename'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$FileUploadResponseToJson(FileUploadResponse instance) =>
    <String, dynamic>{
      'originalname': instance.originalname,
      'filename': instance.filename,
      'location': instance.location,
    };
