import 'package:coffee_bean/data/database/app_database.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

enum ProductType {
  food,
  course,
  rental;

  String get name => toString().split('.').last.toUpperCase();
}

class DatabaseService {
  late Isar isar;

  // --- INITIALIZATION ---
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TblCategorySchema, TblFoodSchema, TblCourseSchema, TblCartItemSchema],
      directory: dir.path,
    );
  }

  // --- STORE OPERATIONS ---
  
  /// Xóa sạch dữ liệu khi đổi Store
  Future<void> clearAllDataForNewStore() async {
    await isar.writeTxn(() async {
      await isar.tblCategorys.clear();
      await isar.tblFoods.clear();
      await isar.tblCourses.clear();
      await isar.tblCartItems.clear();
    });
  }

  // --- GRANULAR SYNC OPERATIONS ---

  /// Sync dữ liệu linh hoạt. Có thể truyền lẻ Categories, Products hoặc Properties.
  /// Nếu truyền [targetType], việc xóa dữ liệu cũ sẽ chỉ giới hạn trong Type đó.
  Future<void> syncShoppingData({
    List<dynamic>? categoriesJson,
    List<dynamic>? productsJson,
    List<dynamic>? propertiesJson,
    ProductType? targetType,
  }) async {
    await isar.writeTxn(() async {
      // 1. Xử lý Categories (nếu có)
      if (categoriesJson != null) {
        await _syncCategories(categoriesJson, targetType);
      }

      // 2. Xử lý Products & Properties (nếu có Products)
      if (productsJson != null) {
        final propertyMap = _assembleProperties(propertiesJson ?? []);

        // Sử dụng Generic Helper để xử lý cho từng loại Table
        await _performProductSync<TblFood>(
          isar.tblFoods,
          productsJson,
          ProductType.food,
          targetType,
          propertyMap,
          _mapToFood,
        );

        await _performProductSync<TblCourse>(
          isar.tblCourses,
          productsJson,
          ProductType.course,
          targetType,
          propertyMap,
          _mapToCourse,
        );

        // Sau này thêm Rental hay Promo chỉ cần thêm 1 dòng ở đây
      }
    });
  }

  /// Hàm Helper Generic để xử lý Sync cho từng Collection Product
  Future<void> _performProductSync<T>(
    IsarCollection<T> collection,
    List<dynamic> jsonList,
    ProductType tableType,
    ProductType? targetType,
    Map<int, List<TblProductProperty>> propertyMap,
    T Function(dynamic json, List<TblProductProperty>? props) mapper,
  ) async {
    // Nếu đang yêu cầu sync 1 loại cụ thể (targetType) mà không phải loại này (tableType) thì bỏ qua
    if (targetType != null && targetType != tableType) return;

    // 1. Lọc dữ liệu từ JSON theo đúng loại của Table
    final filteredJson = jsonList.where((json) => (json['type'] ?? 'FOOD') == tableType.name);

    // 2. Map sang Object Isar
    final items = filteredJson.map((json) => mapper(json, propertyMap[json['id']])).toList();

    // 3. Thực hiện thay thế dữ liệu (Xóa cũ và ghi mới)
    // Nếu có targetType cụ thể hoặc đang sync all (targetType == null) thì mới clear bảng tương ứng
    await collection.clear();
    if (items.isNotEmpty) {
      await collection.putAll(items);
    }
  }

  Future<void> _syncCategories(List<dynamic> jsonList, ProductType? targetType) async {
    final categories = jsonList.map((json) {
      final name = json['name'] ?? '';
      return TblCategory()
        ..serverId = json['id']
        ..name = name
        ..searchName = Utils.toNoSign(name)
        ..type = json['type'] ?? 'FOOD'
        ..image = json['image']
        ..sortOrder = json['sort_order'] ?? 0
        ..isActive = json['is_active'] ?? true;
    }).toList();

    if (targetType != null) {
      // Chỉ xóa categories của type chỉ định
      await isar.tblCategorys.filter().typeEqualTo(targetType.name).deleteAll();
      // Chỉ add những category của type đó (nếu API trả về hỗn hợp)
      final filteredCategories = categories.where((c) => c.type == targetType.name).toList();
      await isar.tblCategorys.putAll(filteredCategories);
    } else {
      await isar.tblCategorys.clear();
      await isar.tblCategorys.putAll(categories);
    }
  }

  /// Xóa và Insert cho một loại Table cụ thể (Dùng khi chỉ muốn update Course hoặc Food)
  /// Hàm này bây giờ đơn giản là gọi lại syncShoppingData với targetType
  Future<void> syncTableByType({
    required ProductType type,
    required List<dynamic> productsJson,
    required List<dynamic> propertiesJson,
  }) async {
    await syncShoppingData(
      productsJson: productsJson,
      propertiesJson: propertiesJson,
      targetType: type,
    );
  }

  // --- QUERY & SEARCH ---

  /// Search tổng hợp trên tất cả các bảng
  Future<Map<ProductType, List<dynamic>>> searchAll(String query) async {
    final foodResults = await isar.tblFoods.filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .skuContains(query, caseSensitive: false)
        .findAll();

    final courseResults = await isar.tblCourses.filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .skuContains(query, caseSensitive: false)
        .findAll();

    return {
      ProductType.food: foodResults,
      ProductType.course: courseResults,
    };
  }

  Future<TblFood?> getFoodById(int serverId) => isar.tblFoods.filter().serverIdEqualTo(serverId).findFirst();

  Future<TblCourse?> getCourseById(int serverId) => isar.tblCourses.filter().serverIdEqualTo(serverId).findFirst();

  // --- CART OPERATIONS ---

  Future<List<TblCartItem>> getCartItems() => isar.tblCartItems.where().sortByAddedAtDesc().findAll();

  Future<void> updateCartItem(TblCartItem item) async {
    await isar.writeTxn(() => isar.tblCartItems.put(item));
  }

  Future<void> removeFromCart(int id) async {
    await isar.writeTxn(() => isar.tblCartItems.delete(id));
  }

  /// Xóa sản phẩm trong giỏ theo loại (Ví dụ: khi update Course thì xóa Course cũ trong giỏ)
  Future<void> clearCartByType(ProductType type) async {
    await isar.writeTxn(() async {
      await isar.tblCartItems.filter().typeEqualTo(type.name).deleteAll();
    });
  }

  Future<void> addToCart({
    required int serverId,
    required ProductType type,
    required String name,
    String? image,
    String? sku,
    required double price,
    required int quantity,
    List<SelectedOption>? options,
  }) async {
    final item = TblCartItem()
      ..serverId = serverId
      ..type = type.name
      ..name = name
      ..image = image
      ..sku = sku
      ..finalPrice = price
      ..quantity = quantity
      ..selectedOptions = options
      ..addedAt = DateTime.now();

    await isar.writeTxn(() => isar.tblCartItems.put(item));
  }

  // --- PRIVATE HELPERS (ASSEMBLY LOGIC) ---

  Map<int, List<TblProductProperty>> _assembleProperties(List<dynamic> json) {
    final map = <int, List<TblProductProperty>>{};
    for (var p in json) {
      final prop = TblProductProperty()
        ..serverId = p['id']
        ..groupName = p['group_name'] ?? ''
        ..isRequired = p['is_required'] ?? false
        ..options = (p['options'] as List? ?? []).map((o) => TblProductOption()
          ..serverId = o['id']
          ..name = o['name'] ?? ''
          ..extraPrice = (o['extra_price'] ?? 0).toDouble()
          ..percent = o['percent'] // Lấy % từ JSON nếu có
          ..isAvailable = o['is_available'] ?? true
          ..sku = o['sku']).toList();
      map.putIfAbsent(p['product_id'], () => []).add(prop);
    }
    return map;
  }

  TblFood _mapToFood(dynamic json, List<TblProductProperty>? props) {
    final name = json['name'] ?? '';
    return TblFood()
      ..serverId = json['id']
      ..catId = json['category_id']
      ..name = name
      ..searchName = Utils.toNoSign(name)
      ..sku = json['sku']
      ..price = (json['price'] ?? 0).toDouble()
      ..image = json['image']
      ..description = json['description']
      ..isActive = json['is_active'] ?? true
      ..properties = props;
  }

  TblCourse _mapToCourse(dynamic json, List<TblProductProperty>? props) {
    final name = json['name'] ?? '';
    return TblCourse()
      ..serverId = json['id']
      ..catId = json['category_id']
      ..name = name
      ..searchName = Utils.toNoSign(name)
      ..sku = json['sku']
      ..price = (json['price'] ?? 0).toDouble()
      ..image = json['image']
      ..description = json['description']
      ..isActive = json['is_active'] ?? true
      ..instructor = json['instructor']
      ..videoUrl = json['video_url']
      ..properties = props;
  }
}
