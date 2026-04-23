import 'package:json_annotation/json_annotation.dart';
import 'package:coffee_bean/data/model/product.dart';

part 'liked_product.g.dart';

@JsonSerializable(explicitToJson: true)
class LikedProduct {
  final Product product;
  final DateTime likedAt;

  LikedProduct({
    required this.product,
    required this.likedAt,
  });

  int get productId => product.id ?? 0;

  factory LikedProduct.fromJson(Map<String, dynamic> json) => _$LikedProductFromJson(json);
  Map<String, dynamic> toJson() => _$LikedProductToJson(this);
}
