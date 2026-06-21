import 'dart:async';
import 'dart:convert';

import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/data/repository/store_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/shared/service/system_notify/system_notify_event.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:db_core/architecture_ribs/note_interactor.dart';
import 'package:db_core/network/network_utils.dart';
import 'package:db_core/services/event_bus.dart';
import 'package:db_core/services/lifecycle_event.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/model/db_location.dart';
import 'package:coffee_bean/scenes/app/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// The State for the AppInteractor.
abstract class AppInteractorState extends BaseBlocState {}

class AppInteractorInitial extends AppInteractorState {}

/// The Interactor for the root of the application.
/// It contains business logic for bootstrapping, session management, and deep linking.
class AppInteractor extends CubitInteractor<AppRoutable, AppInteractorState> {
  final UserRepository _userRepository = locator<UserRepository>();
  
  DateTime? _lastSessionCheck;
  bool _isCheckingSession = false;
  final Duration _sessionCheckInterval = const Duration(minutes: 5);

  AppInteractor({required AppRoutable router}) : super(AppInteractorInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    
    // Lắng nghe sự kiện thay đổi vòng đời ứng dụng qua EventBus (do AppLifecycleService cung cấp)
    collect(locator<DbEventBus>().on<AppLifecycleChangedEvent>().listen((event) {
      if (event.isResumed) {
        dLog("AppInteractor: App resumed, verifying session...");
        handleSessionWorkflow();
      }
    }));
  }

  /// --- PHASE 1: TOKEN HEALTH CHECK (PRE-EMPTIVE) ---
  /// Trả về true nếu Token hợp lệ hoặc vừa được refresh thành công.
  /// Trả về false nếu token hết hạn mà không thể refresh.
  Future<bool> _ensureValidToken() async {
    final session = UserManager().currentUser;
    if (session == null || !session.isLogin) return false;

    // Kiểm tra hết hạn chủ động với 5 phút buffer
    if (UtcUtils.isExpired(session.expiresTime ?? 0, buffer: const Duration(minutes: 5))) {
      dLog("AppInteractor: Token is expiring soon. Pre-emptively refreshing...");
      
      final authRepository = locator<AuthRepository>();
      final result = (await authRepository.refreshToken(session.refreshToken ?? "")).toResult();

      if (result case DbSuccess(data: final newAuth)) {
        dLog("AppInteractor: Token refreshed successfully.");
        // Cập nhật Token mới và expiresTime mới vào UserManager
        await UserManager().updateAccessToken(
          newAuth.accessToken, 
          expiresTime: newAuth.expiresTime
        );
        return true;
      } else {
        dLog("AppInteractor: Refresh token failed.");
        return false;
      }
    }
    return true; // Token vẫn còn hạn tốt
  }

  /// --- PHASE 2: PROFILE SYNC (PASSIVE/NORMAL) ---
  /// Nhiệm vụ: Chỉ gọi API lấy profile và sync vào local.
  /// Nếu API trả về 401/403, hàm này ném lỗi để hàm điều phối xử lý logout.
  Future<void> _verifySession() async {
    final result = (await _userRepository.getUserInfo()).toResult();

    if (result case DbFailure(:final error)) {
      // Nếu lỗi 401/403 tại đây, nghĩa là Interceptor cũng đã thử refresh mà không được
      if (error.code == 401 || error.code == 403) {
        throw error;
      }
      return;
    }

    if (result case DbSuccess(:final data)) {
      await UserManager().saveUserInfo(data);
      dLog("AppInteractor: User profile updated successfully via verifySession.");
    }
  }

  /// --- PHASE 3: SESSION WORKFLOW ORCHESTRATION ---
  /// Hàm điều phối tổng thể được gọi từ bootstrap hoặc lifecycle resumed.
  Future<void> handleSessionWorkflow({bool force = false}) async {
    if (!UserManager().isLogin || _isCheckingSession) return;

    final now = DateTime.now();
    // Throttling: 5 phút theo yêu cầu
    if (!force && _lastSessionCheck != null && 
        now.difference(_lastSessionCheck!) < _sessionCheckInterval) {
      return;
    }

    _isCheckingSession = true;
    _lastSessionCheck = now;

    try {
      // 1. Giai đoạn 1: Đảm bảo Token hợp lệ trước (Chủ động)
      final bool isTokenOk = await _ensureValidToken();
      
      if (!isTokenOk) {
        dLog("AppInteractor: Token validation failed. Forcing logout.");
        await _performLogout();
        return;
      }

      // 2. Giai đoạn 2: Đồng bộ thông tin profile
      await _verifySession();
      
    } catch (e) {
      dLog("AppInteractor: Session verification error (Final fallback): $e");
      await _performLogout();
    } finally {
      _isCheckingSession = false;
    }
  }

  /// Thực hiện Logout sạch sẽ và điều hướng
  Future<void> _performLogout() async {
    await UserManager().doLogoutAndClearAll();
    
    // Bắn event thông báo hệ thống (định nghĩa trong system_notify_event.dart)
    locator<DbEventBus>().fire(UserSessionExpiredEvent());
    
    // Điều hướng về màn hình chính ở trạng thái Guest
    router?.gotoMainRoot();
  }

  /// Called by the AppBuilder when the splash screen is finished.
  Future<void> bootstrap() async {
    dLog("AppInteractor: Bootstrapping application...");

    // --- Phase 1: Load Data to Isar Cache ---
    try {
      final dbService = locator<DatabaseService>();
      
      // 1. Xóa sạch dữ liệu cũ để "làm như mới" hoàn toàn
      await dbService.clearAllDataForNewStore();
      dLog("AppInteractor: Database cleared for fresh start.");

      // 2. Đọc file sample data từ assets
      final String response = await rootBundle.loadString('assets/json/sample_data.json');
      final data = json.decode(response);

      final String storeResponse = await rootBundle.loadString('assets/json/sample_store.json');
      final storeData = json.decode(storeResponse);

      // GIẢ LẬP: Chạy 4 API đồng thời (Category, Product, Property, Store)
      dLog("AppInteractor: Fetching 4 APIs concurrently...");
      final results = await Future.wait([
        Future.delayed(const Duration(milliseconds: 500), () => data['categories']),
        Future.delayed(const Duration(milliseconds: 800), () => data['products']),
        Future.delayed(const Duration(milliseconds: 300), () => data['properties']),
        Future.delayed(const Duration(milliseconds: 400), () => storeData['stores']),
      ]);

      // 3. Sync toàn bộ dữ liệu (Không truyền targetType để nạp sạch mọi thứ)
      await dbService.syncShoppingData(
        categoriesJson: results[0] as List<dynamic>,
        productsJson: results[1] as List<dynamic>,
        propertiesJson: results[2] as List<dynamic>,
        storesJson: results[3] as List<dynamic>,
      );

      // --- Kiểm tra dữ liệu sau khi sync ---
      final foodCount = await dbService.isar.tblFoods.count();
      final courseCount = await dbService.isar.tblCourses.count();
      final catCount = await dbService.isar.tblCategorys.count();
      final storeCount = await dbService.isar.tblStores.count();
      dLog("AppInteractor: DB Sync Success -> Foods: $foodCount, Courses: $courseCount, Categories: $catCount, Stores: $storeCount");
      
      dLog("AppInteractor: Database bootstrapped successfully from simulated APIs.");
    } catch (e) {
      dLog("AppInteractor: Error bootstrapping database: $e");
    }

    // --- Phase 2: Session Validation (Cold Start) ---
    // Sử dụng luồng điều phối mới thay vì gọi trực tiếp verifySession
    await handleSessionWorkflow(force: true);

    // --- Phase 3: Default Store Check ---
    if (UserManager().selectedStore == null) {
      dLog("AppInteractor: No store selected. Fetching default store...");
      
      double? lat;
      double? lng;

      // Thử lấy GPS nếu đã được cấp quyền (Không chủ động xin quyền ở splash screen để tránh làm phiền user)
      try {
        final status = await Permission.location.status;
        if (status.isGranted) {
          final position = await Geolocator.getLastKnownPosition();
          if (position != null) {
            lat = position.latitude;
            lng = position.longitude;
            dLog("AppInteractor: Found GPS for default store: $lat, $lng");
          }
        }
      } catch (e) {
        dLog("AppInteractor: Error getting last known position: $e");
      }

      final location = (lat != null && lng != null) ? DbLocation(latitude: lat, longitude: lng) : null;
      final defaultStore = await locator<StoreRepository>().getDefaultStore(location: location);
      if (defaultStore != null) {
        await UserManager().saveSelectedStore(defaultStore);
        dLog("AppInteractor: Default store set to ${defaultStore.name}");
      }
    }

    // Giả lập xử lý load bootstrap
    //await Future.delayed(const Duration(milliseconds: 500));
    router?.successSyncDataFormServer();
  }
}
