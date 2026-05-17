import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar_provider/main_tabbar_provider_page.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar_provider/main_tabbar_provider_interactor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainTabbarProviderBuilder extends DbNoteRouter implements DbNoteBuilder<MainTabbarProviderBuilder> {
  @override
  MainTabbarProviderBuilder build() {
    final provider = MainTabbarProviderInteractor(this);
    final page = MainTabbarProviderPage();

    // Use RIBs attach to connect provider and view
    attach(provider, ChangeNotifierProvider<MainTabbarProviderInteractor>.value(
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
