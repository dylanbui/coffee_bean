import 'dart:async';

import 'package:coffee_bean/data/local/user_manager/user_service.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/data/repository/store_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_helper.dart';
import 'package:coffee_bean/shared/service/system_notify/system_notify_event.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/store_manager/store_manager.dart';
import 'package:coffee_bean/scenes/app/app_router.dart';
import 'package:coffee_bean/data/local/settings_app_manager/settings_app_manager.dart';
import 'package:db_core/db_core.dart';
import 'package:easy_localization/easy_localization.dart';

/// The State for the AppInteractor.
abstract class AppInteractorState extends BaseBlocState {}

class AppInteractorInitial extends AppInteractorState {}

/// The Interactor for the root of the application.
/// It contains business logic for bootstrapping, session management, and deep linking.
class AppInteractor extends CubitInteractor<AppRoutable, AppInteractorState> {
  final UserRepository _userRepository = locator<UserRepository>();
  final StoreRepository _storeRepository = locator<StoreRepository>();
  
  DateTime? _lastSessionCheck;
  bool _isCheckingSession = false;
  final Duration _sessionCheckInterval = const Duration(minutes: 5);

  AppInteractor({required AppRoutable router}) : super(AppInteractorInitial(), router: router) {
    dLog("AppInteractor: Instance created - HashCode: $hashCode");
  }

  // ===========================================================================
  // SECTION: Lifecycle & Events
  // ===========================================================================

  /// Initialize global system-wide event listeners.
  /// Called manually from AppBuilder.startApp() because SplashPage is a StatelessWidget.
  void initializeSystemEvents() {
    dLog("AppInteractor: Initializing System Events (EventBus listeners)...");
    
    // Listen to app lifecycle events via EventBus
    collect(locator<DbEventBus>().on<AppLifecycleChangedEvent>().listen((event) {
      if (event.isResumed) {
        dLog("AppInteractor: App resumed, verifying session...");
        handleSessionWorkflow();
      }
    }));

    // Listen to app settings changes (Language/Currency)
    collect(locator<DbEventBus>().on<SettingsAppChangedEvent>().listen((event) {
      final newLocale = SettingsAppManager.currentLanguage.locale;
      dLog("AppInteractor: Received SettingsAppChangedEvent! New Locale: ${newLocale.toString()}");
      
      // Sử dụng Global Context để cập nhật ngôn ngữ tại Runtime
      final context = DbNavigator.globalNavigatorState.currentContext;
      if (context != null && context.mounted) {
        dLog("AppInteractor: Found global context. Updating Locale...");
        context.setLocale(newLocale);
      } else {
        dLog("AppInteractor: WARNING: Global context is NULL or not mounted. Locale might not update immediately.");
      }
      
      router?.gotoMainRoot();
    }));

    // Logout User
    collect(locator<DbEventBus>().on<UserLogoutEvent>().listen((event) {
      dLog("AppInteractor: Received UserLogoutEvent! Rebooting to Main Root...");
      router?.gotoMainRoot();
    }));
  }

  // ===========================================================================
  // SECTION: Session Workflow (Token & Profile)
  // ===========================================================================

  /// Main orchestration for session verification. Called during bootstrap and app resume.
  Future<void> handleSessionWorkflow({bool force = false}) async {
    if (!UserManager().isLogin || _isCheckingSession) return;

    final now = DateTime.now();
    // Throttling: 5 minutes as per requirement
    if (!force && _lastSessionCheck != null && 
        now.difference(_lastSessionCheck!) < _sessionCheckInterval) {
      return;
    }

    _isCheckingSession = true;
    _lastSessionCheck = now;

    try {
      // 1. PHASE 1: Token Health Check (Pre-emptive)
      final bool isTokenOk = await _ensureValidToken();
      
      if (!isTokenOk) {
        dLog("AppInteractor: Token validation failed. Forcing logout.");
        await _performLogout();
        return;
      }

      // 2. PHASE 2: Profile Sync
      await _verifySession();
      
    } catch (e) {
      dLog("AppInteractor: Session verification error (Final fallback): $e");
      await _performLogout();
    } finally {
      _isCheckingSession = false;
    }
  }

  /// Ensures Access Token is valid or refreshed.
  Future<bool> _ensureValidToken() async {
    final session = UserManager().currentUser;
    if (session == null || !session.isLogin) return false;

    // Check expiration with a 5-minute buffer
    if (UtcUtils.isExpired(session.expiresTime ?? 0, buffer: const Duration(minutes: 5))) {
      dLog("AppInteractor: Token is expiring soon. Pre-emptively refreshing...");
      
      final authRepository = locator<AuthRepository>();
      final result = await authRepository.refreshToken(session.refreshToken ?? "");

      if (result case DbSuccess(data: final newAuth)) {
        dLog("AppInteractor: Token refreshed successfully.");
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
    return true;
  }

  /// Fetches profile from API and updates local storage.
  Future<void> _verifySession() async {
    // Sử dụng hàm refreshFullUserInfo để lấy cả Profile và các thông số counters (Coupon count, etc.)
    try {
      await UserService().refreshFullUserInfo();
      dLog("AppInteractor: User profile and counters updated successfully.");
    } catch (e) {
      dLog("AppInteractor: Failed to refresh user info: $e");
      // Nếu lỗi là 401/403 thì để Interceptor hoặc các tầng khác xử lý Logout nếu cần
    }
  }

  /// Clean logout and navigation
  Future<void> _performLogout() async {
    await UserService().logout();
    locator<DbEventBus>().fire(UserSessionExpiredEvent());
    router?.gotoMainRoot();
  }

  // ===========================================================================
  // SECTION: Bootstrapping & Initialization
  // ===========================================================================

  /// Called by the AppBuilder when the splash screen is active.
  Future<void> bootstrap() async {
    dLog("AppInteractor: Bootstrapping application...");

    // 1. DATABASE CLEANUP (Optional/Development only)
    // NOTE: This clears everything including Cart. Remove for Production.
    try {
      final dbService = locator<DatabaseService>();
      await dbService.clearAllDataForNewStore();
      dLog("AppInteractor: Local database cleared for fresh start.");
    } catch (e) {
      dLog("AppInteractor: Error during database cleanup: $e");
    }

    // 2. SESSION VALIDATION (Cold Start)
    await handleSessionWorkflow(force: true);

    // 3. DEFAULT CONTEXT (Store Selection)
    await _initDefaultStore();

    // Finish bootstrap and transition from Splash
    router?.successSyncDataFormServer();
  }

  /// Automatically sets a default store if none is selected.
  Future<void> _initDefaultStore() async {
    if (StoreManager().selectedStore != null) return;

    dLog("AppInteractor: No store selected. Fetching default store...");
    
    // 1. Get current location (passive check)
    final DbLocation? location = await _getLastKnownLocation();
    if (location != null) {
      dLog("AppInteractor: Using GPS for default store search: $location");
    }

    // 2. Fetch default store from server
    final defaultStore = await _storeRepository.getDefaultStore(location: location);
    
    // 3. Save if found
    if (defaultStore != null) {
      await StoreManager().saveSelectedStore(defaultStore);
      dLog("AppInteractor: Default store set to ${defaultStore.name}");
    }
  }

  /// Helper: Get last known position without requesting permission
  Future<DbLocation?> _getLastKnownLocation() async {
    try {
      final status = await Permission.location.status;
      if (status.isGranted) {
        final position = await Geolocator.getLastKnownPosition();
        return position?.toDbLocation();
      }
    } catch (e) {
      dLog("AppInteractor: Error getting location: $e");
    }
    return null;
  }

}
