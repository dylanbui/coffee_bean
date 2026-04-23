import 'package:json_annotation/json_annotation.dart';
import 'package:coffee_bean/data/model/product.dart';

part 'cart_item.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItem {
  final Product product;
  int quantity;
  String? note;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.note,
  });

  String get cartItemId => "${product.id}_${note ?? ''}";

  double get totalPrice => (product.price ?? 0) * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
  
  CartItem copyWith({
    Product? product,
    int? quantity,
    String? note,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}
