import 'package:isar_community/isar.dart';
import 'product.dart';

part 'cart.g.dart';

@collection
class TblCartItem {
  Id id = Isar.autoIncrement;

  @Index()
  int spuId = 0;

  @Index()
  int skuId = 0;

  @Index()
  int cartItemId = 0;

  @Index()
  String type = "FOOD";

  String? sku;
  String name = "";
  String? image;
  double finalPrice = 0.0;
  int quantity = 0;

  List<SelectedOption>? selectedOptions;

  DateTime addedAt = DateTime.now();

  @ignore
  double get totalPrice => finalPrice * quantity;

  // Chuyển đổi sang định dạng JSON để gửi lên Server khi tạo Order
  Map<String, dynamic> toJsonRequest() {
    return {
      'cart_item_id': cartItemId,
      'spu_id': spuId,
      'sku_id': skuId,
      'product_type': type,
      'quantity': quantity,
      'price': finalPrice,
      'sku': sku,
      'options': selectedOptions?.map((o) => o.toJson()).toList(),
    };
  }
}
