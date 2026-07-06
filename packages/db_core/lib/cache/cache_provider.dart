/*
 * DbCacheProvider: Interface định nghĩa các phương thức quản lý cache trong ứng dụng.
 * 
 * Chức năng:
 * - Cung cấp cơ chế lưu trữ (set) và truy xuất (get) dữ liệu cache linh hoạt.
 * - Hỗ trợ tự động giải mã JSON (fromJson) khi lấy dữ liệu Object/List.
 * - Quản lý vòng đời cache thông qua thời gian hết hạn (TTL/Expiry).
 * - Cho phép xóa cache theo khóa đơn lẻ (delete) hoặc theo nhóm (clearGroup).
 * - Cung cấp hàm dọn dẹp hệ thống (vacuum) để loại bỏ các dữ liệu đã hết hạn.
 * 
 * Cách sử dụng:
 * 1. Lấy dữ liệu:
 *    final products = await cache.get<List<Product>>('key', fromJson: (json) => ...);
 * 
 * 2. Lưu dữ liệu:
 *    await cache.set('key', data, ttl: Duration(minutes: 30), group: 'products');
 * 
 * 3. Xóa cache theo nhóm:
 *    await cache.clearGroup('products');
 */

import 'dart:async';

abstract class DbCacheProvider {
  /// Lấy dữ liệu và tự động chuyển đổi sang kiểu T
  /// [fromJson] là callback để parse dữ liệu từ JSON (nếu là Object/List)
  Future<T?> get<T>(String key, {T Function(dynamic json)? fromJson});

  /// Lấy dữ liệu kèm theo Metadata (Data + Hash)
  Future<(T? data, String? hash)?> getWithMetadata<T>(String key, {T Function(dynamic json)? fromJson});

  /// Lưu dữ liệu linh hoạt với Duration (TTL) hoặc DateTime cụ thể
  Future<void> set(
    String key,
    dynamic data, {
    String? hash,
    Duration? ttl,
    DateTime? expiry,
    String? group,
  });

  /// Xóa 1 key cụ thể
  Future<void> delete(String key);

  /// Xóa toàn bộ cache thuộc 1 group
  Future<void> clearGroup(String group);

  /// Dọn dẹp tất cả
  Future<void> clearAll();

  /// Dọn dẹp tất cả các bản ghi đã hết hạn (Maintenance)
  Future<void> vacuum();
}
