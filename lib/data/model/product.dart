import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:coffee_bean/data/model/category.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product extends Equatable {
  final int id;
  final String? title;
  final String? slug;
  final double? price;
  final String? description;
  final Category? category;
  final List<String>? images;

  const Product({
    this.id = 0,
    this.title,
    this.slug,
    this.price,
    this.description,
    this.category,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    int? id,
    String? title,
    String? slug,
    double? price,
    String? description,
    Category? category,
    List<String>? images,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      images: images ?? this.images,
    );
  }

  @override
  List<Object?> get props => [id, title, slug, price, description, category, images];
}
