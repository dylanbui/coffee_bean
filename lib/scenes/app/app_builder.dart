import 'package:coffee_bean/core/architecture_ribs/navigator.dart';
import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/core/utils/logger.dart';
import 'package:coffee_bean/scenes/app/app_router.dart';
import 'package:coffee_bean/scenes/app/interactor/app_interactor.dart';
import 'package:coffee_bean/scenes/app/interactor/splash_page.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_builder.dart';
import 'package:coffee_bean/scenes/splash_page/splash_page_builder.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/user_login_builder.dart';
import 'package:flutter/material.dart';

// Buildable
// abstract class AppRouter implements DbNoteRoutable {
//   void routerToAppStart();
//
// }

/// AppBuilder acts as a "Root Coordinator" or "Root Router".
/// Its main responsibility is to coordinate the main application flows (e.g., Splash, Auth, Main)
/// and initialize global services.
class AppBuilder extends DbNoteBuilder<AppRouter> implements SplashPageListener {
  late final AppRouter _router;
  late final AppInteractor _interactor;



  AppBuilder() {
    _router = AppRouter();
    // 1. Khởi tạo interactor ngay khi AppBuilder ra đời
    _interactor = AppInteractor(router: _router);

    // 2. Gọi bootstrap TẠI ĐÂY để đảm bảo nó chỉ chạy 1 lần duy nhất
    // bất kể hàm build() phía dưới có bị Flutter gọi lại bao nhiêu lần.
    // interactor.bootstrap();
  }

  void startApp() async {
    // Khoi tao cac gia tri bat dau tai trang.
    // Day se la ham load du lieu
    _interactor.bootstrap();
  }

  @override
  AppRouter build() {
    eLog("AppBuilder =======");
    // final view = AppPage(appInteractor: _interactor);
    final view = SplashPage();
    _router.attach(_interactor, view);
    return _router;
  }

  // @override
  // void routerToAppStart() {
  //   dLog("routerToAppStart ----- MainTabbarBuilder");
  //
  //   MainTabbarBuilder mainTabbarBuilder = MainTabbarBuilder();
  //   pushSameRootPage(mainTabbarBuilder.build());
  //
  //   // UserLoginBuilder userLoginBuilder = UserLoginBuilder();
  //   // pushSameRootPage(userLoginBuilder.build());
  // }

  // @override
  // ViewController buildFactory() {
  //   // 1. Create the Interactor, which contains the application's root-level business logic.
  //   //    We pass `this` builder to act as the router.
  //   // interactor = AppInteractor(router: this);
  //   // // Call sync function
  //   // interactor = AppInteractor(router: this);
  //   // interactor.bootstrap();
  //
  //   // 2. Build the initial UI, which is the Splash screen.
  //   //    The Interactor will be notified when the splash screen completes.
  //   // AppBuilder will listen for the event when Splash completes.
  //   // Splash luc nay co the la trang tinh, khong lam gi ca, statelesswidget
  //   final SplashPageBuilder splashPageBuilder = SplashPageBuilder(listener: this);
  //   return splashPageBuilder.build();
  // }

  @override
  void onSplashPageCompleted() {
    // 3. Delegate the completion event to the Interactor to handle the bootstrap logic.
    // await interactor.bootstrap();
    // ProblemReportBuilder problemReportBuilder = ProblemReportBuilder();
    // pushSameRootPage(problemReportBuilder.build());

    // FlashDemoBuilder flashDemoBuilder = FlashDemoBuilder();
    // pushSameRootPage(flashDemoBuilder.build());

    // ForgotPasswordBuilder forgotPasswordBuilder = ForgotPasswordBuilder();
    // pushSameRootPage(forgotPasswordBuilder.build());

    // dLog("onSplashPageCompleted ----- UserLoginBuilder");
    // UserLoginBuilder userLoginBuilder = UserLoginBuilder();
    // pushSameRootPage(userLoginBuilder.build());

    // UserGiftPackBuilder userGiftPackBuilder = UserGiftPackBuilder();
    // pushSameRootPage(userGiftPackBuilder.build());
    // UserRegisterBuilder userRegisterBuilder = UserRegisterBuilder();
    // pushSameRootPage(userRegisterBuilder.build());

  }

  // @override
  // void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  //   // This method is called by the Interactor to handle routing, including deep links.
  //   // It translates a logical `DbNoteRoute` into a concrete navigation action.
  //   dLog("AppBuilder: Handling navigation for route: ${toRoute.runtimeType}");
  //   //
  //   // switch (toRoute) {
  //   //   case SplashRoute():
  //   //     final builder = SplashStartBuilder();
  //   //     push(builder.buildWithListener(this));
  //   //     break;
  //   //   case UserDetailRoute():
  //   //     final builder = UserDetailBuilder(userId: toRoute.userId);
  //   //     push(builder.build());
  //   //     break;
  //   //   // Add cases for other routes here
  //   // }
  // }




}

