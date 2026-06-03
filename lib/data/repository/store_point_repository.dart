import 'dart:convert';
import 'package:coffee_bean/config/app_pref.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/utils/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class StorePointCategory {
  final int id;
  final String name;

  StorePointCategory({required this.id, required this.name});
}

class StorePointRepository {
  final DatabaseService _dbService = locator<DatabaseService>();
  final AppPrefs _prefs = AppPrefs();

  static const String _itemSyncKey = "store_point_item";
  static const int _cacheDuration = 24 * 60 * 60 * 1000; // 1 day in ms

  List<StorePointCategory> getCategories() {
    return [
      StorePointCategory(id: 1, name: "Tất cả"),
      StorePointCategory(id: 2, name: "Mã ưu đãi"),
      StorePointCategory(id: 3, name: "Voucher đặt chỗ"),
      StorePointCategory(id: 4, name: "Khóa học"),
      StorePointCategory(id: 5, name: "Sự kiện"),
    ];
  }

  bool _isExpired(String key) {
    final lastSync = _prefs.getLastSyncTime(key);
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - lastSync) > _cacheDuration;
  }

  Future<void> _syncStorePoints() async {
    try {
      final String response = await rootBundle.loadString('assets/json/sample_store_point_item.json');
      final data = await json.decode(response);
      if (data['store_points'] != null) {
        final List<dynamic> jsonList = data['store_points'];
        final items = jsonList.map((json) {
          final tblItem = TblStorePoint()
            ..serverId = json['id']
            ..name = json['name'] ?? ''
            ..searchName = Utils.toNoSign(json['name'] ?? '')
            ..points = (json['points'] ?? 0).toDouble()
            ..description = json['description']
            ..catIds = (json['cat_ids'] as List<dynamic>?)?.map((e) => e as int).toList()
            ..isActive = json['is_active'] ?? true;
          
          if (json['image'] != null) {
            tblItem.images = [TblImage()..url = json['image']..isPrimary = true];
          }
          return tblItem;
        }).toList();

        await _dbService.isar.writeTxn(() async {
          await _dbService.isar.tblStorePoints.clear();
          await _dbService.isar.tblStorePoints.putAll(items);
        });
        _prefs.setLastSyncTime(_itemSyncKey, DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint("Error syncing store points: $e");
    }
  }

  Future<List<TblStorePoint>> getStorePoints({String? query, int? catId}) async {
    final count = await _dbService.isar.tblStorePoints.count();

    if (count == 0 || _isExpired(_itemSyncKey)) {
      await _syncStorePoints();
    }

    // Gia lap cho cham lai
    await Utils.delay(second: 1);

    var queryBuilder = _dbService.isar.tblStorePoints.filter().isActiveEqualTo(true);

    if (query != null && query.isNotEmpty) {
      final search = Utils.toNoSign(query);
      queryBuilder = queryBuilder.searchNameContains(search, caseSensitive: false);
    }

    if (catId != null && catId != 1) { // 1 is "All"
      queryBuilder = queryBuilder.catIdsElementEqualTo(catId);
    }

    return queryBuilder.findAll();
  }
}
