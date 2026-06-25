import 'package:coffee_bean/scenes/event_features/activity_detail/activity_detail_builder.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/interactor/activity_list_interactor.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/interactor/activity_list_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';


// ROUTE
abstract class ActivityListFirstRoute implements DbNoteRoute {}

// ROUTABLE
abstract class ActivityListRoutable implements DbNoteRoutable {
  void gotoActivityDetail(int activityId);
}

// -- ROUTER --
class ActivityListRouter extends DbNoteRouter implements ActivityListRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}

  @override
  void gotoActivityDetail(int activityId) {
    final builder = ActivityDetailBuilder(activityId);
    final router = builder.build();
    navigator.push(router.viewController);
  }
}

// -- BUILDER --
// -- BUILDER --
class ActivityListBuilder extends DbNoteBuilder<ActivityListRouter> {
  @override
  ActivityListRouter build() {
    final router = ActivityListRouter();
    final interactor = ActivityListInteractor(router);
    final page = ActivityListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}