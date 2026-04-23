import 'package:json_annotation/json_annotation.dart';
import 'category.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  int id = 0;
  String? title;
  String? slug;
  double? price;
  String? description;
  Category? category;
  List<String>? images;

  Product({this.id = 0, this.title, this.slug, this.price, this.description, this.category, this.images});

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
