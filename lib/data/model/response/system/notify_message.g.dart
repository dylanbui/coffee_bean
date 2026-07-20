// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notify_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifyMessage _$NotifyMessageFromJson(Map<String, dynamic> json) =>
    NotifyMessage(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      userType: json['userType'] as String,
      templateId: (json['templateId'] as num).toInt(),
      templateCode: json['templateCode'] as String,
      templateNickname: json['templateNickname'] as String,
      templateContent: json['templateContent'] as String,
      templateType: (json['templateType'] as num).toInt(),
      templateParams: json['templateParams'] as Map<String, dynamic>,
      readStatus: json['readStatus'] as bool,
      readTime: (json['readTime'] as num?)?.toInt(),
      createTime: (json['createTime'] as num).toInt(),
    );

Map<String, dynamic> _$NotifyMessageToJson(NotifyMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userType': instance.userType,
      'templateId': instance.templateId,
      'templateCode': instance.templateCode,
      'templateNickname': instance.templateNickname,
      'templateContent': instance.templateContent,
      'templateType': instance.templateType,
      'templateParams': instance.templateParams,
      'readStatus': instance.readStatus,
      'readTime': instance.readTime,
      'createTime': instance.createTime,
    };
