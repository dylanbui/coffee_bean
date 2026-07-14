import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/interactor/post_list_event_state.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/post_list_builder.dart';
import 'package:db_core/db_core.dart';



class PostListInteractor extends CubitInteractor<PostListRoutable, PostListState> {
  final HubRepository _hubRepository = locator<HubRepository>();

  PostListInteractor(PostListRoutable router) : super(PostListState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _fetchPosts();
  }

  Future<void> _fetchPosts({String? keyword}) async {
    final currentKeyword = keyword ?? state.keyword;
    emit(state.copyWith(isLoading: true, keyword: currentKeyword));

    final result = await _hubRepository.getPostPage(
      keyword: currentKeyword,
      pageSize: 100,
    );

    if (result case DbSuccess(data: final pageResult)) {
      List<Post> posts = pageResult.list;
      if (posts.isEmpty && currentKeyword.isEmpty) {
        posts = PostListMockData.mockPosts;
      }
      emit(state.copyWith(posts: posts, isLoading: false, failure: null));
    } else if (result case DbFailure()) {
      // Nếu lỗi mà không có keyword, có thể dùng mock data để test UI
      List<Post> posts = [];
      if (currentKeyword.isEmpty) {
        posts = PostListMockData.mockPosts;
      }
      emit(state.copyWith(isLoading: false, failure: result, posts: posts));
    }
  }

  void onSearchChanged(String query) {
    _fetchPosts(keyword: query);
  }
  
}
