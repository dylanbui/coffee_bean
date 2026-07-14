import 'package:coffee_bean/scenes/posts_features/post_by_topic_list/interactor/post_by_topic_list_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_by_topic_list/interactor/post_by_topic_list_page.dart';
import 'package:coffee_bean/scenes/posts_features/post_detail/post_detail_builder.dart';
import 'package:db_core/db_core.dart';

abstract class PostByTopicListRoutable implements DbNoteRoutable {
  void pushPostDetail(int postId);
}

class PostByTopicListRouter extends DbNoteRouter implements PostByTopicListRoutable {

  @override
  void pushPostDetail(int postId) {
    final builder = PostDetailBuilder(postId: postId);
    push(builder.build().viewController);
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
