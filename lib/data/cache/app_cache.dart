import 'dart:convert';
import 'package:db_core/cache/cache_provider.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

/// Triển khai DbCacheProvider sử dụng Isar Database
class AppCache implements DbCacheProvider {
  final Isar isar;

  AppCache(this.isar);

  @override
  Future<T?> get<T>(String key, {T Function(dynamic json)? fromJson}) async {
    final record = await isar.tblCaches.filter().keyEqualTo(key).findFirst();

    if (record == null) return null;

    // CASE 3: Cache hết hạn -> Xóa và trả về null để Repository gọi Network mới
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
      return null;
    }
  }

  /// Lấy dữ liệu kèm theo Metadata (Data + Mã Hash)
  /// Phục vụ cho cơ chế Change Detection bằng MD5
  @override
  Future<(T? data, String? hash)?> getWithMetadata<T>(String key, {T Function(dynamic json)? fromJson}) async {
    final record = await isar.tblCaches.filter().keyEqualTo(key).findFirst();

    if (record == null) return null;

    // Kiểm tra vòng đời cache
    if (record.isExpired) {
      await delete(key);
      return null;
    }

    try {
      final dynamic jsonData = jsonDecode(record.content);
      final data = fromJson != null ? fromJson(jsonData) : jsonData as T?;
      // Trả về cả dữ liệu và mã hash đã lưu
      return (data, record.hash);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> set(
    String key,
    dynamic data, {
    String? hash,
    Duration? ttl,
    DateTime? expiry,
    String? group,
  }) async {
    // Luôn chuẩn hóa thời gian về UTC để đồng bộ giữa các thiết bị
    final DateTime expiryDate = expiry ?? DateTime.now().toUtc().add(ttl ?? const Duration(minutes: 10));
    
    final content = jsonEncode(data);

    final record = TblCache()
      ..key = key
      ..content = content
      ..hash = hash // Lưu MD5 Hash phục vụ Smart Cache
      ..updatedAt = DateTime.now().toUtc()
      ..group = group
      ..expiry = expiryDate;

    await isar.writeTxn(() async {
      // put() với @Index(unique: true, replace: true) sẽ tự động cập nhật nếu trùng key
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
