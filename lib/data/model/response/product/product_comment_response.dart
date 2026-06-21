import 'package:coffee_bean/data/model/product.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_comment_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductComment extends Equatable {
  final int id;
  final int userId;
  final String userNickname;
  final String userAvatar;
  final bool anonymous;
  final int orderId;
  final int orderItemId;
  final bool replyStatus;
  final int? replyUserId;
  final String? replyContent;
  final DateTime? replyTime;
  final String? additionalContent;
  final List<String>? additionalPicUrls;
  final DateTime? additionalTime;
  final DateTime? createTime;
  final int spuId;
  final String spuName;
  final int skuId;
  final List<SkuProperty>? skuProperties;
  final int scores;
  final int descriptionScores;
  final int benefitScores;
  final String content;
  final List<String> picUrls;

  const ProductComment({
    required this.id,
    required this.userId,
    required this.userNickname,
    required this.userAvatar,
    required this.anonymous,
    required this.orderId,
    required this.orderItemId,
    required this.replyStatus,
    this.replyUserId,
    this.replyContent,
    this.replyTime,
    this.additionalContent,
    this.additionalPicUrls,
    this.additionalTime,
    this.createTime,
    required this.spuId,
    required this.spuName,
    required this.skuId,
    this.skuProperties,
    required this.scores,
    required this.descriptionScores,
    required this.benefitScores,
    required this.content,
    required this.picUrls,
  });

  factory ProductComment.fromJson(Map<String, dynamic> json) => _$ProductCommentFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCommentToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        userNickname,
        userAvatar,
        anonymous,
        orderId,
        orderItemId,
        replyStatus,
        replyUserId,
        replyContent,
        replyTime,
        additionalContent,
        additionalPicUrls,
        additionalTime,
        createTime,
        spuId,
        spuName,
        skuId,
        skuProperties,
        scores,
        descriptionScores,
        benefitScores,
        content,
        picUrls,
      ];
}
