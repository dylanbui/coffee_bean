import 'dart:async';

import 'package:coffee_bean/commons/architecture_ribs/note_interactor.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/utils/locator.dart';
import 'package:coffee_bean/commons/utils/logger.dart';
import 'package:coffee_bean/config/app_config.dart';
import 'package:coffee_bean/scenes/app/interactor/deep_link_service.dart';


/// The Interactor for the root of the application.
/// It contains business logic for bootstrapping, session management, and deep linking.
class AppInteractor implements DbNoteInteractable {
  final DbNoteRoutable router;
  final DeepLinkService _deepLinkService = locator.get<DeepLinkService>();
  StreamSubscription? _deepLinkSubscription;

  AppInteractor({required this.router}) {
    // Initialize and listen for deep links as soon as the app starts.
    _deepLinkService.init();
    _listenForDeepLinks();
  }

  /// Called by the AppBuilder when the splash screen is finished.
  Future<void> bootstrap() async {
    dLog("AppInteractor: Bootstrapping application...");

    // --- Phase 1: Load Critical Data ---
    // For example: Checking login status, fetching remote config.
    if (AppConfig().currentUser?.isLogin() ?? false) {
      dLog("AppInteractor: User is logged in. Navigating to Main App.");
      // The router is expected to know how to perform this navigation.
      // We cast to `dynamic` to call a method specific to the AppBuilder.
      // router.navigate(toRoute);
    } else {
      dLog("AppInteractor: User is not logged in. Navigating to Login flow.");
      // For demo purposes, we navigate to the main app. In a real app, you'd navigate to a login flow.
      // router.navigate(toRoute);
    }
  }

  void _listenForDeepLinks() {
    _deepLinkSubscription = _deepLinkService.routeStream.listen((route) {
      dLog("AppInteractor: Received deep link route: ${route.runtimeType}");
      // Delegate the navigation action to the router.
      router.navigate(route);
    });
  }

  void dispose() {
    _deepLinkSubscription?.cancel();
    _deepLinkService.dispose();
  }
}
