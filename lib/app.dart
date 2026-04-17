/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 21/06/2022 - 15:40
 * To change this template use File | Settings | File Templates.
 */

import 'package:chuck_interceptor/chuck_interceptor.dart';
import 'package:coffee_bean/config/app_config.dart';
import 'package:coffee_bean/data/local/user_session.dart';
import 'package:coffee_bean/scenes/app/app_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'commons/architecture_ribs/navigator.dart';
import 'commons/utils/shared_preferences.dart';

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

  AppConfig().currentUser = await UserSession.fromSystem();

  // await setupLocator();

  // Check if we're running on Android
  if (defaultTargetPlatform == TargetPlatform.android) {
    // AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  return const App();
}

class App extends StatelessWidget {

  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final AppBuildable appBuilder = AppBuilder();

    return MaterialApp(
      // Connect GlobalKey from Router to Flutter Navigator
      navigatorKey: DbNavigator.navigatorState,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: appBuilder.build(),
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