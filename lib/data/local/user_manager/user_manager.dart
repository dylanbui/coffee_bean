import 'dart:convert';
import 'package:coffee_bean/data/local/user_manager/user_permission_mixin.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager_events.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/foundation.dart';
import 'package:coffee_bean/data/network/token_interceptor.dart';

class UserManager extends ChangeNotifier
    with UserPermissionMixin
    implements AuthTokenProvider {
  // 1. Singleton Pattern
  UserManager._internal();
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  // Keys lưu trữ cố định dưới Storage
  static const String _sessionKey = "SESSION_USER";
  static const String _infoKey = "INFO_USER";

  // 2. Dữ liệu lưu trên RAM (In-Memory Cache)
  UserSession? _currentUser;
  UserInfo? _userInfo;

  UserSession? get currentUser => _currentUser;
  UserInfo? get userInfo => _userInfo;

  bool get isLogin => _currentUser != null && _currentUser!.isLogin;

  /// Gọi duy nhất 1 lần lúc khởi chạy App (trong hàm main.dart)
  Future<void> init() async {
    final sessionData = await BaseSecureStorage().read(_sessionKey);
    final infoData = await BaseSecureStorage().read(_infoKey);

    // Goi cac init trong cac class mixin
    await Future.wait([
      initPermissions(),
    ]);

    if (sessionData != null) {
      try {
        _currentUser = UserSession.fromJson(jsonDecode(sessionData));
      } catch (_) {
        _currentUser = UserSession.empty();
      }
    } else {
      _currentUser = UserSession.empty();
    }

    if (infoData != null) {
      try {
        _userInfo = UserInfo.fromJson(jsonDecode(infoData));
      } catch (_) {
        _userInfo = null;
      }
    }

    notifyListeners();
  }

  /// Lưu thông tin phiên đăng nhập mới
  Future<void> saveSession(UserSession session) async {
    _currentUser = session;
    await BaseSecureStorage().write(_sessionKey, jsonEncode(session.toJson()));
    notifyListeners();
  }

  /// Lưu thông tin cá nhân người dùng
  Future<void> saveUserInfo(UserInfo info) async {
    _userInfo = info;
    await BaseSecureStorage().write(_infoKey, jsonEncode(info.toJson()));
    // notifyListeners để hỗ trợ các widget đang dùng Provider/Consumer
    notifyListeners();
    // event toàn cục để các Interactor/Cubit có thể nhận biết
    locator<DbEventBus>().fire(UserInfoUpdatedEvent(info));
  }

  Future<void> doLogoutAndClearAll() async {
    _currentUser = UserSession.empty();
    _userInfo = null;

    // Xóa sạch dữ liệu dưới ổ cứng
    await Future.wait([
      BaseSecureStorage().delete(_sessionKey),
      BaseSecureStorage().delete(_infoKey),
      clearPermissionsFromStorage(),
    ]);

    notifyListeners();
  }

  // 3. HIỆN THỰC CÁC HÀM CỦA INTERFACE AUTH_TOKEN_PROVIDER

  @override
  Future<String?> getAccessToken() async {
    return _currentUser?.accessToken;
  }

  @override
  Future<String?> getRefreshToken() async {
    return _currentUser?.refreshToken;
  }

  @override
  Future<void> updateAccessToken(String newAccess) async {
    if (_currentUser != null && _currentUser!.id > 0) {
      _currentUser!.accessToken = newAccess;
      await BaseSecureStorage().write(_sessionKey, jsonEncode(_currentUser!.toJson()));
      notifyListeners();
    }
  }

  @override
  Future<void> clearAll() async {
    await doLogoutAndClearAll();
  }
}
