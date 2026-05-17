import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_page.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainTabbarBuilder extends DbNoteRouter implements DbNoteBuilder<MainTabbarBuilder> {
  @override
  MainTabbarBuilder build() {
    final provider = MainTabbarProvider(this);
    final page = MainTabbarPage();

    // Use RIBs attach to connect provider and view
    attach(provider, ChangeNotifierProvider<MainTabbarProvider>.value(
      value: provider, 
      child: page
    ));

    return this;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Implement navigation logic if needed
  }
}
