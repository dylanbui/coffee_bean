import 'dart:async';

import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/data/repository/store_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/shared/service/system_notify/system_notify_event.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/store_manager/store_manager.dart';
import 'package:coffee_bean/scenes/app/app_router.dart';
import 'package:coffee_bean/data/local/app_setting_manager/app_setting_manager.dart';
import 'package:db_core/db_core.dart';

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

  AppInteractor({required AppRoutable router}) : super(AppInteractorInitial(), router: router);

  // ===========================================================================
  // SECTION: Lifecycle & Events
  // ===========================================================================

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    
    // Listen to app lifecycle events via EventBus
    collect(locator<DbEventBus>().on<AppLifecycleChangedEvent>().listen((event) {
      if (event.isResumed) {
        dLog("AppInteractor: App resumed, verifying session...");
        handleSessionWorkflow();
      }
    }));

    // Listen to app settings changes (Language/Currency)
    collect(locator<DbEventBus>().on<AppSettingChangedEvent>().listen((event) {
      dLog("AppInteractor: Settings changed, rebooting to Main Root...");
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
      final result = (await authRepository.refreshToken(session.refreshToken ?? "")).toResult();

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
    final result = (await _userRepository.getUserInfo()).toResult();

    if (result case DbFailure(:final error)) {
      // 401/403 means refresh failed in network layer
      if (error.code == 401 || error.code == 403) {
        throw error;
      }
      return;
    }

    if (result case DbSuccess(:final data)) {
      await UserManager().saveUserInfo(data);
      dLog("AppInteractor: User profile updated successfully.");
    }
  }

  /// Clean logout and navigation
  Future<void> _performLogout() async {
    await UserManager().doLogoutAndClearAll();
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
