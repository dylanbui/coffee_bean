import 'dart:convert';
import 'package:db_core/cache/cache_provider.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

class AppCache implements DbCacheProvider {
  final Isar isar;

  AppCache(this.isar);

  @override
  Future<T?> get<T>(String key, {T Function(dynamic json)? fromJson}) async {
    final record = await isar.tblCaches.filter().keyEqualTo(key).findFirst();

    if (record == null) return null;

    if (record.isExpired) {
      await delete(key);
      return null;
    }

    try {
      final dynamic jsonData = jsonDecode(record.content);
      if (fromJson != null) {
        return fromJson(jsonData);
      }
      return jsonData as T?;
    } catch (e) {
      // Logic handle error decode hoặc parse
      return null;
    }
  }

  @override
  Future<void> set(
    String key,
    dynamic data, {
    Duration? ttl,
    DateTime? expiry,
    String? group,
  }) async {
    final DateTime expiryDate = expiry ?? DateTime.now().toUtc().add(ttl ?? const Duration(minutes: 10));
    
    final content = jsonEncode(data);

    final record = TblCache()
      ..key = key
      ..content = content
      ..group = group
      ..expiry = expiryDate;

    await isar.writeTxn(() async {
      await isar.tblCaches.put(record);
    });
  }

  @override
  Future<void> delete(String key) async {
    await isar.writeTxn(() async {
      await isar.tblCaches.filter().keyEqualTo(key).deleteAll();
    });
  }

  @override
  Future<void> clearGroup(String group) async {
    await isar.writeTxn(() async {
      await isar.tblCaches.filter().groupEqualTo(group).deleteAll();
    });
  }

  @override
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.tblCaches.clear();
    });
  }

  @override
  Future<void> vacuum() async {
    final now = DateTime.now().toUtc();
    await isar.writeTxn(() async {
      await isar.tblCaches.filter().expiryLessThan(now).deleteAll();
    });
  }
}
