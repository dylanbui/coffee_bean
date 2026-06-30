import 'package:coffee_bean/scenes/announcement_detail/interactor/announcement_detail_interactor.dart';
import 'package:coffee_bean/scenes/announcement_detail/interactor/announcement_detail_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';


class AnnouncementDetailRoute implements DbNoteRoute {
  final int announcementId;
  AnnouncementDetailRoute(this.announcementId);
}

abstract class AnnouncementDetailRoutable implements DbNoteRoutable {}

// ROUTER
class AnnouncementDetailRouter extends DbNoteRouter implements AnnouncementDetailRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  }
}

// BUILDER
class AnnouncementDetailBuilder extends DbNoteBuilder<AnnouncementDetailRouter> {
  final int announcementId;

  AnnouncementDetailBuilder(this.announcementId);

  @override
  AnnouncementDetailRouter build() {
    final router = AnnouncementDetailRouter();
    final interactor = AnnouncementDetailInteractor(router, announcementId: announcementId);
    final page = AnnouncementDetailPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
