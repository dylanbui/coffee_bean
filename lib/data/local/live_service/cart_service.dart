import 'dart:async';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/repository/trade_repository.dart';
import 'package:db_core/network/network_utils.dart';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:db_core/utils/toast.dart';

class CartService implements DbLocatorDisposable {
  final DatabaseService _dbService = locator<DatabaseService>();
  final _cartController = StreamController<List<TblCartItem>>.broadcast();
  List<TblCartItem> _items = [];

  // Backup for rollback
  List<TblCartItem>? _rollbackItems;

  CartService() {
    _init();
  }

  void _init() {
    final userManager = UserManager();
    if (!userManager.isLogin) {
      // Guest: Watch Isar for any changes in the TblCartItem collection
      _dbService.isar.tblCartItems.watchLazy().listen((_) async {
        await _refreshFromLocal();
      });
      // Initial data fetch from local
      _refreshFromLocal();
    } else {
      // User: Load from server
      refreshFromServer();
    }
  }

  Future<void> _refreshFromLocal() async {
    try {
      _items = await _dbService.getCartItems();
      _cartController.add(List.unmodifiable(_items));
    } catch (e) {
      eLog("Error refreshing cart from Isar: $e");
    }
  }

  /// Query the user's shopping cart list: GET /app-api/trade/cart/list
  Future<void> refreshFromServer() async {
    if (!UserManager().isLogin) return;
    
    // TODO: Implement actual API call when UI is ready
    // For now, we still use local data or wait for future implementation
    await _refreshFromLocal();
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

  /// Add/Update item with Optimistic UI approach
  Future<void> addToCartOptimistic({
    required int skuId,
    required int quantity,
    Product? product,
    List<SelectedOption>? options,
  }) async {
    final userManager = UserManager();
    
    if (!userManager.isLogin) {
      // GUEST MODE: Save directly to Isar
      await _upsertLocal(skuId, quantity, product, options);
      return;
    }

    // LOGGED-IN MODE: Optimistic Update
    // 1. Backup current state
    _rollbackItems = List.from(_items.map((e) => _cloneCartItem(e)));

    // 2. Update memory & notify UI immediately (0ms)
    final existingItem = _items.where((i) => i.skuId == skuId).firstOrNull;
    final int? currentCartItemId = existingItem?.cartItemId;

    _updateMemory(skuId, quantity, product, options);
    _cartController.add(List.unmodifiable(_items));

    // 3. Background API call
    final tradeRepo = locator<TradeRepository>();
    DbResult<dynamic> result;

    if (quantity <= 0) {
      if (currentCartItemId != null && currentCartItemId > 0) {
        result = await tradeRepo.deleteCartItems([currentCartItemId]);
      } else {
        // No server ID, already removed from memory, nothing to sync
        return;
      }
    } else {
      if (currentCartItemId != null && currentCartItemId > 0) {
        result = await tradeRepo.updateCartItemCount(id: currentCartItemId, count: quantity);
      } else {
        result = await tradeRepo.addToCart(skuId: skuId, count: quantity);
        // If it's a new item, update the memory item with the new cartItemId from server
        if (result case DbSuccess(data: final int newId)) {
          final item = _items.where((i) => i.skuId == skuId).firstOrNull;
          if (item != null) item.cartItemId = newId;
        }
      }
    }

    if (result case DbFailure(:final error)) {
      // 4. Rollback on failure
      _items = _rollbackItems ?? [];
      _cartController.add(List.unmodifiable(_items));
      DbToast.show(error.message);
    } else {
      // Success: Clear backup
      _rollbackItems = null;
    }
  }

  /// Merge Guest Cart to Server after Login
  Future<void> mergeLocalCartToServer() async {
    if (!UserManager().isLogin) return;

    final localItems = await _dbService.getCartItems();
    if (localItems.isEmpty) {
      await refreshFromServer();
      return;
    }

    final tradeRepo = locator<TradeRepository>();
    
    // Sync each item to server
    for (var item in localItems) {
      if (item.skuId > 0) {
        await tradeRepo.addToCart(skuId: item.skuId, count: item.quantity);
      }
    }

    // Clear local data after successful merge
    await clearCart();
    
    // Refresh the canonical list from server
    await refreshFromServer();
  }

  void _updateMemory(int skuId, int quantity, Product? product, List<SelectedOption>? options) {
    final index = _items.indexWhere((item) => item.skuId == skuId);
    
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
    } else if (quantity > 0 && product != null) {
      double price = product.price / 100.0;
      options?.forEach((o) => price += o.extraPrice);

      final newItem = TblCartItem()
        ..skuId = skuId
        ..spuId = product.id
        ..cartItemId = 0 // Will be updated after API call
        ..name = product.name
        ..image = product.picUrl
        ..finalPrice = price
        ..quantity = quantity
        ..selectedOptions = options
        ..addedAt = DateTime.now();
      
      _items.add(newItem);
    }
  }

  Future<void> _upsertLocal(int skuId, int quantity, Product? product, List<SelectedOption>? options) async {
    final isar = _dbService.isar;
    await isar.writeTxn(() async {
      final existing = await isar.tblCartItems.filter().skuIdEqualTo(skuId).findFirst();

      if (existing != null) {
        if (quantity <= 0) {
          await isar.tblCartItems.delete(existing.id);
        } else {
          existing.quantity = quantity;
          await isar.tblCartItems.put(existing);
        }
      } else if (quantity > 0 && product != null) {
        double price = product.price / 100.0;
        options?.forEach((o) => price += o.extraPrice);

        final newItem = TblCartItem()
          ..skuId = skuId
          ..spuId = product.id
          ..name = product.name
          ..image = product.picUrl
          ..finalPrice = price
          ..quantity = quantity
          ..selectedOptions = options
          ..addedAt = DateTime.now();
        await isar.tblCartItems.put(newItem);
      }
    });
  }

  TblCartItem _cloneCartItem(TblCartItem item) {
    return TblCartItem()
      ..id = item.id
      ..spuId = item.spuId
      ..skuId = item.skuId
      ..cartItemId = item.cartItemId
      ..type = item.type
      ..sku = item.sku
      ..name = item.name
      ..image = item.image
      ..finalPrice = item.finalPrice
      ..quantity = item.quantity
      ..selectedOptions = item.selectedOptions != null ? List.from(item.selectedOptions!) : null
      ..addedAt = item.addedAt;
  }

  // --- COMPATIBILITY WRAPPERS FOR EXISTING CODE ---

  Future<void> upsertCartItem(dynamic product, int quantity, List<SelectedOption>? options, {int? skuId}) async {
    if (product is! Product) {
       eLog("Unsupported product type for upsertCartItem: ${product.runtimeType}");
       return;
    }
    await addToCartOptimistic(
      skuId: skuId ?? 0, 
      quantity: quantity, 
      product: product, 
      options: options
    );
  }

  int getQuantity(dynamic product, List<SelectedOption>? options, {int? skuId}) {
    if (skuId != null && skuId > 0) {
      final item = _items.where((i) => i.skuId == skuId).firstOrNull;
      return item?.quantity ?? 0;
    }
    
    // Fallback if no skuId (searching by spuId and matching options)
    int spuId = (product is Product) ? product.id : 0;
    final item = _items.where((i) => 
      i.spuId == spuId &&
      compareOptions(i.selectedOptions, options)
    ).firstOrNull;
    
    return item?.quantity ?? 0;
  }

  bool compareOptions(List<SelectedOption>? list1, List<SelectedOption>? list2) {
    if (list1 == null && list2 == null) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;

    for (var o1 in list1) {
      final found = list2.any((o2) => o2.optionServerId == o1.optionServerId && o2.groupName == o1.groupName);
      if (!found) return false;
    }
    return true;
  }

  Future<void> clearCart() async {
    await _dbService.isar.writeTxn(() async {
      await _dbService.isar.tblCartItems.clear();
    });
    if (UserManager().isLogin) {
      _items = [];
      _cartController.add([]);
    }
  }

  @override
  void dispose() {
    _cartController.close();
  }
}
