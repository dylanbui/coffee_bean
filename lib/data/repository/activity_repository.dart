import 'dart:convert';
import 'package:coffee_bean/config/app_pref.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/utils/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ActivityRepository {
  final DatabaseService _dbService = locator<DatabaseService>();
  final AppPrefs _prefs = AppPrefs();

  static const String _catSyncKey = "activity_category_sync";
  static const String _itemSyncKey = "activity_item_sync";
  static const int _cacheDuration = 0; //24 * 60 * 60 * 1000; // 1 day in ms

  bool _isExpired(String key) {
    final lastSync = _prefs.getLastSyncTime(key);
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - lastSync) > _cacheDuration;
  }

  Future<void> _syncCategories() async {
    try {
      final String response = await rootBundle.loadString('assets/json/sample_activity_cat.json');
      final data = await json.decode(response);
      if (data['categories'] != null) {
        final List<dynamic> catJson = data['categories'];
        final categories = catJson.map((json) {
          final name = json['name'] ?? '';
          return TblCategory()
            ..serverId = json['server_id'] ?? json['id']
            ..name = name
            ..searchName = Utils.toNoSign(name)
            ..type = json['type'] ?? 'ACTIVITY'
            ..sortOrder = json['sort_order'] ?? 0
            ..isActive = json['is_active'] ?? true;
        }).toList();

        await _dbService.isar.writeTxn(() async {
          await _dbService.isar.tblCategorys.filter().typeEqualTo("ACTIVITY").deleteAll();
          await _dbService.isar.tblCategorys.putAll(categories);
        });
        _prefs.setLastSyncTime(_catSyncKey, DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint("Error syncing activity categories: $e");
    }
  }

  Future<void> _syncActivities() async {
    try {
      final String response = await rootBundle.loadString('assets/json/sample_activity_item.json');
      final data = await json.decode(response);
      if (data['activities'] != null) {
        await _dbService.syncActivityData(data['activities']);
        _prefs.setLastSyncTime(_itemSyncKey, DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint("Error syncing activities: $e");
    }
  }

  Future<List<TblCategory>> getCategories() async {
    final existing = await _dbService.isar.tblCategorys
        .filter()
        .typeEqualTo("ACTIVITY")
        .findAll();

    if (existing.isEmpty || _isExpired(_catSyncKey)) {
      await _syncCategories();
    }

    // Giả lập cho chậm lại
    //await Utils.delay(second: 1);

    return _dbService.isar.tblCategorys
        .filter()
        .typeEqualTo("ACTIVITY")
        .sortBySortOrder()
        .findAll();
  }

  Future<List<TblActivity>> getActivities({String? query, int? catId}) async {
    final existing = await _dbService.getAllActivities();

    if (existing.isEmpty || _isExpired(_itemSyncKey)) {
      await _syncActivities();
    }

    // Giả lập cho chậm lại
    // await Utils.delay(second: 1);

    return _dbService.searchActivities(query: query, catId: catId);
  }
}
