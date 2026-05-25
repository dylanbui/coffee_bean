import 'dart:async';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/model/product.dart';

class CartService implements DbLocatorDisposable {
  final DatabaseService _dbService = locator<DatabaseService>();
  final _cartController = StreamController<List<TblCartItem>>.broadcast();
  List<TblCartItem> _items = [];

  CartService() {
    _init();
  }

  void _init() {
    // Watch Isar for any changes in the TblCartItem collection
    _dbService.isar.tblCartItems.watchLazy().listen((_) async {
      await _refresh();
    });
    // Initial data fetch
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      _items = await _dbService.getCartItems();
      _cartController.add(List.unmodifiable(_items));
    } catch (e) {
      eLog("Error refreshing cart from Isar: $e");
    }
  }

  Stream<List<TblCartItem>> get cartStream {
    return Stream<List<TblCartItem>>.multi((controller) {
      // Emit current data immediately to the new listener
      controller.add(List.unmodifiable(_items));

      // Subscribe to updates from the main broadcast controller
      final subscription = _cartController.stream.listen(
        (event) => controller.add(event),
        onError: (e) => controller.addError(e),
        onDone: () => controller.close(),
      );

      controller.onCancel = () => subscription.cancel();
    }, isBroadcast: true);
  }

  List<TblCartItem> get currentItems => List.unmodifiable(_items);

  Future<void> addToCart(dynamic product, {int quantity = 1, List<SelectedOption>? options}) async {
    int serverId;
    ProductType productType;
    String name;
    String? image;
    String? sku;
    double price;

    if (product is TblFood) {
      serverId = product.serverId;
      productType = ProductType.food;
      name = product.name;
      image = product.mainImage;
      sku = product.sku;
      price = product.price;
    } else if (product is TblCourse) {
      serverId = product.serverId;
      productType = ProductType.course;
      name = product.name;
      image = product.mainImage;
      sku = product.sku;
      price = product.price;
    } else if (product is Product) {
      serverId = product.id;
      productType = ProductType.food; // Default mapping
      name = product.title ?? "";
      image = product.images?.firstOrNull;
      price = product.price ?? 0.0;
    } else {
      eLog("Unsupported product type for addToCart: ${product.runtimeType}");
      return;
    }

    final isar = _dbService.isar;
    await isar.writeTxn(() async {
      // Find items with same serverId and type
      final items = await isar.tblCartItems.filter()
          .serverIdEqualTo(serverId)
          .and()
          .typeEqualTo(productType.name)
          .findAll();

      TblCartItem? existing;
      if (options == null || options.isEmpty) {
        existing = items.where((i) => i.selectedOptions == null || i.selectedOptions!.isEmpty).firstOrNull;
      } else {
        existing = items.where((i) => _compareOptions(i.selectedOptions, options)).firstOrNull;
      }

      if (existing != null) {
        existing.quantity += quantity;
        await isar.tblCartItems.put(existing);
      } else {
        double finalPrice = price;
        options?.forEach((o) => finalPrice += o.extraPrice);

        final newItem = TblCartItem()
          ..serverId = serverId
          ..type = productType.name
          ..name = name
          ..image = image
          ..sku = sku
          ..finalPrice = finalPrice
          ..quantity = quantity
          ..selectedOptions = options
          ..addedAt = DateTime.now();
        await isar.tblCartItems.put(newItem);
      }
    });
  }

  Future<void> updateQuantityIfInCart(dynamic product, int quantity, List<SelectedOption>? options) async {
    int serverId;
    String type;
    if (product is TblFood) {
      serverId = product.serverId;
      type = ProductType.food.name;
    } else if (product is TblCourse) {
      serverId = product.serverId;
      type = ProductType.course.name;
    } else return;

    final isar = _dbService.isar;
    await isar.writeTxn(() async {
      final items = await isar.tblCartItems.filter()
          .serverIdEqualTo(serverId)
          .and()
          .typeEqualTo(type)
          .findAll();

      TblCartItem? existing;
      if (options == null || options.isEmpty) {
        existing = items.where((i) => i.selectedOptions == null || i.selectedOptions!.isEmpty).firstOrNull;
      } else {
        existing = items.where((i) => _compareOptions(i.selectedOptions, options)).firstOrNull;
      }

      if (existing != null) {
        existing.quantity = quantity;
        await isar.tblCartItems.put(existing);
      }
    });
  }

  bool _compareOptions(List<SelectedOption>? list1, List<SelectedOption>? list2) {
    if (list1 == null && list2 == null) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;

    for (var o1 in list1) {
      final found = list2.any((o2) => o2.optionServerId == o1.optionServerId && o2.groupName == o1.groupName);
      if (!found) return false;
    }
    return true;
  }

  Future<void> updateQuantity(int id, int quantity) async {
    await _dbService.isar.writeTxn(() async {
      if (quantity <= 0) {
        await _dbService.isar.tblCartItems.delete(id);
      } else {
        final item = await _dbService.isar.tblCartItems.get(id);
        if (item != null) {
          item.quantity = quantity;
          await _dbService.isar.tblCartItems.put(item);
        }
      }
    });
  }

  Future<void> removeItem(int id) async {
    await _dbService.isar.writeTxn(() async {
      await _dbService.isar.tblCartItems.delete(id);
    });
  }

  Future<void> clearCart() async {
    await _dbService.isar.writeTxn(() async {
      await _dbService.isar.tblCartItems.clear();
    });
  }

  @override
  void dispose() {
    _cartController.close();
  }
}
