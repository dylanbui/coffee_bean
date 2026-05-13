import 'package:coffee_bean/core/architecture_ribs/navigator.dart';
import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_page.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class MainTabbarBuildable implements DbNoteBuildable { }

class MainTabbarBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable, MainTabbarBuildable {
  @override
  ViewController buildFactory() {
    final provider = MainTabbarProvider(this);
    final page = MainTabbarPage();

    return ChangeNotifierProvider<MainTabbarProvider>.value(value: provider, child: page);
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // TODO: implement navigate
  }
}
