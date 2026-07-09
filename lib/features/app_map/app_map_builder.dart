import 'package:coffee_bean/data/map_provider/app_map_contract.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/features/app_map/interactor/app_map_interactor.dart';
import 'package:coffee_bean/features/app_map/interactor/app_map_page.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

class AppMapRouter extends DbNoteRouter {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {

  }
}


class AppMapBuilder extends DbNoteBuilder<AppMapRouter> {
  final MapMarker marker;

  AppMapBuilder(this.marker);

  @override
  AppMapRouter build() {
    final router = AppMapRouter();
    final interactor = AppMapInteractor(marker, router);
    final page = AppMapPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
