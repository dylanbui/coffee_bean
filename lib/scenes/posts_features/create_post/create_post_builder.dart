import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/topic_selection_builder.dart';
import 'package:coffee_bean/scenes/posts_features/create_post/interactor/create_post_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/create_post/interactor/create_post_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';


// ROUTER
abstract interface class CreatePostRoutable implements DbNoteRoutable {
  void pushTopicSelection(TopicSelectionListener listener);
}

class CreatePostRouter extends DbNoteRouter implements CreatePostRoutable {
  @override
  void pushTopicSelection(TopicSelectionListener listener) {
    final builder = TopicSelectionBuilder(listener: listener);
    push(builder.build().viewController);
  }
}

// BUILDER
class CreatePostBuilder extends DbNoteBuilder<CreatePostRouter> {

  @override
  CreatePostRouter build() {
    final router = CreatePostRouter();
    final interactor = CreatePostInteractor(router);
    final page = CreatePostPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }

}
