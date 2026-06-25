import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/course_features/course_detail/interactor/course_detail_interactor.dart';
import 'package:coffee_bean/scenes/course_features/course_detail/interactor/course_detail_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

// ROUTER
abstract class CourseDetailRoutable implements DbNoteRoutable {
  void gotoCommentList(int productId, int type);
}

class CourseDetailRouter extends DbNoteRouter implements CourseDetailRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}

  @override
  void gotoCommentList(int productId, int type) {
    final builder = CommentListBuilder(productId: productId, type: type);
    final router = builder.build();
    navigator.push(router.viewController);
  }
}

// BUILDER
class CourseDetailBuilder extends DbNoteBuilder<CourseDetailRouter> {
  final int courseId;

  CourseDetailBuilder(this.courseId);

  @override
  CourseDetailRouter build() {
    final router = CourseDetailRouter();
    final interactor = CourseDetailInteractor(router, courseId);
    final page = CourseDetailPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
