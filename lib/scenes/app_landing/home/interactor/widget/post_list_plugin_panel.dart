import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/plugins/post_card_list/post_card_list_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/post_list_builder.dart';
import 'package:flutter/material.dart';

class PostListPluginPanel extends StatelessWidget implements PostCardListPluginListener {
  final HomeInteractor interactor;

  const PostListPluginPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return PostListBuilder().buildHomePlugin(
      limit: 4,
      scene: "LATEST",
      listener: this,
    );
  }

  @override
  void onLikeClick(int postId) {
    debugPrint("Home received onLikeClick for postId: $postId");
  }

  @override
  void onPostClick(int postId) {
    debugPrint("Home received onPostClick for postId: $postId");
    interactor.selectPostById(postId);
  }

  @override
  void onShareClick(int postId) {
    debugPrint("Home received onShareClick for postId: $postId");
  }
}

extension HomeInteractorExt on HomeInteractor {
  void selectPostById(int postId) {
    // Logic điều hướng được xử lý thông qua router của HomeInteractor
    // selectPost(PostItem(
    //   id: postId,
    //   authorName: "",
    //   postDate: "",
    //   title: "",
    //   content: "",
    // ));
  }
}
