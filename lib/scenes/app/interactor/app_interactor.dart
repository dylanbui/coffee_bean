import 'dart:async';

import 'package:coffee_bean/core/architecture_ribs/note_interactor.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/core/utils/locator.dart';
import 'package:coffee_bean/core/utils/logger.dart';
import 'package:coffee_bean/config/app_config.dart';
import 'package:coffee_bean/scenes/app/app_router.dart';
import 'package:coffee_bean/scenes/app/interactor/deep_link_service.dart';

/// The State for the AppInteractor.
abstract class AppInteractorState extends BaseBlocState {}

class AppInteractorInitial extends AppInteractorState {}

/// The Interactor for the root of the application.
/// It contains business logic for bootstrapping, session management, and deep linking.
class AppInteractor extends DbNoteInteractor<AppRouter> {
  final DeepLinkService _deepLinkService = locator.get<DeepLinkService>();
  StreamSubscription? _deepLinkSubscription;

  AppInteractor({required AppRouter router}) {
    this.router = router;
  }

  // @override
  // void onDidBecomeActive() {
  //   super.onDidBecomeActive();
  //   // Initialize and listen for deep links as soon as the app starts.
  //   _deepLinkService.init();
  //   _listenForDeepLinks();
  // }
  //
  // @override
  // void onWillResignActive() {
  //   _deepLinkSubscription?.cancel();
  //   _deepLinkService.dispose();
  //   super.onWillResignActive();
  // }

  /// Called by the AppBuilder when the splash screen is finished.
  Future<void> bootstrap() async {
    dLog("AppInteractor: Bootstrapping application...");

    // --- Phase 1: Load Critical Data ---
    // For example: Checking login status, fetching remote config.
    if (AppConfig().currentUser?.isLogin() ?? false) {
      dLog("AppInteractor: User is logged in. Navigating to Main App.");
    } else {
      dLog("AppInteractor: User is not logged in. Navigating to Login flow.");
    }

    // Giả lập xử lý load bootstrap 3s
    await Future.delayed(const Duration(seconds: 3));
    router?.successSyncDataFormServer();
  }

  void _listenForDeepLinks() {
    // _deepLinkSubscription = _deepLinkService.routeStream.listen((route) {
    //   dLog("AppInteractor: Received deep link route: ${route.runtimeType}");
    //   // Delegate the navigation action to the router.
    //   router.navigate(route);
    // });
  }
}
