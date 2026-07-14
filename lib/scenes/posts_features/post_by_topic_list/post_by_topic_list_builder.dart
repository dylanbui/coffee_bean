import 'package:coffee_bean/scenes/posts_features/post_by_topic_list/interactor/post_by_topic_list_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_by_topic_list/interactor/post_by_topic_list_page.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

class PostDetailRoute implements DbNoteRoute {
  PostDetailRoute({required int postId});
}

abstract class PostByTopicListRoutable implements DbNoteRoutable {}

class PostByTopicListRouter extends DbNoteRouter implements PostByTopicListRoutable {

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is PostDetailRoute) {

    }

  }
}

class PostByTopicListBuilder extends DbNoteBuilder<PostByTopicListRouter> {

  final int topicId;
  PostByTopicListBuilder(this.topicId);

  @override
  PostByTopicListRouter build() {
    final router = PostByTopicListRouter();
    final interactor = PostByTopicListInteractor(topicId: topicId, router);
    final page = PostByTopicListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}


