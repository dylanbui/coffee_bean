/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 21/06/2022 - 15:40
 * To change this template use File | Settings | File Templates.
 */

import 'dart:async';

import 'package:chuck_interceptor/chuck_interceptor.dart';
import 'package:coffee_bean/data/repository/activity_repository.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/data/repository/payment_domain_repository.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/flash_dialog_provider.dart';
import 'package:coffee_bean/shared/ui/flash_toast_provider.dart';
import 'package:coffee_bean/shared/service/notify_network_available/offline_widget.dart';
import 'package:coffee_bean/shared/service/notify_app_upgrade/app_upgrade_widget.dart';
import 'package:coffee_bean/shared/service/notify_app_upgrade/app_upgrade_service.dart';
import 'package:db_core/utils/network_checker.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:db_core/architecture_ribs/navigator.dart';
import 'package:db_core/network/network_client.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/services/event_bus.dart';
import 'package:db_core/utils/shared_preferences.dart';
import 'package:coffee_bean/config/app_config.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/network/header_interceptor.dart';
import 'package:coffee_bean/data/network/token_interceptor.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/scenes/app/app_builder.dart';
import 'package:coffee_bean/data/repository/comment_repository.dart';
import 'package:coffee_bean/data/repository/course_repository.dart';
import 'package:coffee_bean/data/repository/reservation_repository.dart';
import 'package:coffee_bean/data/repository/store_point_repository.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/live_service/likes_service.dart';
import 'package:coffee_bean/scenes/app/interactor/deep_link_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';

Chuck chuck = Chuck(
  showNotification: true,
  showInspectorOnShake: true,
);

Future<Widget> initializeApp() async {
  // --- PHASE 1: PARALLEL INITIALIZATION ---
  // Maximize I/O efficiency by running independent tasks concurrently.
  // The total wait time will be equal to the longest task in this group.
  await Future.wait([
    // 1. Firebase & Remote Config
    _initFirebase(),

    // 2. Load SharedPreferences (Required for UserManager initialization in the next phase)
    DbSharedPreferences().loadPreferences(),

    // 3. Initialize Database (Await DB file opening in parallel with other I/O)
    _initDatabase(),

    // 4. Configure UI Utils, Cache, Toast & Dialog Styles
    _setupUiUtils(),
  ]);

  // --- PHASE 2: SEQUENTIAL INITIALIZATION ---

  // 1. Register Repositories and Lazy Services into the Locator
  _registerLazyServices();

  // 2. Initialize UserManager and handle initial Auth logic
  await _setupUserManager();

  // 3. Initialize Network Service (Requires UserManager for TokenInterceptor setup)
  await _setupNetwork();

  // Platform specific setup
  if (defaultTargetPlatform == TargetPlatform.android) {
    // AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  // Remove the native splash screen once the entire system is ready
  FlutterNativeSplash.remove();

  return App();
}

// region: Helper Initialization Methods

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp();
    // Configure Remote Config for app upgrades
    await AppUpgradeService.setupRemoteConfig();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
}

Future<void> _initDatabase() async {
  final dbService = DatabaseService();
  await dbService.init();
  // Check if the service is already registered to prevent "Object already registered" errors during Hot Reload.
  if (!locator.isRegistered<DatabaseService>()) {
    locator.registerSingleton<DatabaseService>(dbService);
  }
}

Future<void> _setupUserManager() async {
  // Load data from SecureStorage into UserManager RAM immediately
  await UserManager().init();

  // TODO: 3. Demo logic - clear all data on every app restart (Development phase only)
  // await UserManager().doLogoutAndClearAll();
}

Future<void> _setupNetwork() async {
  // 1. Get common headers configuration (including tenant-id: 162)
  final commonHeaders = AppConfig().defaultHeaders;

  // 2. Initialize a "clean" NetworkClient - ONLY used for Refresh Token
  // This client MUST NOT contain TokenInterceptor to avoid infinite loops
  final refreshClient = NetworkClient(NetworkConfig(
    baseUrl: AppConfig().url,
    interceptors: [
      HeaderInterceptor(headers: commonHeaders),
      // Optionally add Chuck here to monitor refresh token requests
      chuck.dioInterceptor, 
    ],
  ));
  
  // 3. Configure TokenInterceptor
  final tokenInterceptor = TokenInterceptor(
    client: refreshClient, 
    refreshPath: "/app-api/member/auth/refresh-token", 
    tokenProvider: UserManager(), 
    onLogout: () => UserManager().doLogoutAndClearAll(),
  );

  // 4. Initialize the MAIN NetworkServiceProvider for the entire App
  NetworkServiceProvider.init(NetworkConfig(
    baseUrl: AppConfig().url,
    timeout: const Duration(seconds: 30),
    interceptors: [
      HeaderInterceptor(headers: commonHeaders), // Ensure every request has tenant-id
      tokenInterceptor,                          // Manage Access Token
      chuck.dioInterceptor,                       // Logger/Inspector
    ],
  ));
}

void _registerLazyServices() {
  // [IMPORTANT]: Check if a representative service is already registered and exit early.
  // In Flutter, during "Hot Reload", the initializeApp function might be called again.
  // GetIt (locator) does not allow duplicate registration of Singletons/LazySingletons of the same Type.
  // Failing to check will cause the app to crash with an "Object already registered" error.
  if (locator.isRegistered<DbEventBus>()) return;

  // Register Broadcast Service (EventBus)
  locator.registerLazySingleton<DbEventBus>(() => DbEventBus());
  // Register DeepLink Service
  locator.registerLazySingleton<DeepLinkService>(() => DeepLinkService());
  // Register Live Services
  locator.registerLazySingleton<CartService>(() => CartService());
  locator.registerLazySingleton<LikesService>(() => LikesService());

  // Register Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  locator.registerLazySingleton<UserRepository>(() => UserRepository());
  locator.registerLazySingleton<PaymentDomainRepository>(() => PaymentDomainRepository());
  locator.registerLazySingleton<CommentRepository>(() => CommentRepository());
  locator.registerLazySingleton<ReservationRepository>(() => ReservationRepository());
  locator.registerLazySingleton<CourseRepository>(() => CourseRepository());
  locator.registerLazySingleton<ActivityRepository>(() => ActivityRepository());
  locator.registerLazySingleton<StorePointRepository>(() => StorePointRepository());
}

Future<void> _setupUiUtils() async {
  // Cache system configuration
  DbCachedImageConfig.init(
    fallbackAsset: AppAssets.images.imgNoImage,
    // Advanced cache configuration:
    cacheManager: CacheManager(
      Config(
        'coffee_bean_cache_key',
        stalePeriod: const Duration(days: 30), // Retain for 30 days
        maxNrOfCacheObjects: 200,             // Max 200 images
      ),
    ),
  );

  // Initialize Toast & Dialog Style Providers for Coffee Bean project
  TMLabsToastStyleProvider.init();
  TMLabsDialogStyleProvider.init();
}

// endregion


/// -------------------------
/// MAIN APP
/// -------------------------

class App extends StatefulWidget {
  final AppBuilder _appBuilder = AppBuilder();
  late final _appRouter = _appBuilder.build();

  App({super.key}) {
    _appBuilder.startApp();
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver, _AppNetworkMixin, _AppUpgradeMixin {

  @override
  void initState() {
    super.initState();
    debugPrint("App: --- INIT STATE ---");
    WidgetsBinding.instance.addObserver(this);
    
    _initNetworkLogic();
    _initUpgradeLogic();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkUpgrade(force: _newVersion != null);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeNetworkLogic();
    _disposeUpgradeLogic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: DbNavigator.globalNavigatorState,
      title: 'Coffee Bean',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Sử dụng builder để OfflineWidget che phủ TẤT CẢ mọi thứ (kể cả Dialog/Modal)
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            if (_isOffline)
              OfflineWidget(onRetry: _refreshCurrentPage),
            if (_newVersion case final version?)
              AppUpgradeWidget(
                newVersion: version,
                onUpdate: () => AppUpgradeService.openStore(),
              ),
          ],
        );
      },
      home: widget._appRouter.viewController,
    );
  }
}

/// -------------------------
/// MIXIN APP
/// -------------------------


// region: Network Checker

mixin _AppNetworkMixin on State<App> {
  late final DbNetworkChecker _networkChecker;
  bool _isOffline = false;
  late StreamSubscription _subNetworkChecker;

  void _initNetworkLogic() {
    _networkChecker = DbNetworkChecker();
    _networkChecker.start();

    _subNetworkChecker = _networkChecker.stream.listen((status) {
      if (status is DbNetworkStatusOffline) {
        if (!_isOffline) setState(() => _isOffline = true);
      } else {
        if (_isOffline) {
          setState(() => _isOffline = false);
          _refreshCurrentPage();
        }
      }
    });
  }

  void _disposeNetworkLogic() {
    _subNetworkChecker.cancel();
    _networkChecker.dispose();
  }

  void _refreshCurrentPage() {
    _networkChecker.recheck();
    final context = DbNavigator.globalNavigatorState.currentContext;
    if (context != null) {
      // Ví dụ: gọi Bloc hoặc interactor để refresh
      // BlocProvider.of<ReservationListInteractor>(context).onRefresh();
    }
  }
}

// endregion

// region: App Update Remote Config

mixin _AppUpgradeMixin on State<App> {
  String? _newVersion;
  late StreamSubscription<RemoteConfigUpdate> _remoteConfigSub;

  void _initUpgradeLogic() {
    // 1. Lắng nghe sự kiện yêu cầu check update từ UI (ví dụ từ trang Profile)
    locator<DbEventBus>().on<CheckAppUpgradeRequestEvent>().listen((event) {
      _checkUpgrade(force: true);
    });

    // 2. CHUẨN GOOGLE: Thực hiện fetchAndActivate lần đầu trước khi lắng nghe updates
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkUpgrade(force: true);

      // 3. Sau khi đã có dữ liệu ban đầu, mới bắt đầu lắng nghe Real-time
      final remoteConfig = FirebaseRemoteConfig.instance;
      _remoteConfigSub = remoteConfig.onConfigUpdated.listen((event) async {
        debugPrint("App: [REAL-TIME] Remote Config signal received! Updated keys: ${event.updatedKeys}");
        try {
          // Tín hiệu real-time đã tự động fetch dữ liệu, chỉ cần activate
          await remoteConfig.activate();
          if (event.updatedKeys.isEmpty || event.updatedKeys.contains('latest_app_version')) {
            _checkUpgrade(force: false);
          }
        } catch (error) {
          debugPrint('App: [REAL-TIME] Config update failed: $error');
        }
      }, onError: (error) {
        debugPrint('App: [REAL-TIME] Stream error: $error');
      });
    });
  }

  void _disposeUpgradeLogic() {
    _remoteConfigSub.cancel();
  }

  Future<void> _checkUpgrade({bool force = false}) async {
    final version = await AppUpgradeService.checkUpdate(force: force);
    if (mounted) {
      setState(() {
        _newVersion = version;
      });
    }
  }
}

// endregion