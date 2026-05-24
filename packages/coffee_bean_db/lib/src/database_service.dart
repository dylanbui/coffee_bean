import 'package:coffee_bean_db/src/app_database.dart';
import 'package:isar_community/isar.dart';
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
    isar = await Isar.open([
      TblCategorySchema,
      TblFoodSchema,
      TblCourseSchema,
      TblCartItemSchema,
      TblStoreSchema,
    ], directory: dir.path);
  }

  // --- STORE OPERATIONS ---

  /// Xóa sạch dữ liệu khi đổi Store
  Future<void> clearAllDataForNewStore() async {
    await isar.writeTxn(() async {
      await isar.tblCategorys.clear();
      await isar.tblFoods.clear();
      await isar.tblCourses.clear();
      await isar.tblCartItems.clear();
      await isar.tblStores.clear();
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
        ..searchName = _toNoSign(name)
        ..type = json['type'] ?? 'FOOD'
        ..image = json['image']
        ..sortOrder = json['sort_order'] ?? 0
        ..isActive = json['is_active'] ?? true;
    }).toList();

    if (targetType != null) {
      await isar.tblCategorys.filter().typeEqualTo(targetType.name).deleteAll();
      final filteredCategories = categories.where((c) => c.type == targetType.name).toList();
      await isar.tblCategorys.putAll(filteredCategories);
    } else {
      await isar.tblCategorys.clear();
      await isar.tblCategorys.putAll(categories);
    }
  }

  // --- QUERY & SEARCH ---

  Future<Map<ProductType, List<dynamic>>> searchAll(String query) async {
    final foodResults = await isar.tblFoods
        .filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .skuContains(query, caseSensitive: false)
        .findAll();

    final courseResults = await isar.tblCourses
        .filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .skuContains(query, caseSensitive: false)
        .findAll();

    return {ProductType.food: foodResults, ProductType.course: courseResults};
  }

  // --- STORE QUERIES ---

  Future<List<TblStore>> getAllStores() => isar.tblStores.filter().isActiveEqualTo(true).findAll();

  Future<List<TblStore>> searchStores(String query) async {
    final searchTerms = _toNoSign(query);
    return isar.tblStores
        .filter()
        .isActiveEqualTo(true)
        .and()
        .searchNameContains(searchTerms, caseSensitive: false)
        .findAll();
  }

  Future<void> syncStoreData(List<dynamic> storesJson) async {
    await isar.writeTxn(() async {
      final stores = storesJson.map((json) => _mapToStore(json)).toList();
      await isar.tblStores.clear();
      await isar.tblStores.putAll(stores);
    });
  }

  // --- CART OPERATIONS ---

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

  // --- PRIVATE HELPERS ---

  Map<int, List<TblProductProperty>> _assembleProperties(List<dynamic> json) {
    final map = <int, List<TblProductProperty>>{};
    for (var p in json) {
      final prop = TblProductProperty()
        ..serverId = p['id']
        ..groupName = p['group_name'] ?? ''
        ..isRequired = p['is_required'] ?? false
        ..options = (p['options'] as List? ?? [])
            .map(
              (o) => TblProductOption()
                ..serverId = o['id']
                ..name = o['name'] ?? ''
                ..extraPrice = (o['extra_price'] ?? 0).toDouble()
                ..percent = o['percent']
                ..isAvailable = o['is_available'] ?? true
                ..sku = o['sku'],
            )
            .toList();
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
      ..searchName = _toNoSign(name)
      ..sku = json['sku']
      ..price = (json['price'] ?? 0).toDouble()
      ..images = _mapImages(json)
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
      ..searchName = _toNoSign(name)
      ..sku = json['sku']
      ..price = (json['price'] ?? 0).toDouble()
      ..images = _mapImages(json)
      ..description = json['description']
      ..isActive = json['is_active'] ?? true
      ..instructor = json['instructor']
      ..videoUrl = json['video_url']
      ..properties = props;
  }

  TblStore _mapToStore(dynamic json) {
    final name = json['name'] ?? '';
    final address = json['address'] ?? '';
    return TblStore()
      ..serverId = json['id']
      ..name = name
      ..address = address
      ..searchName = _toNoSign("$name $address")
      ..phone = json['phone']
      ..latitude = (json['latitude'] ?? 0.0).toDouble()
      ..longitude = (json['longitude'] ?? 0.0).toDouble()
      ..openingTime = json['opening_time']
      ..closingTime = json['closing_time']
      ..images = _mapImages(json)
      ..isActive = json['is_active'] ?? true;
  }
  List<TblImage>? _mapImages(dynamic json) {
    if (json['images'] != null && json['images'] is List) {
      return (json['images'] as List)
          .map((img) => TblImage()
            ..url = img['url']
            ..isPrimary = img['is_primary'] ?? false)
          .toList();
    }
    // Fallback nếu server chỉ trả về 1 field image đơn lẻ
    if (json['image'] != null && json['image'] is String) {
      return [TblImage()..url = json['image']..isPrimary = true];
    }
    return null;
  }
}

String _toNoSign(String str) {
  if (str.isEmpty) return "";
  var result = str.toLowerCase();
  result = result.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
  result = result.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
  result = result.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
  result = result.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
  result = result.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
  result = result.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
  result = result.replaceAll(RegExp(r'[đ]'), 'd');
  return result;
}
