import 'dart:convert';
import 'package:coffee_bean/config/app_pref.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/utils/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ReservationRepository {
  final DatabaseService _dbService = locator<DatabaseService>();
  final AppPrefs _prefs = AppPrefs();

  static const String _catSyncKey = "reservation_category";
  static const String _itemSyncKey = "reservation_item";
  static const int _cacheDuration = 24 * 60 * 60 * 1000; // 1 day in ms

  bool _isExpired(String key) {
    final lastSync = _prefs.getLastSyncTime(key);
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - lastSync) > _cacheDuration;
  }

  Future<void> _syncCategories() async {
    try {
      final String response = await rootBundle.loadString('assets/json/sample_reservation_cat.json');
      final data = await json.decode(response);
      if (data['categories'] != null) {
        final List<dynamic> catJson = data['categories'];
        final categories = catJson.map((json) {
          return TblCategory()
            ..serverId = json['id']
            ..name = json['name'] ?? ''
            ..type = json['type'] ?? 'RESERVATION'
            ..sortOrder = json['sort_order'] ?? 0
            ..isActive = json['is_active'] ?? true;
        }).toList();

        await _dbService.isar.writeTxn(() async {
          await _dbService.isar.tblCategorys.filter().typeEqualTo("RESERVATION").deleteAll();
          await _dbService.isar.tblCategorys.putAll(categories);
        });
        _prefs.setLastSyncTime(_catSyncKey, DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint("Error syncing reservation categories: $e");
    }
  }

  Future<void> _syncReservations() async {
    try {
      final String response = await rootBundle.loadString('assets/json/sample_reservation_item.json');
      final data = await json.decode(response);
      if (data['reservations'] != null) {
        await _dbService.syncReservationData(data['reservations']);
        _prefs.setLastSyncTime(_itemSyncKey, DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint("Error syncing reservations: $e");
    }
  }

  Future<List<TblCategory>> getCategories() async {
    final existing = await _dbService.isar.tblCategorys
        .filter()
        .typeEqualTo("RESERVATION")
        .findAll();

    if (existing.isEmpty || _isExpired(_catSyncKey)) {
      await _syncCategories();
    }

    // Gia lap cho cham lai
    Utils.delay(second: 2);

    return _dbService.isar.tblCategorys
        .filter()
        .typeEqualTo("RESERVATION")
        .sortBySortOrder()
        .findAll();
  }

  Future<List<TblReservation>> getReservations({String? query, int? catId}) async {
    final existing = await _dbService.getAllReservations();

    if (existing.isEmpty || _isExpired(_itemSyncKey)) {
      await _syncReservations();
    }

    // Gia lap cho cham lai
    Utils.delay(second: 2);

    return _dbService.searchReservations(query: query, catId: catId);
  }
}
