import 'package:json_annotation/json_annotation.dart';
import 'package:coffee_bean/data/model/response/product/product.dart';
import 'package:db_core/commons_constants.dart';

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

  num get totalPrice => product.price * quantity;

  factory CartItem.fromJson(Dictionary json) => _$CartItemFromJson(json);
  Dictionary toJson() => _$CartItemToJson(this);
  
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
