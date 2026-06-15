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
import 'package:coffee_bean/data/repository/payment_domain_repository.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/flash_dialog_provider.dart';
import 'package:coffee_bean/shared/ui/flash_toast_provider.dart';
import 'package:coffee_bean/shared/widget/offline_widget.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/live_service/likes_service.dart';
import 'package:coffee_bean/scenes/app/interactor/deep_link_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Chuck chuck = Chuck(
  showNotification: true,
  showInspectorOnShake: true,
);

Future<Widget> initializeApp() async {
  /*
  Specifies the set of orientations the application interface can be displayed in.
  The orientation argument is a list of DeviceOrientation enum values. The empty list causes the application to defer to the operating system default.
  * */
  // Xu ly trong main.dart
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  // Initialize locator and services, Always load AFTER Load share preferences
  await _setupLocator();

  // UserManager + SecureStorage
  await _setupStoreManager();

  // Initialize Network Service
  await _setupNetwork();

  // Check if we're running on Android
  if (defaultTargetPlatform == TargetPlatform.android) {
    // AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  // Remove the native splash screen when app is ready
  FlutterNativeSplash.remove();

  // Initialize Network Service
  await _setupUiUtils();

  return App();
}

Future<void> _setupStoreManager() async {
  // 1. Load share preferences data when start app
  await DbSharedPreferences().loadPreferences();
  // 2. Nạp dữ liệu từ SecureStorage lên RAM của UserManager ngay lập tức
  await UserManager().init();


  // TODO: 3. Demo, moi khi chay lai app se xoa sach du lieu
  await UserManager().doLogoutAndClearAll();
}

Future<void> _setupNetwork() async {
  // 1. Lấy cấu hình headers dùng chung (đã bao gồm tenant-id: 162)
  final commonHeaders = AppConfig().defaultHeaders;

  // 2. Khởi tạo một NetworkClient "sạch" - CHỈ dùng để Refresh Token
  // Client này không được chứa TokenInterceptor để tránh vòng lặp vô hạn (Infinite Loop)
  final refreshClient = NetworkClient(NetworkConfig(
    baseUrl: AppConfig().url,
    interceptors: [
      HeaderInterceptor(headers: commonHeaders),
      // Có thể thêm Chuck ở đây nếu muốn theo dõi cả request refresh token
      chuck.dioInterceptor, 
    ],
  ));
  
  // 3. Cấu hình TokenInterceptor
  final tokenInterceptor = TokenInterceptor(
    client: refreshClient, 
    refreshPath: "/app-api/member/auth/refresh-token", 
    tokenProvider: UserManager(), 
    onLogout: () => UserManager().doLogoutAndClearAll(),
  );

  // 4. Khởi tạo NetworkServiceProvider CHÍNH cho toàn bộ App
  NetworkServiceProvider.init(NetworkConfig(
    baseUrl: AppConfig().url,
    timeout: const Duration(seconds: 30),
    interceptors: [
      HeaderInterceptor(headers: commonHeaders), // Đảm bảo mọi request đều có tenant-id
      tokenInterceptor,                          // Quản lý Access Token
      chuck.dioInterceptor,                       // Logger/Inspector
    ],
  ));
}

Future<void> _setupLocator() async {
  // Register Database Service
  final dbService = DatabaseService();
  await dbService.init();
  locator.registerSingleton<DatabaseService>(dbService);

  // Register Broadcast Service same EventBus
  locator.registerLazySingleton<DbEventBus>(() => DbEventBus());
  // Register DeepLink Service
  locator.registerLazySingleton<DeepLinkService>(() => DeepLinkService());
  // Register Live Services
  locator.registerLazySingleton<CartService>(() => CartService());
  locator.registerLazySingleton<LikesService>(() => LikesService());

  // Register Repositories
  locator.registerLazySingleton<PaymentDomainRepository>(() => PaymentDomainRepository());
  locator.registerLazySingleton<CommentRepository>(() => CommentRepository());
  locator.registerLazySingleton<ReservationRepository>(() => ReservationRepository());
  locator.registerLazySingleton<CourseRepository>(() => CourseRepository());
  locator.registerLazySingleton<ActivityRepository>(() => ActivityRepository());
  locator.registerLazySingleton<StorePointRepository>(() => StorePointRepository());
}

Future<void> _setupUiUtils() async {
  // Cache system
  DbCachedImageConfig.init(
    fallbackAsset: AppAssets.images.imgNoImage,
    // Nếu muốn cấu hình cache chuyên sâu hơn:
    cacheManager: CacheManager(
      Config(
        'coffee_bean_cache_key',
        stalePeriod: const Duration(days: 30), // Lưu 30 ngày
        maxNrOfCacheObjects: 200,             // Tối đa 200 ảnh
      ),
    ),
  );

  // Khởi tạo Toast & Dialog Helper với Style của dự án Coffee Bean
  TMLabsToastStyleProvider.init();
  TMLabsDialogStyleProvider.init();
}

/// -------------------------
/// Main APP
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

class _AppState extends State<App> {
  late final DbNetworkChecker _checker;
  bool _isOffline = false;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _checker = DbNetworkChecker();
    _checker.start();

    _sub = _checker.stream.listen((status) {
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

  void _refreshCurrentPage() {
    _checker.recheck();

    final context = DbNavigator.globalNavigatorState.currentContext;
    if (context != null) {
      // Ví dụ: gọi Bloc hoặc interactor để refresh
      // BlocProvider.of<ReservationListInteractor>(context).onRefresh();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _checker.dispose();
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
            if (child != null) child,
            if (_isOffline)
              OfflineWidget(onRetry: _refreshCurrentPage),
          ],
        );
      },
      home: widget._appRouter.viewController,
    );
  }
}


// RUN GOOD
// class App extends StatelessWidget {
//
//   final AppBuilder _appBuilder = AppBuilder();
//   late final _appRouter = _appBuilder.build();
//
//   App({super.key}) {
//     // Run sync data
//     _appBuilder.startApp();
//   }
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // Connect GlobalKey from Router to Flutter Navigator
//       navigatorKey: DbNavigator.globalNavigatorState,
//       title: 'Coffee Bean',
//       theme: ThemeData(primarySwatch: Colors.blue,),
//       home: _appRouter.viewController,
//     );
//   }
// }


//
// class App {
//
//   late SessionUser currentUser;
//
//   // region Make Singleton Class
//   // 1. Private constructor
//   App._internal();
//   // 2. Instance static
//   static final App _instance = App._internal();
//   // 3. Factory constructor
//   factory App() {
//     return _instance;
//   }
//   // endregion
//
//   // Start load on main()
//   Future<void> startLoad() async {
//     // Su dung load cac gia tri ban dau
//     currentUser = SessionUser.fromSystem();
//   }
//
// }