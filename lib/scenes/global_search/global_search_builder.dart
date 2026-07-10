/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 12/5/26 - 16:03
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/global_search/interactor/global_search_interactor.dart';
import 'package:coffee_bean/scenes/global_search/interactor/global_search_page.dart';

// --- ROUTABLE ---
abstract class GlobalSearchRoutable implements DbNoteRoutable {
}

// --- ROUTE ---
class GlobalSearchRoute implements DbNoteRoute {
  final int id;
  GlobalSearchRoute(this.id);
}

// --- ROUTER ---
class GlobalSearchRouter extends DbNoteRouter implements GlobalSearchRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is GlobalSearchRoute) {
      // Implementation for navigating to or within GlobalSearch
    }
  }
}

// --- BUILDABLE ---
abstract class GlobalSearchBuildable implements DbNoteBuildable {
  GlobalSearchRouter build();
}

// --- BUILDER ---
class GlobalSearchBuilder extends DbNoteBuilder<GlobalSearchRouter> implements GlobalSearchBuildable {

  @override
  GlobalSearchRouter build() {
    final router = GlobalSearchRouter();
    final interactor = GlobalSearchInteractor(router);
    final page = GlobalSearchPage(interactor: interactor);

    router.attach(interactor, page);

    return router;
  }

}
