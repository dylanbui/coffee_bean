import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/scenes/posts_features/post_detail/post_detail_builder.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/interactor/post_list_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/interactor/post_list_page.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/plugins/post_card_list/post_card_list_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/plugins/post_card_list/post_card_list_widget.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

abstract class PostListRoutable implements DbNoteRoutable {
  void openPostDetail(Post post);
}

class PostListRouter extends DbNoteRouter implements PostListRoutable {
  @override
  void openPostDetail(Post post) {
    push(PostDetailBuilder(postId: post.id).build().viewController);
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  }
}

class PostListBuilder extends DbNoteBuilder<PostListRouter> {
  @override
  PostListRouter build() {
    final router = PostListRouter();
    final interactor = PostListInteractor(router);
    final page = PostListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }

  Widget buildHomePlugin({
    int limit = 4,
    String scene = "LATEST",
    required PostCardListPluginListener listener,
  }) {
    // Chúng ta không dùng router riêng cho plugin đơn giản này, 
    // nhưng AppCubitState vẫn yêu cầu một routable context.
    // Tận dụng Router chung của PostList.
    final router = PostListRouter();
    final interactor = PostCardListInteractor(router,
      limit: limit,
      scene: scene,
      listener: listener,
    );
    final page = PostCardListWidget(interactor: interactor);
    // Wire up thông qua router.attach để tận dụng logic của CubitStateFulWidget
    router.attach(interactor, page);
    return page;
  }
}
