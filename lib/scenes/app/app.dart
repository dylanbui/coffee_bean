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
import 'package:coffee_bean/data/repository/upload_files_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/data/repository/payment_domain_repository.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/flash_dialog_provider.dart';
import 'package:coffee_bean/shared/ui/flash_toast_provider.dart';
import 'package:coffee_bean/shared/service/notify_network_available/offline_widget.dart';
import 'package:coffee_bean/shared/service/notify_app_upgrade/app_upgrade_widget.dart';
import 'package:coffee_bean/shared/service/notify_app_upgrade/app_upgrade_service.dart';
import 'package:coffee_bean/scenes/app/mixins/app_network_mixin.dart';
import 'package:coffee_bean/scenes/app/mixins/app_upgrade_mixin.dart';
import 'package:coffee_bean/scenes/app/mixins/app_notify_mixin.dart';
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
import 'package:coffee_bean/data/repository/product_repository.dart';
import 'package:coffee_bean/data/repository/comment_repository.dart';
import 'package:coffee_bean/data/repository/course_repository.dart';
import 'package:coffee_bean/data/repository/reservation_repository.dart';
import 'package:coffee_bean/data/repository/store_repository.dart';
import 'package:coffee_bean/data/repository/store_point_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/live_service/likes_service.dart';
import 'package:coffee_bean/scenes/app/interactor/deep_link_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';

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

    // 5. Initialize Internationalization (i18n)
    EasyLocalization.ensureInitialized(),
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

  return EasyLocalization(
    supportedLocales: const [Locale('vi'), Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('vi'),
    child: App(),
  );
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
  locator.registerLazySingleton<UploadFilesRepository>(() => UploadFilesRepository());
  locator.registerLazySingleton<PaymentDomainRepository>(() => PaymentDomainRepository());
  locator.registerLazySingleton<CommentRepository>(() => CommentRepository());
  locator.registerLazySingleton<ReservationRepository>(() => ReservationRepository());
  locator.registerLazySingleton<CourseRepository>(() => CourseRepository());
  locator.registerLazySingleton<ActivityRepository>(() => ActivityRepository());
  locator.registerLazySingleton<StorePointRepository>(() => StorePointRepository());
  locator.registerLazySingleton<StoreRepository>(() => StoreRepository());
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository());
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

class _AppState extends State<App> with WidgetsBindingObserver, AppNetworkMixin, AppUpgradeMixin, AppNotifyMixin {

  @override
  void initState() {
    super.initState();
    debugPrint("App: --- INIT STATE ---");
    WidgetsBinding.instance.addObserver(this);
    
    initNetworkLogic();
    initUpgradeLogic();
    initNotifyLogic();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkUpgrade(force: newVersion != null);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disposeNetworkLogic();
    disposeUpgradeLogic();
    disposeNotifyLogic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: DbNavigator.globalNavigatorState,
      // --- localizations ---
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Coffee Bean',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Sử dụng builder để OfflineWidget che phủ TẤT CẢ mọi thứ (kể cả Dialog/Modal)
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            if (isOffline)
              OfflineWidget(onRetry: refreshCurrentPage),
            if (newVersion case final version?)
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
/// END APP
/// -------------------------
