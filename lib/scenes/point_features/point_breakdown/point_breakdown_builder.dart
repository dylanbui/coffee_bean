import 'package:coffee_bean/scenes/point_features/point_breakdown/interactor/point_breakdown_interactor.dart';
import 'package:coffee_bean/scenes/point_features/point_breakdown/interactor/point_breakdown_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

// ROUTE
abstract class PointBreakdownFirstRoute implements DbNoteRoute {}

// ROUTABLE
abstract class PointBreakdownRoutable implements DbNoteRoutable {}

// -- ROUTER --
class PointBreakdownRouter extends DbNoteRouter implements PointBreakdownRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}
}


// -- BUILDER --
class PointBreakdownBuilder extends DbNoteBuilder<PointBreakdownRouter> {
  @override
  PointBreakdownRouter build() {
    final router = PointBreakdownRouter();
    final interactor = PointBreakdownInteractor(router);
    final page = PointBreakdownPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
