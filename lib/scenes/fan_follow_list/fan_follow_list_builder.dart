import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/fan_follow_list/interactor/fan_follow_list_interactor.dart';
import 'package:coffee_bean/scenes/fan_follow_list/interactor/fan_follow_list_page.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';


abstract class FanFollowListRoutable implements DbNoteRoutable {}

class FanFollowListRouter extends DbNoteRouter implements FanFollowListRoutable {

}

class FanFollowListBuilder extends DbNoteBuilder<FanFollowListRouter> {
  final int initialTabIndex;

  FanFollowListBuilder({this.initialTabIndex = 0});

  @override
  FanFollowListRouter build() {
    final router = FanFollowListRouter();
    final interactor = FanFollowListInteractor(router, initialTabIndex: initialTabIndex);
    final page = FanFollowListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
