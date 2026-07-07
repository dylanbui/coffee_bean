/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 29/4/26 - 16:15
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/feedback_features/feedback_record/feedback_record_builder.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/feedback_features/send_feedback/interactor/send_feedback_interactor.dart';
import 'package:coffee_bean/scenes/feedback_features/send_feedback/interactor/send_feedback_page.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';


// Route
class SendFeedbackDoneRoute implements DbNoteRoute {
    int feedbackId;
    SendFeedbackDoneRoute(this.feedbackId);
}

class FeedbackRecordRoute implements DbNoteRoute {}

abstract class SendFeedbackRoutable implements DbNoteRoutable {}

// Router
class SendFeedbackRouter extends DbNoteRouter implements SendFeedbackRoutable {

    @override
    void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
        if (toRoute is SendFeedbackDoneRoute) {
            // Implementation for navigating to or within Product Detail
        } else if (toRoute is FeedbackRecordRoute) {
            final builder = FeedbackRecordBuilder().build();
            push(builder.viewController);
        }
    }

}

class SendFeedbackBuilder extends DbNoteBuilder<SendFeedbackRouter> {
    @override
    SendFeedbackRouter build() {
        final router = SendFeedbackRouter();
        final interactor = SendFeedbackInteractor(router);
        final page = SendFeedbackPage(interactor: interactor);
        router.attach(interactor, page);
        return router;
    }
}
