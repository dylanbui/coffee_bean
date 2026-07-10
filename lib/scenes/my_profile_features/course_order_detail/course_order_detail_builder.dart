import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/models/course_order_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/interactor/course_order_detail_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/interactor/course_order_detail_page.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_evaluation/course_order_evaluation_builder.dart';

abstract class CourseOrderDetailRoutable implements DbNoteRoutable {
  void openEvaluation(CourseOrderDetailModel order);
}

class CourseOrderDetailRouter extends DbNoteRouter implements CourseOrderDetailRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}

  @override
  void openEvaluation(CourseOrderDetailModel order) {
    final builder = CourseOrderEvaluationBuilder(order.id, order);
    push(builder.build().viewController);
  }
}

class CourseOrderDetailBuilder extends DbNoteBuilder<CourseOrderDetailRouter> {
  final int orderId;

  CourseOrderDetailBuilder(this.orderId);

  @override
  CourseOrderDetailRouter build() {
    final router = CourseOrderDetailRouter();
    final interactor = CourseOrderDetailInteractor(router, orderId);
    final page = CourseOrderDetailPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
