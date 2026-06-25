// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: course_list_builder.dart
// Author: dylanbui
// Create Date: 2026-06-09
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/scenes/course_features/course_detail/course_detail_builder.dart';
import 'package:coffee_bean/scenes/course_features/course_list/interactor/course_list_interactor.dart';
import 'package:coffee_bean/scenes/course_features/course_list/interactor/course_list_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

// ROUTE
class CourseDetailRoute implements DbNoteRoute {
  final int courseId;
  CourseDetailRoute(this.courseId);
}

// ROUTABLE
abstract class CourseListRoutable implements DbNoteRoutable {}

// -- ROUTER --
class CourseListRouter extends DbNoteRouter implements CourseListRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is CourseDetailRoute) {
      final builder = CourseDetailBuilder(toRoute.courseId);
      final router = builder.build();
      navigator.push(router.viewController);
    }
  }

}


// -- BUILDER --
class CourseListBuilder extends DbNoteBuilder<CourseListRouter> {
  @override
  CourseListRouter build() {
    final router = CourseListRouter();
    final interactor = CourseListInteractor(router);
    final page = CourseListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
