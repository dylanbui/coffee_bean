import 'package:db_core/utils/shared_preferences.dart';
import 'package:flutter/foundation.dart';

// Demo gắn them chuc nang vao UserManager, UserPermissionMixin co the chon luu tru trong Isar hay Hevi, SQLite
mixin UserPermissionMixin on ChangeNotifier {
  List<String> _permissions = [];
  List<String> get permissions => _permissions;

  bool hasPermission(String permission) => _permissions.contains(permission);

  /// Tự quản lý việc mở ổ cứng và nạp data lên RAM
  Future<void> initPermissions() async {
    // Sửa lỗi: Đảm bảo không bị null và cast về đúng kiểu List<String>
    final dynamic data = DbSharedPreferences().get("USER_PERMISSIONS");
    if (data != null && data is List) {
      _permissions = List<String>.from(data);
    } else {
      _permissions = [];
    }
  }

  Future<void> updatePermissions(List<String> newPermissions) async {
    _permissions = newPermissions;
    await DbSharedPreferences().set("USER_PERMISSIONS", newPermissions);
    notifyListeners();
  }

  Future<void> clearPermissionsFromStorage() async {
    _permissions.clear();
    await DbSharedPreferences().remove("USER_PERMISSIONS");
  }
}