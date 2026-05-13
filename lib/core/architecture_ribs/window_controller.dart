/*
 * Created with IntelliJ IDEA
 * Package:
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 15/08/2022 - 11:06
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:flutter/material.dart';

/// The [WindowController] serves as the high-level routing system for the RIBs architecture.
/// It manages both the root view of the application and the presentation of overlay flows.
///
/// ### Usage 1: Managing the Root View
/// Use [launch] to completely replace the root screen without using the Navigator stack.
/// Ideal for switching major modules (e.g., Splash -> Login -> Home).
/// ```dart
/// final windowController = WindowController();
/// windowController.launch(homeView);
/// ```
/// Note: The [Window] widget must be set as the `home` of your `MaterialApp`.
///
/// ### Usage 2: Managing Overlay Flows (Modals)
/// Use [present] to push an entire flow (e.g., Create Order Flow) on top of the current screen.
/// Use [dismiss] to pop all screens within that flow until the specific flow is removed.
/// ```dart
/// // Open the flow
/// WindowController.present(orderFlowView);
/// // Close the flow completely
/// WindowController.dismiss(orderFlowView);
/// ```
class WindowController {
  static final _navigator = GlobalKey<NavigatorState>();

  /// Pushes this view to the top of the [Navigator] stack
  static Future<void> present(ViewControllable viewControllable) async {
    _navigator.currentState?.push(
      MaterialPageRoute(
        builder: (context) => viewControllable,
        settings: RouteSettings(arguments: viewControllable),
      ),
    );
  }

  static void dismiss(ViewControllable viewControllable) {
    Route? previousRoute;
    _navigator.currentState?.popUntil((route) {
      final result = previousRoute?.settings.arguments == viewControllable;
      previousRoute = route;
      return result;
    });
  }

  // Initialize ValueNotifier properly to hold the root view
  final ValueNotifier<ViewControllable?> _currentView = ValueNotifier<ViewControllable?>(null);

  ValueNotifier<ViewControllable?> get currentView => _currentView;

  void launch(ViewControllable? view) {
    _currentView.value = view;
  }
}

/// The root Window class for launching [ViewControllable]
class Window extends StatelessWidget {
  const Window(this.controller, {super.key});

  final WindowController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ViewControllable?>(
      valueListenable: controller.currentView,
      builder: (context, value, child) {
        // Safely cast to Widget, show an empty box if value is null
        return (value as Widget?) ?? const SizedBox.shrink();
      },
    );
  }
}
