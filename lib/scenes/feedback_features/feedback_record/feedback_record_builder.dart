import 'package:coffee_bean/scenes/feedback_features/feedback_detail/feedback_detail_builder.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_record/interactor/feedback_record_interactor.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_record/interactor/feedback_record_page.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';


class FeedbackDetailRoute implements DbNoteRoute {
  final int feedbackId;
  FeedbackDetailRoute(this.feedbackId);
}

abstract class FeedbackRecordRoutable implements DbNoteRoutable {}



// ROUTER
class FeedbackRecordRouter extends DbNoteRouter implements FeedbackRecordRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is FeedbackDetailRoute) {
      final builder = FeedbackDetailBuilder(feedbackId: toRoute.feedbackId).build();
      push(builder.viewController);
    }
  }
}

// BUILDER
class FeedbackRecordBuilder extends DbNoteBuilder<FeedbackRecordRouter> {
  @override
  FeedbackRecordRouter build() {
    final router = FeedbackRecordRouter();
    final interactor = FeedbackRecordInteractor(router);
    final page = FeedbackRecordPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
