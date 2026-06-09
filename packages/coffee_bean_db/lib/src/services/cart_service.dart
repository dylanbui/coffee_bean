import 'package:coffee_bean_db/src/app_database.dart';
import 'package:isar_community/isar.dart';
import 'base_mixin.dart';

mixin CartServiceMixin on BaseMixin {
  Future<List<TblCartItem>> getCartItems() => isar.tblCartItems.where().sortByAddedAtDesc().findAll();

  Future<void> updateCartItem(TblCartItem item) async {
    await isar.writeTxn(() => isar.tblCartItems.put(item));
  }

  Future<void> removeFromCart(int id) async {
    await isar.writeTxn(() => isar.tblCartItems.delete(id));
  }

  Future<void> clearCartByType(ProductType type) async {
    await isar.writeTxn(() async {
      await isar.tblCartItems.filter().typeEqualTo(type.name).deleteAll();
    });
  }
}
