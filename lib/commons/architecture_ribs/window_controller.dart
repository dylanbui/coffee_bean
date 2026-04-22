/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 15/08/2022 - 11:06
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:flutter/material.dart';

/// The controller used for launching [ViewControllable]
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

  final _currentView = null; // ValueNotifier<ViewControllable>(null);

  ValueNotifier<ViewControllable> get currentView => _currentView;

  void launch(ViewControllable view) {
    _currentView.value = view;
  }
}

/// The root Window class for launching [ViewControllable]
class Window extends StatelessWidget {
  const Window(this.controller, {super.key});

  final WindowController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.currentView,
      builder: (context, value, child) {
        return value as Widget;
      },
    );
  }
}
