import 'dart:async';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/repository/trade_repository.dart';
import 'package:db_core/network/network_utils.dart';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:db_core/utils/toast.dart';

/// Service quản lý giỏ hàng toàn app (Cart Management Service).
/// 
/// Hỗ trợ 2 chế độ vận hành:
/// 1. **Guest Mode**: Lưu trữ trực tiếp vào Isar Database (Local).
/// 2. **Member Mode**: Sử dụng cơ chế Optimistic UI (cập nhật bộ nhớ ngay lập tức, 
///    đồng bộ API ngầm và rollback nếu lỗi) để mang lại trải nghiệm mượt mà.
class CartService implements DbLocatorDisposable {
  
  // --- Properties ---
  
  final DatabaseService _dbService = locator<DatabaseService>();
  
  /// Controller quản lý luồng dữ liệu giỏ hàng để cập nhật UI real-time.
  final _cartController = StreamController<List<TblCartItem>>.broadcast();
  
  /// Danh sách item hiện tại trong bộ nhớ.
  List<TblCartItem> _items = [];

  /// Bản sao lưu dùng để khôi phục trạng thái (Rollback) khi API gặp lỗi.
  List<TblCartItem>? _rollbackItems;

  // --- Initialization ---

  CartService() {
    _init();
  }

  /// Khởi tạo trạng thái ban đầu dựa trên trạng thái đăng nhập của người dùng.
  void _init() {
    final userManager = UserManager();
    if (!userManager.isLogin) {
      // CHẾ ĐỘ GUEST: Theo dõi thay đổi từ Isar DB
      _dbService.isar.tblCartItems.watchLazy().listen((_) async {
        await _refreshFromLocal();
      });
      _refreshFromLocal();
    } else {
      // CHẾ ĐỘ USER: Đồng bộ dữ liệu từ Server
      refreshFromServer();
    }
  }

  /// Stream cung cấp dữ liệu giỏ hàng cho UI. 
  /// Phát dữ liệu hiện tại ngay khi có listener mới kết nối.
  Stream<List<TblCartItem>> get cartStream {
    return Stream<List<TblCartItem>>.multi((controller) {
      controller.add(List.unmodifiable(_items));

      final subscription = _cartController.stream.listen(
        (event) => controller.add(event),
        onError: (e) => controller.addError(e),
        onDone: () => controller.close(),
      );

      controller.onCancel = () => subscription.cancel();
    }, isBroadcast: true);
  }

  @override
  void dispose() {
    _cartController.close();
  }
}

// --- EXTENSION: PUBLIC ACTIONS ---

extension CartServiceActions on CartService {
  /// Thêm hoặc cập nhật sản phẩm vào giỏ hàng với Optimistic UI.
  Future<void> addToCart({
    required int skuId,
    required int quantity,
    Product? product,
    List<SelectedOption>? options,
  }) async {
    final userManager = UserManager();
    
    if (!userManager.isLogin) {
      // Xử lý trực tiếp vào DB nếu chưa đăng nhập
      await _upsertLocal(skuId, quantity, product, options);
      return;
    }

    // --- LOGIC CHO MEMBER (OPTIMISTIC UI) ---
    
    // 1. Sao lưu trạng thái hiện tại đề phòng lỗi
    _rollbackItems = List.from(_items.map((e) => _cloneCartItem(e)));

    // 2. Cập nhật bộ nhớ và UI ngay lập tức (0ms latency)
    final existingItem = _items.where((i) => i.skuId == skuId).firstOrNull;
    final int? currentCartItemId = existingItem?.cartItemId;

    _updateMemory(skuId, quantity, product, options);
    _notifyUI();

    // 3. Thực hiện gọi API đồng bộ ngầm
    final tradeRepo = locator<TradeRepository>();
    DbResult<dynamic> result;

    if (quantity <= 0) {
      // Trường hợp xóa item
      if (currentCartItemId != null && currentCartItemId > 0) {
        result = await tradeRepo.deleteCartItems([currentCartItemId]);
      } else {
        return; // Item chưa có trên server, không cần sync
      }
    } else {
      // Trường hợp thêm mới hoặc cập nhật số lượng
      if (currentCartItemId != null && currentCartItemId > 0) {
        result = await tradeRepo.updateCartItemCount(id: currentCartItemId, count: quantity);
      } else {
        result = await tradeRepo.addToCart(skuId: skuId, count: quantity);
        // Cập nhật cartItemId thực từ server nếu là item mới
        if (result case DbSuccess(data: final int newId)) {
          final item = _items.where((i) => i.skuId == skuId).firstOrNull;
          if (item != null) item.cartItemId = newId;
        }
      }
    }

    // 4. Xử lý kết quả API
    if (result case DbFailure(:final error)) {
      // Lỗi: Khôi phục lại trạng thái cũ và báo lỗi
      _items = _rollbackItems ?? [];
      _notifyUI();
      DbToast.show(error.message);
    } else {
      // Thành công: Xóa bản sao lưu
      _rollbackItems = null;
    }
  }

  /// Xóa toàn bộ giỏ hàng.
  Future<void> clearCart() async {
    await _dbService.isar.writeTxn(() async {
      await _dbService.isar.tblCartItems.clear();
    });
    if (UserManager().isLogin) {
      _items = [];
      _notifyUI();
    }
  }
}

// --- EXTENSION: QUERIES ---

extension CartServiceQueries on CartService {
  /// Lấy danh sách item hiện tại (Snapshot).
  List<TblCartItem> get currentItems => List.unmodifiable(_items);

  /// Lấy số lượng của một sản phẩm hiện có trong giỏ hàng.
  /// Hỗ trợ tìm kiếm theo [skuId] hoặc [spuId] kết hợp với [options].
  int getItemQuantity({int? skuId, int? spuId, List<SelectedOption>? options}) {
    if (skuId != null && skuId > 0) {
      final item = _items.where((i) => i.skuId == skuId).firstOrNull;
      return item?.quantity ?? 0;
    }
    
    if (spuId != null && spuId > 0) {
      final item = _items.where((i) => 
        i.spuId == spuId &&
        i.selectedOptions.isSameAs(options)
      ).firstOrNull;
      return item?.quantity ?? 0;
    }
    
    return 0;
  }
}

// --- EXTENSION: SYNCHRONIZATION ---

extension CartServiceSync on CartService {
  /// Tải lại danh sách giỏ hàng từ Server.
  Future<void> refreshFromServer() async {
    if (!UserManager().isLogin) return;
    
    // TODO: Implement actual API call: GET /app-api/trade/cart/list
    // Hiện tại vẫn fallback về local cho đến khi API được tích hợp hoàn toàn
    await _refreshFromLocal();
  }

  /// Đồng bộ giỏ hàng từ Guest Mode lên Server sau khi Login thành công.
  Future<void> mergeLocalCartToServer() async {
    if (!UserManager().isLogin) return;

    final localItems = await _dbService.getCartItems();
    if (localItems.isEmpty) {
      await refreshFromServer();
      return;
    }

    final tradeRepo = locator<TradeRepository>();
    
    // Duyệt và đẩy từng item lên server
    for (var item in localItems) {
      if (item.skuId > 0) {
        await tradeRepo.addToCart(skuId: item.skuId, count: item.quantity);
      }
    }

    // Dọn dẹp local và reload dữ liệu chuẩn từ server
    await clearCart();
    await refreshFromServer();
  }
}

// --- EXTENSION: INTERNAL HELPERS (Private) ---

extension _CartServiceInternal on CartService {
  /// Cập nhật danh sách từ Isar vào bộ nhớ.
  Future<void> _refreshFromLocal() async {
    try {
      _items = await _dbService.getCartItems();
      _notifyUI();
    } catch (e) {
      eLog("Error refreshing cart from Isar: $e");
    }
  }

  /// Thông báo cho UI về sự thay đổi dữ liệu.
  void _notifyUI() {
    _cartController.add(List.unmodifiable(_items));
  }

  /// Cập nhật danh sách trong bộ nhớ (Memory).
  void _updateMemory(int skuId, int quantity, Product? product, List<SelectedOption>? options) {
    final index = _items.indexWhere((item) => item.skuId == skuId);
    
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
    } else if (quantity > 0 && product != null) {
      // Tính toán giá cuối cùng dựa trên các option đã chọn
      double price = product.price / 100.0;
      options?.forEach((o) => price += o.extraPrice);

      final newItem = TblCartItem()
        ..skuId = skuId
        ..spuId = product.id
        ..cartItemId = 0 
        ..name = product.name
        ..image = product.picUrl
        ..finalPrice = price
        ..quantity = quantity
        ..selectedOptions = options
        ..addedAt = DateTime.now();
      
      _items.add(newItem);
    }
  }

  /// Thực hiện ghi/xóa dữ liệu trực tiếp trong Isar.
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

  /// Tạo bản sao sâu (Deep copy) cho Cart Item.
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
}

// --- HELPER EXTENSION: SELECTED OPTIONS ---

extension SelectedOptionListExtension on List<SelectedOption>? {
  /// So sánh hai danh sách Option để xác định tính duy nhất của item.
  bool isSameAs(List<SelectedOption>? other) {
    if (this == null && other == null) return true;
    if (this == null || other == null) return false;
    if (this!.length != other.length) return false;

    for (var o1 in this!) {
      final found = other.any((o2) => o2.optionServerId == o1.optionServerId && o2.groupName == o1.groupName);
      if (!found) return false;
    }
    return true;
  }
}
