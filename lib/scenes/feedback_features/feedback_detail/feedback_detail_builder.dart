import 'package:coffee_bean/scenes/feedback_features/feedback_detail/interactor/feedback_detail_interactor.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_detail/interactor/feedback_detail_page.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

abstract class FeedbackDetailRoutable implements DbNoteRoutable {}

//ROUTER
class FeedbackDetailRouter extends DbNoteRouter implements FeedbackDetailRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  }
}

// BUILDER
class FeedbackDetailBuilder extends DbNoteBuilder<FeedbackDetailRouter> {
  final int feedbackId;
  FeedbackDetailBuilder({required this.feedbackId});

  @override
  FeedbackDetailRouter build() {
    final router = FeedbackDetailRouter();
    final interactor = FeedbackDetailInteractor(router, feedbackId: feedbackId);
    final page = FeedbackDetailPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }

}
