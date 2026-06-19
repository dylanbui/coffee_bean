import 'package:coffee_bean/scenes/my_profile_features/change_mobile/interactor/change_mobile_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/change_mobile/interactor/change_mobile_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class ChangeMobileRoutable implements DbNoteRoutable {}

class ChangeMobileRouter extends DbNoteRouter implements ChangeMobileRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {

  }
}

class ChangeMobileBuilder extends DbNoteBuilder<ChangeMobileRouter> {
  @override
  ChangeMobileRouter build() {
    final router = ChangeMobileRouter();
    final interactor = ChangeMobileInteractor(router);
    final page = ChangeMobilePage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
