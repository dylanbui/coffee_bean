import 'dart:convert';
import 'package:coffee_bean/config/app_pref.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/utils/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CourseRepository {
  final DatabaseService _dbService = locator<DatabaseService>();
  final AppPrefs _prefs = AppPrefs();

  static const String _catSyncKey = "course_category_sync";
  static const String _itemSyncKey = "course_item_sync";
  static const int _cacheDuration = 0;//24 * 60 * 60 * 1000; // 1 day in ms

  bool _isExpired(String key) {
    final lastSync = _prefs.getLastSyncTime(key);
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - lastSync) > _cacheDuration;
  }

  Future<void> _syncCategories() async {
    try {
      final String response = await rootBundle.loadString('assets/json/sample_course_cat.json');
      final data = await json.decode(response);
      if (data['categories'] != null) {
        final List<dynamic> catJson = data['categories'];
        final categories = catJson.map((json) {
          final name = json['name'] ?? '';
          return TblCategory()
            ..serverId = json['server_id'] ?? json['id']
            ..name = name
            ..searchName = Utils.toNoSign(name)
            ..type = json['type'] ?? 'COURSE'
            ..sortOrder = json['sort_order'] ?? 0
            ..isActive = json['is_active'] ?? true;
        }).toList();

        await _dbService.isar.writeTxn(() async {
          await _dbService.isar.tblCategorys.filter().typeEqualTo("COURSE").deleteAll();
          await _dbService.isar.tblCategorys.putAll(categories);
        });
        _prefs.setLastSyncTime(_catSyncKey, DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint("Error syncing course categories: $e");
    }
  }

  Future<void> _syncCourses() async {
    try {
      final String response = await rootBundle.loadString('assets/json/sample_course_item.json');
      final data = await json.decode(response);
      if (data['courses'] != null) {
        await _dbService.syncCourseData(data['courses']);
        _prefs.setLastSyncTime(_itemSyncKey, DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint("Error syncing courses: $e");
    }
  }

  Future<List<TblCategory>> getCategories() async {
    final existing = await _dbService.isar.tblCategorys
        .filter()
        .typeEqualTo("COURSE")
        .findAll();

    if (existing.isEmpty || _isExpired(_catSyncKey)) {
      await _syncCategories();
    }

    // Gia lap cho cham lai
    await Utils.delay(second: 1);

    return _dbService.isar.tblCategorys
        .filter()
        .typeEqualTo("COURSE")
        .sortBySortOrder()
        .findAll();
  }

  Future<List<TblCourse>> getCourses({String? query, int? catId}) async {
    final existing = await _dbService.getAllCourses();

    if (existing.isEmpty || _isExpired(_itemSyncKey)) {
      await _syncCourses();
    }

    // Gia lap cho cham lai
    await Utils.delay(second: 1);

    return _dbService.searchCourses(query: query, catId: catId);
  }
}
