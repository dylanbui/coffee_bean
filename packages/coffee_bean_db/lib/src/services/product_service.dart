import 'package:coffee_bean_db/src/app_database.dart';
import 'package:isar_community/isar.dart';
import 'package:coffee_bean_db/src/services/base_mixin.dart';

mixin ProductServiceMixin on BaseMixin {
  
  // --- NEW SYNC OPERATIONS (SPU & NEW CATEGORY) ---

  Future<void> syncAppCategories(List<dynamic> jsonList, int? storeId) async {
    final categories = jsonList.map((json) {
      final name = json['name'] ?? '';
      return TblCategory()
        ..serverId = json['id']
        ..parentId = json['parentId'] ?? 0
        ..name = name
        ..searchName = toNoSign(name)
        ..picUrl = json['picUrl']
        ..storeId = storeId
        ..isActive = true;
    }).toList();

    await isar.writeTxn(() async {
      // Nếu có storeId, chỉ xóa category của store đó
      if (storeId != null) {
        await isar.tblCategorys.filter().storeIdEqualTo(storeId).deleteAll();
      } else {
        await isar.tblCategorys.clear();
      }
      await isar.tblCategorys.putAll(categories);
    });
  }

  Future<void> syncAppProducts(List<dynamic> jsonList, int? storeId) async {
    final products = jsonList.map((json) {
      final name = json['name'] ?? '';
      return TblFood()
        ..serverId = json['id']
        ..storeId = storeId
        ..catId = json['categoryId'] ?? 0
        ..name = name
        ..searchName = toNoSign(name)
        ..introduction = json['introduction']
        ..picUrl = json['picUrl']
        ..sliderPicUrls = (json['sliderPicUrls'] as List?)?.map((e) => e.toString()).toList()
        ..specType = json['specType'] ?? false
        ..price = (json['price'] ?? 0).toDouble() // API returns raw units
        ..marketPrice = (json['marketPrice'] ?? 0).toDouble()
        ..stock = json['stock'] ?? 0
        ..salesCount = json['salesCount'] ?? 0
        ..deliveryTypes = (json['deliveryTypes'] as List?)?.map((e) => e as int).toList()
        ..isActive = true;
    }).toList();

    await isar.writeTxn(() async {
      if (storeId != null) {
        await isar.tblFoods.filter().storeIdEqualTo(storeId).deleteAll();
      } else {
        await isar.tblFoods.clear();
      }
      await isar.tblFoods.putAll(products);
    });
  }

  Future<List<TblFood>> getCachedProducts(int? storeId) async {
    if (storeId == null) return [];
    return await isar.tblFoods.filter().storeIdEqualTo(storeId).findAll();
  }

  // --- OLD SYNC OPERATIONS (KEEP FOR COMPATIBILITY IF NEEDED) ---

  Future<void> syncShoppingData({
    List<dynamic>? categoriesJson,
    List<dynamic>? productsJson,
    List<dynamic>? propertiesJson,
    List<dynamic>? storesJson,
    ProductType? targetType,
  }) async {
    await isar.writeTxn(() async {
      // 1. Xử lý Categories (nếu có)
      if (categoriesJson != null) {
        await syncCategories(categoriesJson, targetType);
      }

      // 2. Xử lý Stores (nếu có - Note: this logic is duplicated if we use StoreServiceMixin separately, but kept for compatibility)
      if (storesJson != null) {
        // We could call a method from StoreServiceMixin if we can, 
        // but mixins can't easily call each other without being mixed into the same class.
        // Since they will be mixed into DatabaseService, we can just define a private helper or assume it's there.
        // For now, let's keep it here or move it to a shared place.
        final stores = storesJson.map((json) {
          final name = json['name'] ?? '';
          final address = json['address'] ?? '';
          return TblStore()
            ..serverId = json['server_id'] ?? json['id']
            ..name = name
            ..address = address
            ..searchName = toNoSign("$name $address")
            ..phone = json['phone']
            ..latitude = (json['latitude'] ?? 0.0).toDouble()
            ..longitude = (json['longitude'] ?? 0.0).toDouble()
            ..openingTime = json['opening_time']
            ..closingTime = json['closing_time']
            ..images = mapImages(json)
            ..isActive = json['is_active'] ?? true;
        }).toList();
        await isar.tblStores.clear();
        await isar.tblStores.putAll(stores);
      }

      // 3. Xử lý Products & Properties (nếu có Products)
      if (productsJson != null) {
        final propertyMap = assembleProperties(propertiesJson ?? []);

        await performProductSync<TblFood>(
          isar.tblFoods,
          productsJson,
          ProductType.food,
          targetType,
          propertyMap,
          mapToFood,
        );

        await performProductSync<TblCourse>(
          isar.tblCourses,
          productsJson,
          ProductType.course,
          targetType,
          propertyMap,
          mapToCourse,
        );
      }
    });
  }

  Future<void> performProductSync<T>(
    IsarCollection<T> collection,
    List<dynamic> jsonList,
    ProductType tableType,
    ProductType? targetType,
    Map<int, List<TblProductProperty>> propertyMap,
    T Function(dynamic json, List<TblProductProperty>? props) mapper,
  ) async {
    if (targetType != null && targetType != tableType) return;
    final filteredJson = jsonList.where((json) => (json['type'] ?? 'FOOD') == tableType.name);
    final items = filteredJson.map((json) => mapper(json, propertyMap[json['id']])).toList();
    await collection.clear();
    if (items.isNotEmpty) {
      await collection.putAll(items);
    }
  }

  Future<void> syncCategories(List<dynamic> jsonList, ProductType? targetType) async {
    final categories = jsonList.map((json) {
      final name = json['name'] ?? '';
      return TblCategory()
        ..serverId = json['server_id'] ?? json['id']
        ..name = name
        ..searchName = toNoSign(name)
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

  // --- INDIVIDUAL PRODUCT HELPERS ---

  TblFood mapToFood(dynamic json, List<TblProductProperty>? props) {
    final name = json['name'] ?? '';
    return TblFood()
      ..serverId = json['server_id'] ?? json['id']
      ..catId = json['category_id']
      ..name = name
      ..searchName = toNoSign(name)
      ..sku = json['sku']
      ..price = (json['price'] ?? 0).toDouble()
      ..images = mapImages(json)
      ..description = json['description']
      ..isActive = json['is_active'] ?? true
      ..properties = props;
  }

  TblCourse mapToCourse(dynamic json, List<TblProductProperty>? props) {
    final name = json['name'] ?? '';
    return TblCourse()
      ..serverId = json['server_id'] ?? json['id']
      ..catIds = (json['category_ids'] as List?)?.map((e) => e as int).toList()
      ..name = name
      ..searchName = toNoSign(name)
      ..sku = json['sku']
      ..price = (json['price'] ?? 0).toDouble()
      ..images = mapImages(json)
      ..description = json['description']
      ..isActive = json['is_active'] ?? true
      ..instructor = json['instructor']
      ..videoUrl = json['video_url']
      ..properties = props;
  }

  TblActivity mapToActivity(dynamic json, List<TblProductProperty>? props) {
    final name = json['name'] ?? '';
    return TblActivity()
      ..serverId = json['server_id'] ?? json['id']
      ..catIds = (json['category_ids'] as List?)?.map((e) => e as int).toList()
      ..name = name
      ..searchName = toNoSign(name)
      ..sku = json['sku']
      ..price = (json['price'] ?? 0).toDouble()
      ..images = mapImages(json)
      ..description = json['description']
      ..isActive = json['is_active'] ?? true
      ..properties = props;
  }
  
  // --- ADDITIONAL OPERATIONS ---

  Future<List<TblCourse>> getAllCourses() =>
      isar.tblCourses.filter().isActiveEqualTo(true).findAll();

  Future<List<TblCourse>> searchCourses({String? query, int? catId}) async {
    QueryBuilder<TblCourse, TblCourse, QAfterFilterCondition> queryBuilder =
    isar.tblCourses.filter().isActiveEqualTo(true);

    if (query != null && query.isNotEmpty) {
      final searchTerms = toNoSign(query);
      queryBuilder = queryBuilder.searchNameContains(searchTerms, caseSensitive: false);
    }

    if (catId != null) {
      queryBuilder = queryBuilder.catIdsElementEqualTo(catId);
    }

    return queryBuilder.findAll();
  }

  Future<void> syncCourseData(List<dynamic> courseJson) async {
    await isar.writeTxn(() async {
      final propertyMap = assembleProperties([]);
      final items = courseJson.map((json) => mapToCourse(json, propertyMap[json['id']])).toList();
      await isar.tblCourses.clear();
      await isar.tblCourses.putAll(items);
    });
  }

  Future<List<TblActivity>> getAllActivities() =>
      isar.tblActivitys.filter().isActiveEqualTo(true).findAll();

  Future<List<TblActivity>> searchActivities({String? query, int? catId}) async {
    QueryBuilder<TblActivity, TblActivity, QAfterFilterCondition> queryBuilder =
    isar.tblActivitys.filter().isActiveEqualTo(true);

    if (query != null && query.isNotEmpty) {
      final searchTerms = toNoSign(query);
      queryBuilder = queryBuilder.searchNameContains(searchTerms, caseSensitive: false);
    }

    if (catId != null) {
      queryBuilder = queryBuilder.catIdsElementEqualTo(catId);
    }

    return queryBuilder.findAll();
  }

  Future<void> syncActivityData(List<dynamic> activityJson) async {
    await isar.writeTxn(() async {
      final propertyMap = assembleProperties([]);
      final items = activityJson.map((json) => mapToActivity(json, propertyMap[json['id']])).toList();
      await isar.tblActivitys.clear();
      await isar.tblActivitys.putAll(items);
    });
  }
}
