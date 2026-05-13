/*
 * Created with IntelliJ IDEA
 * Package: login_scene.splash_start
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 11:23
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/navigator.dart';
import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/rib_samples/splash_start/splash_start_page.dart';
import 'package:coffee_bean/scenes/rib_samples/splash_start/splash_start_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Listener
// User Listener để nhận callback từ builder, khi có sự kiện gì đó xảy ra trong builder thì sẽ gọi listener để thông báo cho bên ngoài biết
abstract interface class SplashStartListener {
  void splashPageComplete(String? message);
}

// Buildable
abstract interface class SplashStartBuildable implements DbNoteBuildable {

  ViewController buildWithAny(String param_1, int param_2);
  ViewController buildWithListener(SplashStartListener listener);

}

// Router
class SplashPageCompleteRoute implements DbNoteRoute {
  String? message;
  SplashPageCompleteRoute({this.message});
}

// Builder

class SplashStartBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable, SplashStartBuildable {

  SplashStartListener? listener;

  @override
  ViewController buildFactory() {
    var splashStartPage = SplashStartPage();
    return ChangeNotifierProvider<SplashStartProvider>.value(value: SplashStartProvider(this), child: splashStartPage,);
  }

  @override
  ViewController buildWithAny(String param_1, int param_2) {
    return build();
  }

  @override
  ViewController buildWithListener(SplashStartListener listener) {
    this.listener = listener;
    return build();
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is SplashPageCompleteRoute) {
      listener?.splashPageComplete(toRoute.message);
      // parentRouter?.goiLenParentRouter();
    }
  }

}