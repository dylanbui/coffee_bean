/*
 * Created with IntelliJ IDEA
 * Package: login_scene.splash_start
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 11:23
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/splash_start/splash_start_page.dart';
import 'package:coffee_bean/scenes/splash_start/splash_start_provider.dart';


// Listener
abstract interface class SplashStartListener {
  void splashPageComplete(String? message);
}

// Buildable
abstract interface class SplashStartBuildable implements DbNoteBuildable {

  Widget build();
  Widget buildWithAny(String param_1, int param_2);
  Widget buildWithListener(SplashStartListener listener);

}

// Router
class SplashPageCompleteRoute implements DbNoteRoute {
  String? message;
  SplashPageCompleteRoute({this.message});
}

// Builder

class SplashStartBuilder extends DbNoteBuilder with DbNoteRouter implements SplashStartBuildable {

  SplashStartListener? listener;

  @override
  Widget build() {
    var splashStartPage = SplashStartPage(router: this,);
    rootPage = ChangeNotifierProvider<SplashStartProvider>.value(value: SplashStartProvider(), child: splashStartPage,);
    return rootPage;
  }

  @override
  Widget buildWithAny(String param_1, int param_2) {
    var splashStartPage = SplashStartPage(router: this,);
    rootPage = ChangeNotifierProvider<SplashStartProvider>.value(value: SplashStartProvider(), child: splashStartPage,);
    return rootPage;
  }

  @override
  Widget buildWithListener(SplashStartListener listener) {
    this.listener = listener;
    var splashStartPage = SplashStartPage(router: this,);
    rootPage = ChangeNotifierProvider<SplashStartProvider>.value(value: SplashStartProvider(), child: splashStartPage,);
    return rootPage;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is SplashPageCompleteRoute) {
      listener?.splashPageComplete(toRoute.message);
      // parentRouter?.goiLenParentRouter();
    }
  }

}