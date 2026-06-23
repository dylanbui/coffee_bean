import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/store_list/interactor/store_list_interactor.dart';
import 'package:coffee_bean/scenes/store_list/interactor/store_list_page.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class StoreListRoutable implements DbNoteRoutable {}

class StoreListRouter extends DbNoteRouter implements StoreListRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Handle navigation to other scenes
  }
}


class StoreListBuilder extends DbNoteBuilder<StoreListRouter> {
  @override
  StoreListRouter build() {
    final router = StoreListRouter();
    final interactor = StoreListInteractor(router);
    final page = StoreListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
