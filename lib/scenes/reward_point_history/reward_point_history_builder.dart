import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/reward_point_history/interactor/reward_point_history_interactor.dart';
import 'package:coffee_bean/scenes/reward_point_history/interactor/reward_point_history_page.dart';
import 'package:flutter/material.dart';

// ROUTE
abstract class RewardPointHistoryFirstRoute implements DbNoteRoute {}

// ROUTABLE
abstract class RewardPointHistoryRoutable implements DbNoteRoutable {}

// -- ROUTER --
class RewardPointHistoryRouter extends DbNoteRouter implements RewardPointHistoryRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}
}


// -- BUILDER --
class RewardPointHistoryBuilder extends DbNoteBuilder<RewardPointHistoryRouter> {
  @override
  RewardPointHistoryRouter build() {
    final router = RewardPointHistoryRouter();
    final interactor = RewardPointHistoryInteractor(router);
    final page = RewardPointHistoryPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
