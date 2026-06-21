import 'dart:convert';
import 'package:coffee_bean/data/local/user_manager/user_permission_mixin.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager_events.dart';
import 'package:coffee_bean/data/model/response/trade/store_model.dart';
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
  static const String _storeKey = "SELECTED_STORE";

  // 2. Dữ liệu lưu trên RAM (In-Memory Cache)
  UserSession? _currentUser;
  UserInfo? _userInfo;
  StoreModel? _selectedStore;

  UserSession? get currentUser => _currentUser;
  UserInfo? get userInfo => _userInfo;
  StoreModel? get selectedStore => _selectedStore;

  bool get isLogin => _currentUser != null && _currentUser!.isLogin;

  /// Gọi duy nhất 1 lần lúc khởi chạy App (trong hàm main.dart)
  Future<void> init() async {
    final sessionData = await BaseSecureStorage().read(_sessionKey);
    final infoData = await BaseSecureStorage().read(_infoKey);
    final storeData = await BaseSecureStorage().read(_storeKey);

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

    if (storeData != null) {
      try {
        _selectedStore = StoreModel.fromJson(jsonDecode(storeData));
      } catch (_) {
        _selectedStore = null;
      }
    }

    notifyListeners();
  }

  // --- Daily Sign-In Local Management ---

  String _getSignInKey() => "LAST_SIGNIN_DATE_USER_${_userInfo?.id}";

  bool get hasSignedInToday {
    if (_userInfo == null) return false;
    final lastSignIn = DbSharedPreferences().get(_getSignInKey());
    if (lastSignIn == null) return false;

    try {
      final lastDate = DateTime.parse(lastSignIn.toString());
      final now = DateTime.now();
      return lastDate.year == now.year && lastDate.month == now.month && lastDate.day == now.day;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveLastSignInDate() async {
    if (_userInfo == null) return;
    await DbSharedPreferences().set(_getSignInKey(), DateTime.now().toIso8601String());
    notifyListeners();
  }

  // --- End Daily Sign-In ---

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

  /// Lưu thông tin cửa hàng đã chọn
  Future<void> saveSelectedStore(StoreModel store) async {
    _selectedStore = store;
    await BaseSecureStorage().write(_storeKey, jsonEncode(store.toJson()));
    notifyListeners();
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
  Future<void> updateAccessToken(String newAccess, {int? expiresTime}) async {
    if (_currentUser != null && _currentUser!.id > 0) {
      _currentUser!.accessToken = newAccess;
      if (expiresTime != null) {
        _currentUser!.expiresTime = expiresTime;
      }
      await BaseSecureStorage().write(_sessionKey, jsonEncode(_currentUser!.toJson()));
      notifyListeners();
    }
  }

  @override
  Future<void> clearAll() async {
    await doLogoutAndClearAll();
  }
}
