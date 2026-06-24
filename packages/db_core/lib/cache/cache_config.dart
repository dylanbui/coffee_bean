/*
 * DbCacheConfig: Cấu hình cho việc lưu trữ và quản lý cache.
 * 
 * Chức năng:
 * - Định nghĩa khóa (key) định danh duy nhất cho dữ liệu cache.
 * - Phân nhóm (group) để quản lý việc xóa cache hàng loạt (invalidate).
 * - Cấu hình thời gian sống (duration) của dữ liệu.
 * - Kiểm soát việc ép buộc làm mới dữ liệu (forceRefresh).
 * - Chỉ định danh sách các nhóm cần xóa sau khi tác vụ thành công (invalidateGroups).
 * 
 * Cách sử dụng:
 * final config = DbCacheConfig(
 *   key: 'user_profile_123',
 *   group: 'user_info',
 *   duration: Duration(hours: 1),
 *   forceRefresh: false,
 *   invalidateGroups: ['shopping_cart', 'orders'],
 * );
 */

class DbCacheConfig {
  final String key; // Key cụ thể cho request (vd: 'products_store_10')
  final String group; // Nhóm để invalidate (vd: 'shopping')
  final Duration duration;
  final bool forceRefresh;
  final List<String>? invalidateGroups;

  const DbCacheConfig({
    required this.key,
    this.group = 'default_cache_group',
    this.duration = const Duration(minutes: 10),
    this.forceRefresh = false,
    this.invalidateGroups,
  });
}
