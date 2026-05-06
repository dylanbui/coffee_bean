import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/commons/utils/logger.dart';
import 'package:coffee_bean/scenes/app/app_routes.dart';
import 'package:coffee_bean/scenes/app/interactor/app_interactor.dart';
import 'package:coffee_bean/scenes/problem_report/problem_report_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/flash_demo_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/splash_start/splash_start_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/user_detail_builder.dart';
import 'package:coffee_bean/scenes/user_pages/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_pages/user_gift_pack/user_gift_pack_builder.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/user_login_builder.dart';
import 'package:coffee_bean/scenes/user_pages/user_register/user_register_builder.dart';
import 'package:flutter/material.dart';

// Buildable
abstract class AppBuildable implements DbNoteBuildable { }

/// AppBuilder acts as a "Root Coordinator" or "Root Router".
/// Its main responsibility is to coordinate the main application flows (e.g., Splash, Auth, Main)
/// and initialize global services.
class AppBuilder extends DbNoteBuilder with DbNavigator implements AppBuildable, DbNoteRoutable, SplashStartListener {
  late final AppInteractor interactor;

  AppBuilder() {
    // 1. Khởi tạo interactor ngay khi AppBuilder ra đời
    interactor = AppInteractor(router: this);

    // 2. Gọi bootstrap TẠI ĐÂY để đảm bảo nó chỉ chạy 1 lần duy nhất
    // bất kể hàm build() phía dưới có bị Flutter gọi lại bao nhiêu lần.
    // interactor.bootstrap();
  }


  @override
  ViewController build() {
    // 1. Create the Interactor, which contains the application's root-level business logic.
    //    We pass `this` builder to act as the router.
    // interactor = AppInteractor(router: this);
    // // Call sync function
    interactor.bootstrap();

    // 2. Build the initial UI, which is the Splash screen.
    //    The Interactor will be notified when the splash screen completes.
    // AppBuilder will listen for the event when Splash completes.
    final SplashStartBuildable splashStartBuilder = SplashStartBuilder();
    final splashPage = splashStartBuilder.buildWithListener(this);
    return splashPage;
  }

  @override
  void splashPageComplete(String? message) async {
    // 3. Delegate the completion event to the Interactor to handle the bootstrap logic.
    // await interactor.bootstrap();
    // ProblemReportBuilder problemReportBuilder = ProblemReportBuilder();
    // pushSameRootPage(problemReportBuilder.build());

    // FlashDemoBuilder flashDemoBuilder = FlashDemoBuilder();
    // pushSameRootPage(flashDemoBuilder.build());

    // ForgotPasswordBuilder forgotPasswordBuilder = ForgotPasswordBuilder();
    // pushSameRootPage(forgotPasswordBuilder.build());

    dLog(message ?? "----- UserLoginBuilder");
    UserLoginBuilder userLoginBuilder = UserLoginBuilder();
    pushSameRootPage(userLoginBuilder.build());

    // UserGiftPackBuilder userGiftPackBuilder = UserGiftPackBuilder();
    // pushSameRootPage(userGiftPackBuilder.build());
    // UserRegisterBuilder userRegisterBuilder = UserRegisterBuilder();
    // pushSameRootPage(userRegisterBuilder.build());


  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // This method is called by the Interactor to handle routing, including deep links.
    // It translates a logical `DbNoteRoute` into a concrete navigation action.
    dLog("AppBuilder: Handling navigation for route: ${toRoute.runtimeType}");

    switch (toRoute) {
      case SplashRoute():
        final builder = SplashStartBuilder();
        push(builder.buildWithListener(this));
        break;
      case UserDetailRoute():
        final builder = UserDetailBuilder(userId: toRoute.userId);
        push(builder.build());
        break;
      // Add cases for other routes here
    }
  }
}
