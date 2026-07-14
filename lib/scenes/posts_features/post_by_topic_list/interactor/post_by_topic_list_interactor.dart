import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/posts_features/post_by_topic_list/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/posts_features/post_by_topic_list/interactor/post_by_topic_list_event_state.dart';
import 'package:coffee_bean/scenes/posts_features/post_by_topic_list/post_by_topic_list_builder.dart';
import 'package:db_core/db_core.dart';

class PostByTopicListInteractor extends CubitInteractor<PostByTopicListRoutable, PostByTopicListState> {
  final HubRepository _hubRepository = locator.get<HubRepository>();
  final int topicId;

  PostByTopicListInteractor(PostByTopicListRoutable router, {required this.topicId}) : super(PostByTopicListState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _fetchData();
  }

  Future<void> _fetchData() async {
    emit(state.copyWith(isLoading: true));

    // 1. Fetch Topic Detail
    final topicResult = await _hubRepository.getTopicDetail(topicId);
    if (topicResult case DbSuccess(:final data)) {
      emit(state.copyWith(topic: data));
    } else {
      // Dùng mock nếu lỗi hoặc empty để test
      emit(state.copyWith(topic: PostByTopicMockData.getMockTopic(topicId)));
    }

    // 2. Fetch Posts
    await _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final scene = state.currentTabIndex == 0 ? "LATEST" : "TRENDING";
    final topicName = state.topic?.topicName;

    // Giả lập delay một chút để thấy loading nếu dùng mock data
    await Future.delayed(const Duration(milliseconds: 500));

    final postsResult = await _hubRepository.getPostPage(
      topicName: topicName,
      scene: scene,
      pageSize: 100,
    );

    if (postsResult case DbSuccess(:final data)) {
      if (data.list.isEmpty) {
        final mockPosts = PostByTopicMockData.getMockPosts();
        if (state.currentTabIndex == 1) mockPosts.shuffle(); // Xào bài để thấy sự thay đổi
        emit(state.copyWith(posts: mockPosts, isLoading: false));
      } else {
        emit(state.copyWith(posts: data.list, isLoading: false));
      }
    } else {
      // Dùng mock nếu lỗi để test
      final mockPosts = PostByTopicMockData.getMockPosts();
      if (state.currentTabIndex == 1) mockPosts.shuffle();
      emit(state.copyWith(posts: mockPosts, isLoading: false));
    }
  }

  void onTabChanged(int index) {
    if (state.currentTabIndex == index) return;
    emit(state.copyWith(currentTabIndex: index, isLoading: true));
    _fetchPosts();
  }


}
