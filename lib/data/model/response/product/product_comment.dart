import 'package:coffee_bean/data/model/response/product/product.dart';
import 'package:coffee_bean/scenes/comment_list/comment_constant.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_comment.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductComment extends Equatable implements IComment {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String userNickname;
  @override
  final String userAvatar;
  final bool anonymous;
  final int orderId;
  final int orderItemId;
  @override
  final bool replyStatus;
  final int? replyUserId;
  @override
  final String? replyContent;
  @override
  final DateTime? replyTime;
  final String? additionalContent;
  final List<String>? additionalPicUrls;
  final DateTime? additionalTime;
  @override
  final DateTime? createTime;
  final int spuId;
  final String spuName;
  final int skuId;
  final List<SkuProperty>? skuProperties;
  @override
  final int scores;
  final int descriptionScores;
  final int benefitScores;
  @override
  final String content;
  @override
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
