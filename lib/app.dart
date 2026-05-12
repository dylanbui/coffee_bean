/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 21/06/2022 - 15:40
 * To change this template use File | Settings | File Templates.
 */

import 'package:chuck_interceptor/chuck_interceptor.dart';
import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/network/network_common.dart';
import 'package:coffee_bean/commons/services/event_bus.dart';
import 'package:coffee_bean/commons/utils/shared_preferences.dart';
import 'package:coffee_bean/config/app_config.dart';
import 'package:coffee_bean/data/local/user_session.dart';
import 'package:coffee_bean/scenes/app/app_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coffee_bean/commons/utils/locator.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/live_service/likes_service.dart';
import 'package:coffee_bean/scenes/app/interactor/deep_link_service.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load share preferences data when start app
  await DbSharedPreferences().loadPreferences();
  // Load current data
  AppConfig().currentUser = await UserSession.fromSystem();
  // 1. Initialize Network Service
  NetworkServiceProvider.init(NetworkConfig(
    baseUrl: AppConfig().url,
    timeout: Duration(seconds: 30),
    interceptors: [chuck.dioInterceptor],

  ));

  // Initialize locator and services, Always load AFTER Load share preferences
  await setupLocator();

  // Check if we're running on Android
  if (defaultTargetPlatform == TargetPlatform.android) {
    // AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  // Remove the native splash screen when app is ready
  FlutterNativeSplash.remove();

  return App();
}

Future<void> setupLocator() async {
  // Register Broadcast Service same EventBus
  locator.registerLazySingleton<DbEventBus>(() => DbEventBus());
  // Register DeepLink Service
  locator.registerLazySingleton<DeepLinkService>(() => DeepLinkService());
  // Register Live Services
  locator.registerLazySingleton<CartService>(() => CartService());
  locator.registerLazySingleton<LikesService>(() => LikesService());
}


// class App extends StatefulWidget {
//   const App({super.key});
//
//   @override
//   State<App> createState() => _AppState();
// }
//
// class _AppState extends State<App> {
//   // Khởi tạo instance duy nhất ở đây
//   late final AppBuildable _appBuilder;
//
//   @override
//   void initState() {
//     super.initState();
//     _appBuilder = AppBuilder();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: DbNavigator.navigatorState,
//       title: 'Coffee Bean',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: _appBuilder.build(),
//     );
//   }
// }

class App extends StatelessWidget {

  late final AppBuilder _appBuilder ;

  App({super.key}) {
    _appBuilder = AppBuilder();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Run sync data
    _appBuilder.init();

    return MaterialApp(
      // Connect GlobalKey from Router to Flutter Navigator
      navigatorKey: DbNavigator.navigatorState,
      title: 'Coffee Bean',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _appBuilder.build(),
    );
  }
}


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