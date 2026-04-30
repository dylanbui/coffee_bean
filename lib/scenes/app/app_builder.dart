import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/commons/utils/logger.dart';
import 'package:coffee_bean/scenes/app/app_routes.dart';
import 'package:coffee_bean/scenes/app/interactor/app_interactor.dart';
import 'package:coffee_bean/scenes/problem_report/problem_report_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/splash_start/splash_start_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/user_detail_builder.dart';
import 'package:flutter/material.dart';

// Buildable
abstract class AppBuildable implements DbNoteBuildable {}

/// AppBuilder acts as a "Root Coordinator" or "Root Router".
/// Its main responsibility is to coordinate the main application flows (e.g., Splash, Auth, Main)
/// and initialize global services.
class AppBuilder extends DbNoteBuilder with DbNavigator implements AppBuildable, DbNoteRoutable, SplashStartListener {
  late final AppInteractor interactor;

  @override
  ViewController build() {
    // 1. Create the Interactor, which contains the application's root-level business logic.
    //    We pass `this` builder to act as the router.
    interactor = AppInteractor(router: this);
    // Call sync function
    interactor.bootstrap();

    // 2. Build the initial UI, which is the Splash screen.
    //    The Interactor will be notified when the splash screen completes.
    // AppBuilder will listen for the event when Splash completes.
    final SplashStartBuildable splashStartBuilder = SplashStartBuilder();
    rootPage = splashStartBuilder.buildWithListener(this);
    return rootPage;
  }

  @override
  void splashPageComplete(String? message) async {
    // 3. Delegate the completion event to the Interactor to handle the bootstrap logic.
    // await interactor.bootstrap();
    ProblemReportBuilder problemReportBuilder = ProblemReportBuilder();
    pushSameRootPage(problemReportBuilder.build());
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
