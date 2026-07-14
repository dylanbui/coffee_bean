import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/plugins/post_card_list/post_card_list_state_event.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/post_list_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

abstract class PostCardListPluginListener {
  void onPostClick(int postId);
  void onShareClick(int postId);
  void onLikeClick(int postId);
}

class PostCardListInteractor extends CubitInteractor<PostListRoutable, PostCardListState> {
  final HubRepository _hubRepository = locator<HubRepository>();
  final int limit;
  final String scene;
  PostCardListPluginListener? listener;

  PostCardListInteractor(PostListRoutable router, {
    this.limit = 4,
    this.scene = "RECOMMEND",
    this.listener,
  }) : super( PostCardListState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    emit(state.copyWith(isLoading: true));

    final result = await _hubRepository.getPostIndexList(scene);

    if (result case DbSuccess(data: final list)) {
      List<Post> posts = list.take(limit).toList();
      if (posts.isEmpty) {
        posts = PostListMockData.mockPosts.take(limit).toList();
      }
      emit(state.copyWith(posts: posts, isLoading: false, failure: null));
    } else if (result case DbFailure()) {
      List<Post> posts = PostListMockData.mockPosts.take(limit).toList();
      emit(state.copyWith(isLoading: false, failure: result, posts: posts));
    }
  }

  void onPostTapped(Post post) {
    listener?.onPostClick(post.id);
  }

  void onShareTapped(Post post) {
    debugPrint("Plugin handling share for post: ${post.id}");
    listener?.onShareClick(post.id);
  }

  void onLikeTapped(Post post) {
    debugPrint("Plugin handling like for post: ${post.id}");
    listener?.onLikeClick(post.id);
  }
  
  void onFollowTapped(Post post) {
     debugPrint("Plugin handling follow for user: ${post.userId}");
  }
}
