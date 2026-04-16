/*
 * Created with IntelliJ IDEA
 * Package: commons
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 28/06/2022 - 10:35
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

mixin class DbNavigator {

  // Dùng static để tất cả các Router đều dùng chung một cổng điều hướng
  static final GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();

  /// Hàm Push: Thêm tùy chọn đặt tên (routeName)
  void push(Widget widget, {BuildContext? fromContext, String? routeName, PageTransitionType transitionType = PageTransitionType.rightToLeft}) {
    final state = navigatorState.currentState;
    // Tạo Route với định danh
    final route = PageTransition(child: widget, type: transitionType, settings: RouteSettings(name: routeName),);
    if (state != null) {
      state.push(route);
    } else if (fromContext != null && fromContext.mounted) {
      Navigator.push(fromContext, route);
    }
  }

  void pushSameRootPage(Widget widget, {BuildContext? fromContext, String? routeName, PageTransitionType transitionType = PageTransitionType.rightToLeft}) {
    final state = navigatorState.currentState;
    // Tạo Route với định danh
    final route = PageTransition(child: widget, type: transitionType, settings: RouteSettings(name: routeName),);
    if (state != null) {
      state.pushAndRemoveUntil(route, (route) => false);
    } else if (fromContext != null && fromContext.mounted) {
      Navigator.pushAndRemoveUntil(fromContext, route, (route) => false);
    }
  }

  /// Hàm Pop: Thêm khả năng quay về một trang cụ thể theo tên
  void pop({BuildContext? fromContext, String? untilRouteName}) {
    final state = navigatorState.currentState;
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

  /// Hàm đặc biệt: Quay về trang nằm ngay trước trang [targetRouteName]
  /// Giúp thoát hoàn toàn một luồng (flow) mà không cần biết tên trang gốc.
  void popUntilBefore(String targetRouteName, {BuildContext? fromContext}) {
    final state = navigatorState.currentState;
    bool foundTarget = false;

    // Make function do pop until
    bool funcPop(route, targetRouteName) {
      if (route.settings.name == targetRouteName) {
        foundTarget = true;
        return false; // Tiếp tục xóa trang này để xuống trang bên dưới
      }
      if (foundTarget) {
        return true; // Dừng lại tại trang này
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


// https://stackoverflow.com/questions/46259751/how-to-push-multiple-routes-with-flutter-navigator
class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({ required WidgetBuilder builder }) : super(builder: builder);

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}

extension PushWithoutAnimation on Navigator {

  // Dung thang nay de push nhieu Page vao router, dung tao 1 line back app
  static Future pushWithoutAnimation(BuildContext context, Widget page) {
    Route route = NoAnimationPageRoute(builder: (BuildContext context) => page);
    return Navigator.of(context).push(route);
  }

  // Future pushWithoutAnimation(BuildContext fromContext, Widget page) {
  //   Route route = NoAnimationPageRoute(builder: (BuildContext context) => page);
  //   return this.push(context, route);
  // }

}