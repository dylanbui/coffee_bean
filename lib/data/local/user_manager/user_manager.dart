import 'dart:convert';
import 'package:db_core/utils/base_secure_storage.dart';
import 'package:coffee_bean/data/local/user_manager/user_permission_mixin.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:flutter/foundation.dart';
import 'package:coffee_bean/data/network/token_interceptor.dart';

/*
// Sử dụng Selector trong thư viện Provider, để lắng nghe các phần thay đổi, tránh lắng nghe tất cả
Selector<UserManager, List<String>>(
  selector: (context, userManager) => userManager.permissions,
  builder: (context, permissions, child) {
    final hasDelete = permissions.contains("DELETE_POST");
    return hasDelete ? const DeleteButton() : const SizedBox.shrink();
  },
);
* */

/*
 * CẤU TRÚC "KÉT SẮT" (VAULT) VỚI ISAR (Gợi ý cho tương lai):
 * 
 * Ý tưởng: Tạo một bảng 'Vault' trong Isar để lưu trữ các dữ liệu nghiệp vụ nhạy cảm 
 * hoặc dữ liệu mở rộng (points, friends, settings...) dưới dạng JSON mã hóa.
 * 
 * Mixin UserVaultMixin {
 *    Future<void> saveToVault(String key, dynamic data) async {
 *       // 1. Lấy Encryption Key từ SecureStorage
 *       // 2. Mã hóa 'data' (JSON) bằng Key đó
 *       // 3. Lưu vào Isar với unique_key = key
 *    }
 *    
 *    Future<dynamic> getFromVault(String key) async {
 *       // 1. Tìm bản ghi trong Isar theo key
 *       // 2. Giải mã và parse JSON
 *    }
 * }
 * 
 * Cách này giúp bảo mật dữ liệu User tuyệt đối, tránh Migration lỗi khi startup 
 * và giữ cho UserManager luôn gọn nhẹ.
 */

class UserManager extends ChangeNotifier
    with UserPermissionMixin
    implements AuthTokenProvider {
  // 1. Singleton Pattern
  UserManager._internal();
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  // Key lưu trữ cố định dưới Storage
  static const String _sessionKey = "SESSION_USER";

  // 2. Biến dữ liệu lưu trên RAM (In-Memory Cache) - Giải quyết triệt để nghẽn I/O
  UserSession? _currentUser;
  UserSession? get currentUser => _currentUser;

  bool get isLogin => _currentUser != null && _currentUser!.isLogin;

  /// Gọi duy nhất 1 lần lúc khởi chạy App (trong hàm main.dart)
  Future<void> init() async {
    final data = await BaseSecureStorage().read(_sessionKey);

    // Goi cac init trong cac class mixin
    await Future.wait([
      initPermissions(), // Hàm tự lo của Permission Mixin
      // initFriends(),       // Hàm tự lo của Friend Mixin
    ]);

    if (data != null) {
      try {
        _currentUser = UserSession.fromJson(jsonDecode(data));
      } catch (_) {
        _currentUser = UserSession.empty();
      }
    } else {
      _currentUser = UserSession.empty();
    }
    notifyListeners();
  }

  /// Lưu thông tin phiên đăng nhập mới (Sau khi đăng nhập thành công)
  Future<void> saveSession(UserSession session) async {
    _currentUser = session;
    await BaseSecureStorage().write(_sessionKey, jsonEncode(session.toJson()));
    notifyListeners(); // Báo cho UI thay đổi giao diện (Màn chính / Màn Login)
  }

  Future<void> doLogoutAndClearAll() async {
    _currentUser = UserSession.empty(); // Reset RAM về trạng thái trống

    // Ra lệnh cho các Mixin tự đi mà dọn dẹp ổ cứng nội bộ của chúng
    await Future.wait([
      BaseSecureStorage().deleteAll(), // Xóa token bảo mật, Xóa sạch dữ liệu nhạy cảm dưới ổ cứng
      clearPermissionsFromStorage(),    // Tự xóa SharedPrefs quyền
      // clearFriendsFromStorage(),        // Tự xóa Database bạn bè (Hive/Isar)
    ]);

    notifyListeners(); // Kích hoạt tín hiệu ép UI quay về màn Login
  }


  // 3. HIỆN THỰC CÁC HÀM CỦA INTERFACE AUTH_TOKEN_PROVIDER (Dành cho Interceptor)

  @override
  Future<String?> getAccessToken() async {
    // Đọc trực tiếp từ thuộc tính trên RAM, tốc độ nano-seconds, không tốn CPU/Pin
    return _currentUser?.accessToken;
  }

  @override
  Future<String?> getRefreshToken() async {
    return _currentUser?.refreshToken;
  }

  @override
  Future<void> updateAccessToken(String newAccess) async {
    if (_currentUser != null && _currentUser!.id > 0) {
      _currentUser!.accessToken = newAccess; // Cập nhật RAM ngay lập tức

      // Đồng bộ ngầm xuống ổ cứng (Background Task)
      await BaseSecureStorage().write(_sessionKey, jsonEncode(_currentUser!.toJson()));
      notifyListeners();
    }
  }

  @override
  Future<void> clearAll() async {
    doLogoutAndClearAll();
    // _currentUser = UserSession.empty(); // Reset RAM về trạng thái trống
    // await BaseSecureStorage().deleteAll(); // Xóa sạch dữ liệu nhạy cảm dưới ổ cứng
    // notifyListeners(); // Kích hoạt tín hiệu ép UI quay về màn Login
  }
}