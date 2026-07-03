// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductComment _$ProductCommentFromJson(Map<String, dynamic> json) =>
    ProductComment(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      userNickname: json['userNickname'] as String,
      userAvatar: json['userAvatar'] as String,
      anonymous: json['anonymous'] as bool,
      orderId: (json['orderId'] as num).toInt(),
      orderItemId: (json['orderItemId'] as num).toInt(),
      replyStatus: json['replyStatus'] as bool,
      replyUserId: (json['replyUserId'] as num?)?.toInt(),
      replyContent: json['replyContent'] as String?,
      replyTime: json['replyTime'] == null
          ? null
          : DateTime.parse(json['replyTime'] as String),
      additionalContent: json['additionalContent'] as String?,
      additionalPicUrls: (json['additionalPicUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      additionalTime: json['additionalTime'] == null
          ? null
          : DateTime.parse(json['additionalTime'] as String),
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      spuId: (json['spuId'] as num).toInt(),
      spuName: json['spuName'] as String,
      skuId: (json['skuId'] as num).toInt(),
      skuProperties: (json['skuProperties'] as List<dynamic>?)
          ?.map((e) => SkuProperty.fromJson(e as Map<String, dynamic>))
          .toList(),
      scores: (json['scores'] as num).toInt(),
      descriptionScores: (json['descriptionScores'] as num).toInt(),
      benefitScores: (json['benefitScores'] as num).toInt(),
      content: json['content'] as String,
      picUrls: (json['picUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProductCommentToJson(ProductComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userNickname': instance.userNickname,
      'userAvatar': instance.userAvatar,
      'anonymous': instance.anonymous,
      'orderId': instance.orderId,
      'orderItemId': instance.orderItemId,
      'replyStatus': instance.replyStatus,
      'replyUserId': instance.replyUserId,
      'replyContent': instance.replyContent,
      'replyTime': instance.replyTime?.toIso8601String(),
      'additionalContent': instance.additionalContent,
      'additionalPicUrls': instance.additionalPicUrls,
      'additionalTime': instance.additionalTime?.toIso8601String(),
      'createTime': instance.createTime?.toIso8601String(),
      'spuId': instance.spuId,
      'spuName': instance.spuName,
      'skuId': instance.skuId,
      'skuProperties': instance.skuProperties?.map((e) => e.toJson()).toList(),
      'scores': instance.scores,
      'descriptionScores': instance.descriptionScores,
      'benefitScores': instance.benefitScores,
      'content': instance.content,
      'picUrls': instance.picUrls,
    };
