/*
 * Created with IntelliJ IDEA
 * Package: commons
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 28/06/2022 - 10:35
 */

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// DbNavigator: A utility class for handling navigation logic within the RIBs architecture.
/// 
/// It encapsulates the Flutter Navigator API and provides support for named routes, 
/// custom transitions, and complex stack manipulations like `popUntilBefore`.
///
/// ### Usage:
/// ```dart
/// final navigator = DbNavigator(navigatorStateKey);
/// navigator.push(MyWidget(), routeName: 'my_route');
/// navigator.pop();
/// ```
class DbNavigator {

  /// Static global key to provide a default navigator state across all Routers.
  static final GlobalKey<NavigatorState> globalNavigatorState = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> _navigatorState;

  DbNavigator(this._navigatorState);

  /// Pushes a [widget] onto the navigator stack.
  /// 
  /// [routeName]: Optional name for the route, useful for stack manipulation.
  /// [transitionType]: Custom page transition animation (default: rightToLeft).
  void push(Widget widget, {BuildContext? fromContext, String? routeName, PageTransitionType transitionType = PageTransitionType.rightToLeft}) {
    final state = _navigatorState.currentState;
    final route = PageTransition(child: widget, type: transitionType, settings: RouteSettings(name: routeName),);
    if (state != null) {
      state.push(route);
    } else if (fromContext != null && fromContext.mounted) {
      Navigator.push(fromContext, route);
    }
  }

  /// Pushes a [widget] and removes all previous routes.
  void pushSameRootPage(Widget widget, {BuildContext? fromContext, String? routeName, PageTransitionType transitionType = PageTransitionType.rightToLeft}) {
    final state = _navigatorState.currentState;
    final route = PageTransition(child: widget, type: transitionType, settings: RouteSettings(name: routeName),);
    if (state != null) {
      state.pushAndRemoveUntil(route, (route) => false);
    } else if (fromContext != null && fromContext.mounted) {
      Navigator.pushAndRemoveUntil(fromContext, route, (route) => false);
    }
  }

  /// Pops the top route from the navigator.
  /// 
  /// [untilRouteName]: If provided, pops until the route with this name is found.
  void pop({BuildContext? fromContext, String? untilRouteName}) {
    final state = _navigatorState.currentState;
    if (state != null) {
      if (untilRouteName != null) {
        // Nếu có tên, quay về cho đến khi gặp trang đó
        state.popUntil(ModalRoute.withName(untilRouteName));
      } else {
        // Nếu không có tên, chỉ pop 1 trang như bình thường
        if (state.canPop()) {
          state.pop();
        }
      }
    } else if (fromContext != null && fromContext.mounted) {
      if (untilRouteName != null) {
        Navigator.popUntil(fromContext, ModalRoute.withName(untilRouteName));
      } else {
        if (Navigator.of(fromContext).canPop()) {
          Navigator.pop(fromContext);
        }
      }
    }
  }

  /// Pops all routes until the route immediately BEFORE the [targetRouteName].
  /// 
  /// This is particularly useful for exiting an entire business flow without
  /// knowing the specific name of the root page.
  void popUntilBefore(String targetRouteName, {BuildContext? fromContext}) {
    final state = _navigatorState.currentState;
    bool foundTarget = false;

    // Make function do pop until
    bool funcPop(route, targetRouteName) {
      if (route.settings.name == targetRouteName) {
        foundTarget = true;
        return false; // Remove the target route
      }
      if (foundTarget) {
        return true; // Stop at the route before the target
      }
      return false;
    }

    if (state != null) {
      state.popUntil((route) => funcPop(route, targetRouteName));
    } else if (fromContext != null && fromContext.mounted) {
      Navigator.popUntil(fromContext, (route) => funcPop(route, targetRouteName));
    }


    //   state.popUntil((route) {
    //     // 1. Nếu tìm thấy trang mục tiêu (ví dụ: 'make_product')
    //     if (route.settings.name == targetRouteName) {
    //       foundTarget = true;
    //       return false; // Tiếp tục xóa trang này để xuống trang bên dưới
    //     }
    //     // 2. Sau khi đã tìm thấy và xóa target, trang tiếp theo chính là đích đến
    //     if (foundTarget) {
    //       return true; // Dừng lại tại trang này
    //     }
    //     // 3. Nếu chưa thấy target, cứ tiếp tục xóa (pop)
    //     return false;
    //   });
    // }

  }
}

/// A standard MaterialPageRoute without any entry/exit animations.
class _NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  _NoAnimationPageRoute({ required super.builder, super.settings });

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}

/// Extension for complex navigation patterns like pushing multiple pages at once.
extension DbNavigatorMultiple on DbNavigator {

  /// Pushes multiple [widgets] onto the navigator stack.
  /// 
  /// All widgets except the last one are pushed without animation using [_NoAnimationPageRoute].
  /// The last widget is pushed with the specified [transitionType] and standard animation.
  /// 
  /// This is particularly useful for deep-linking scenarios (e.g., from a Notification)
  /// where you want to build a navigation stack [List -> Detail] in one go.
  /// 
  /// ### Example:
  /// ```dart
  /// // When receiving a notification for a specific product
  /// navigator.pushMultiple([
  ///   ProductListWidget(),
  ///   ProductDetailWidget(productId: '123'),
  /// ], transitionType: PageTransitionType.rightToLeft);
  /// ```
  /// The user will see the ProductDetailWidget trandition in, and pressing 'Back' 
  /// will reveal the ProductListWidget already loaded underneath.
  void pushMultiple(List<Widget> widgets, {PageTransitionType transitionType = PageTransitionType.rightToLeft}) {
    final state = _navigatorState.currentState;
    if (state == null || widgets.isEmpty) return;

    if (widgets.length == 1) {
      push(widgets.first, transitionType: transitionType);
      return;
    }

    // 1. Push all pages except the last one without animation
    for (int i = 0; i < widgets.length - 1; i++) {
      state.push(_NoAnimationPageRoute(builder: (_) => widgets[i]));
    }

    // 2. Push the last page with standard animation using existing push method
    push(widgets.last, transitionType: transitionType);
  }
}
