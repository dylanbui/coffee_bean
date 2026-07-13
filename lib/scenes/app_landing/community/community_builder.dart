import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class CommunityRoutable implements DbNoteRoutable {
  void openSearch();
}

class CommunityRouter extends DbNoteRouter implements CommunityRoutable {
  @override
  void openSearch() {
    debugPrint("Navigate to Search Page");
  }
}

class CommunityBuilder extends DbNoteBuilder<CommunityRouter> {
  @override
  CommunityRouter build() {
    final router = CommunityRouter();
    final interactor = CommunityInteractor(router);
    final page = CommunityPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
