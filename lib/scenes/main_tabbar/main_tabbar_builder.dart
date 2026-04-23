import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/main_tabbar/main_tabbar_page.dart';
import 'package:coffee_bean/scenes/main_tabbar/main_tabbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class MainTabbarBuildable implements DbNoteBuildable {
  @override
  Widget build();
}

class MainTabbarBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable, MainTabbarBuildable {
  @override
  Widget build() {
    final provider = MainTabbarProvider(this);
    final page = MainTabbarPage();
    
    rootPage = ChangeNotifierProvider<MainTabbarProvider>.value(
      value: provider,
      child: page,
    );
    return rootPage;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // TODO: implement navigate
  }
}
