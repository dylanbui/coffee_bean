import 'package:coffee_bean/scenes/announcement_detail/announcement_detail_builder.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_page.dart';
import 'package:coffee_bean/scenes/course_features/course_list/course_list_builder.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/activity_list_builder.dart';
import 'package:coffee_bean/scenes/point_features/my_point_list/my_point_list_builder.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/reservation_list_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/global_search/global_search_builder.dart';
import 'package:coffee_bean/scenes/store_list/store_list_builder.dart';
import 'package:flutter/material.dart';

// Route
class ChooseStoreRoute implements DbNoteRoute {}
class GlobalSearchRoute implements DbNoteRoute {}
class ReservationListRoute implements DbNoteRoute {}
class CourseListRoute implements DbNoteRoute {}
class ActivityListRoute implements DbNoteRoute {}
class MyPointListRoute implements DbNoteRoute {}

abstract class HomeRoutable implements DbNoteRoutable {}

// ROUTER
class HomeRouter extends DbNoteRouter implements HomeRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ChooseStoreRoute) {
      final nextBuilder = StoreListBuilder();
      final nextRouter = nextBuilder.build();
      push(nextRouter.viewController);

    } else if (toRoute is GlobalSearchRoute) {
      final nextBuilder = GlobalSearchBuilder();
      final nextRouter = nextBuilder.build();
      push(nextRouter.viewController);

    } else if (toRoute is ReservationListRoute) {
      final nextBuilder = ReservationListBuilder();
      push(nextBuilder.build().viewController);

    } else if (toRoute is CourseListRoute) {
      final nextBuilder = CourseListBuilder();
      push(nextBuilder.build().viewController);

    } else if (toRoute is ActivityListRoute) {
      final nextBuilder = ActivityListBuilder();
      push(nextBuilder.build().viewController);

    } else if (toRoute is MyPointListRoute) {
      final nextBuilder = MyPointListBuilder();
      push(nextBuilder.build().viewController);

    } else if (toRoute is AnnouncementDetailRoute) {
      final nextBuilder = AnnouncementDetailBuilder(toRoute.announcementId);
      final nextRouter = nextBuilder.build();
      push(nextRouter.viewController);
    }
  }
}


// BUILDER
class HomeBuilder extends DbNoteBuilder<HomeRouter> {
  @override
  HomeRouter build() {
    final router = HomeRouter();
    final interactor = HomeInteractor(router);
    final page = HomePage(interactor: interactor);
    router.attach(interactor, page);
    // Set showAppBar nếu cần thiết (giống product_list_builder)
    // page.showAppBar = showAppBarOnRootPage;

    return router;
  }
}
