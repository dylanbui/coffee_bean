import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_evaluation/interactor/course_order_evaluation_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_evaluation/interactor/course_order_evaluation_page.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/models/course_order_detail_model.dart';
import 'package:flutter/material.dart';

abstract class CourseOrderEvaluationRoutable implements DbNoteRoutable {}

class CourseOrderEvaluationRouter extends DbNoteRouter implements CourseOrderEvaluationRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}
}

class CourseOrderEvaluationBuilder extends DbNoteBuilder<CourseOrderEvaluationRouter> {
  final int orderId;
  final CourseOrderDetailModel? orderData;

  CourseOrderEvaluationBuilder(this.orderId, this.orderData);

  @override
  CourseOrderEvaluationRouter build() {
    final router = CourseOrderEvaluationRouter();
    final interactor = CourseOrderEvaluationInteractor(router, orderId, orderData);
    final page = CourseOrderEvaluationPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
