
// Base abstraction cho mọi option item
abstract class DbOptionItem {
  String get key;    // unique string key
  String get title;  // tên hiển thị
  bool get isDefault;   // có cho phép chọn không
  bool get active;   // có cho phép chọn không
  dynamic get icon;  // icon asset hoặc widget
}

// Default implementation, user for simple Modal
class DbDefaultOptionItem extends DbOptionItem {
  @override
  final String key;
  @override
  final String title;
  @override
  final bool isDefault;
  @override
  final bool active;
  @override
  final dynamic icon;

  DbDefaultOptionItem({
    required dynamic key, // có thể là String hoặc int
    required this.title,
    this.isDefault = false,
    this.active = true,
    this.icon,
  }) : key = key is int ? key.toString() : key;
}

// Repository pattern để quản lý danh sách hardcode
class DbOptionRepository<T extends DbOptionItem> {
  final List<T> items;

  const DbOptionRepository(this.items);

  List<T> get all => items;

  // Đảm bảo lấy mục active nếu có thể
  T get defaultItem => items.firstWhere(
          (i) => i.active && i.isDefault,
      orElse: () => items.firstWhere((i) => i.active, orElse: () => items.first)
  );

  T? findByKey(String key) {
    for (final item in items) {
      if (item.key == key) return item;
    }
    return null;
  }
}