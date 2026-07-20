import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/interactor/main_tabbar_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/interactor/main_tabbar_page.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class MainTabbarRoutable implements DbNoteRoutable {}

class MainTabbarRouter extends DbNoteRouter implements MainTabbarRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Implement navigation logic if needed
  }
}


class MainTabbarBuilder extends DbNoteBuilder<MainTabbarRouter> {
  @override
  MainTabbarRouter build() {
    final router = MainTabbarRouter();
    final interactor = MainTabbarInteractor(router);
    final page = MainTabbarPage(interactor: interactor);

    router.attach(interactor, page);
    // Thay đổi dòng router.attach
    // router.attach(interactor, BlocProvider.value(value: interactor, child: page));

    return router;
  }
}
