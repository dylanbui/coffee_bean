import 'dart:async';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/repository/trade_repository.dart';
import 'package:db_core/network/network_utils.dart';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/model/response/product/product.dart';
import 'package:db_core/utils/toast.dart';

/// Service quản lý giỏ hàng toàn app (Cart Management Service).
///
/// Vận hành theo kiến trúc **Integrated Local-First** với cơ chế **Optimistic UI**:
///
/// 1. **Single Source of Truth (SSOT)**:
///    - Dữ liệu trong bộ nhớ (_items) và Isar DB luôn được ưu tiên cập nhật đầu tiên.
///    - UI lắng nghe qua `cartStream` để phản hồi tức thì (Instant UI) mà không chờ API.
///
/// 2. **Cơ chế Đồng bộ (Member Synchronization)**:
///    - Với Member: Sau khi cập nhật Local, Service tự động thực hiện các lệnh gọi API ngầm.
///    - Nếu API trả về thành công (vd: `cartItemId` mới), Local DB sẽ được cập nhật bổ sung.
///    - Nếu API thất bại, Service thực hiện **Rollback** toàn bộ trạng thái (Memory & Isar)
///      về phiên bản trước đó và thông báo lỗi.
///
/// 3. **Chế độ Guest & Chuyển vùng (Guest to Member)**:
///    - Guest Mode: Hoạt động thuần túy trên Isar DB.
///    - Khi Login thành công: Tự động kích hoạt `mergeLocalCartToServer` để đẩy dữ liệu tạm
///      lên Server và đồng bộ lại giỏ hàng chính thức.
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
    
    // --- 1. PERSISTENCE LOCAL (LUÔN THỰC HIỆN) ---
    // Cập nhật bộ nhớ và Isar ngay lập tức để không mất dữ liệu khi restart
    final existingItem = _items.where((i) => i.skuId == skuId).firstOrNull;
    final int? currentCartItemId = existingItem?.cartItemId;

    _updateMemory(skuId, quantity, product, options);
    _notifyUI();
    
    // Ghi xuống DB để lưu trữ bền vững
    await _upsertLocal(skuId, quantity, product, options);

    if (!userManager.isLogin) return;

    // --- 2. LOGIC CHO MEMBER (SYNCHRONIZE SERVER) ---
    
    // Sao lưu trạng thái để rollback nếu API lỗi
    _rollbackItems = List.from(_items.map((e) => _cloneCartItem(e)));

    final tradeRepo = locator<TradeRepository>();
    DbResult<dynamic> result;

    if (quantity <= 0) {
      if (currentCartItemId != null && currentCartItemId > 0) {
        result = await tradeRepo.deleteCartItems([currentCartItemId]);
      } else {
        return;
      }
    } else {
      if (currentCartItemId != null && currentCartItemId > 0) {
        result = await tradeRepo.updateCartItemCount(id: currentCartItemId, count: quantity);
      } else {
        result = await tradeRepo.addToCart(skuId: skuId, count: quantity);
        if (result case DbSuccess(data: final int newId)) {
          final item = _items.where((i) => i.skuId == skuId).firstOrNull;
          if (item != null) {
            item.cartItemId = newId;
            // Cập nhật lại cartItemId vào local DB
            await _dbService.isar.writeTxn(() async {
              final dbItem = await _dbService.isar.tblCartItems.filter().skuIdEqualTo(skuId).findFirst();
              if (dbItem != null) {
                dbItem.cartItemId = newId;
                await _dbService.isar.tblCartItems.put(dbItem);
              }
            });
          }
        }
      }
    }

    if (result case DbFailure(:final error)) {
      _items = _rollbackItems ?? [];
      _notifyUI();
      // Rollback cả local DB
      await _refreshFromLocal();
      DbToast.show(error.message);
    } else {
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
    
    final tradeRepo = locator<TradeRepository>();
    final result = await tradeRepo.getCartList();

    if (result case DbSuccess(data: final cartData)) {
      // 1. Chuyển đổi dữ liệu từ server sang TblCartItem
      final List<TblCartItem> serverItems = cartData.validList.map((itemRes) {
        final List<SelectedOption> opts = itemRes.sku?.properties?.map((p) => SelectedOption()
          ..optionServerId = p.valueId
          ..groupName = p.propertyName
          ..optionName = p.valueName
          ..extraPrice = 0.0
        ).toList() ?? [];

        return TblCartItem()
          ..cartItemId = itemRes.id
          ..spuId = itemRes.spu?.id ?? 0
          ..skuId = itemRes.sku?.id ?? 0
          ..name = itemRes.spu?.name ?? ""
          ..image = itemRes.sku?.picUrl ?? itemRes.spu?.picUrl
          ..finalPrice = (itemRes.sku?.price ?? 0) / 100.0
          ..quantity = itemRes.count
          ..selectedOptions = opts
          ..addedAt = DateTime.now();
      }).toList();

      // 2. Cập nhật đồng bộ vào Isar (Xóa cũ, ghi mới)
      await _dbService.isar.writeTxn(() async {
        await _dbService.isar.tblCartItems.clear();
        await _dbService.isar.tblCartItems.putAll(serverItems);
      });

      // 3. Cập nhật vào bộ nhớ và thông báo UI
      _items = serverItems;
      _notifyUI();
    } else {
      // Nếu API lỗi, fallback về local
      await _refreshFromLocal();
    }
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
