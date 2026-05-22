// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikedProduct _$LikedProductFromJson(Map<String, dynamic> json) => LikedProduct(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      likedAt: DateTime.parse(json['likedAt'] as String),
    );

Map<String, dynamic> _$LikedProductToJson(LikedProduct instance) =>
    <String, dynamic>{
      'product': instance.product.toJson(),
      'likedAt': instance.likedAt.toIso8601String(),
    };
