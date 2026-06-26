import 'dart:ui';

import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/data/repository/promotion_repository.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_helper.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:db_core/db_core.dart';

class UserService {
  // 1. Singleton Pattern
  UserService._internal();
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;

  // Dependencies
  final _userManager = UserManager();
  final _authRepo = AuthRepository();
  final _userRepo = locator<UserRepository>();
  final _promoRepo = locator<PromotionRepository>();

  /// [1] Logout toàn diện (Server + Local)
  Future<void> logout({VoidCallback? onSuccess}) async {
    try {
      // Gọi API logout của server
      await _authRepo.logout();
    } catch (e) {
      dLog("UserService: Server logout failed, proceed to clear local: $e");
    }
    
    // Xóa sạch dữ liệu local
    await _userManager.doLogoutAndClearAll();

    // Callback logout thành công
    onSuccess?.call();
    // Delay process
    Utils.delay(milliseconds: 500);
    // Bắn event logout cho toàn hệ thống
    locator<DbEventBus>().fire(UserLogoutEvent());
  }

  /// [2] Làm mới toàn bộ thông tin User (Profile + Counters)
  Future<void> refreshFullUserInfo() async {
    if (!_userManager.isLogin) return;

    // Thực hiện gọi song song các API
    final results = await Future.wait([
      _userRepo.getUserInfo(),
      _promoRepo.getUnusedCouponCount(),
    ]);

    final userResult = (results[0] as ResultType<UserInfo>).toResult();
    final couponResult = (results[1] as ResultType<int>).toResult();

    if (userResult case DbSuccess(data: final info)) {
      int? currentCouponCount = _userManager.userInfo?.unusedCouponCount;

      // Cập nhật count nếu API Coupon thành công
      if (couponResult case DbSuccess(data: final count)) {
        currentCouponCount = count;
      }

      // Gộp dữ liệu và bảo UserManager lưu
      final updatedInfo = info.copyWith(unusedCouponCount: currentCouponCount);
      await _userManager.saveUserInfo(updatedInfo);
    }
  }

  /// [3] Chỉ làm mới các thông số số lượng (dùng sau khi Checkout)
  Future<void> refreshCounters() async {
    if (!_userManager.isLogin || _userManager.userInfo == null) return;

    final result = (await _promoRepo.getUnusedCouponCount()).toResult();
    if (result case DbSuccess(data: final count)) {
      await _userManager.saveUserInfo(
        _userManager.userInfo!.copyWith(unusedCouponCount: count)
      );
    }
  }
}
