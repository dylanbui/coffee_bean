import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/app_landing/community/community_builder.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_event_state.dart';
import 'package:db_core/db_core.dart';

class CommunityInteractor extends CubitInteractor<CommunityRoutable, CommunityState> {
  final HubRepository _hubRepository = locator<HubRepository>();

  CommunityInteractor(CommunityRoutable router)
      : super(CommunityState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadData();
  }

  Future<void> _loadData() async {
    emit(state.copyWith(isLoading: true));
    
    final results = await Future.wait([
      _hubRepository.getHotTopics(),
      _hubRepository.getPostIndexList(_getSceneByTabIndex(state.currentTabIndex)),
    ]);

    final hotTopicsResult = results[0] as DbResult<List<HotTopic>>;
    final postsResult = results[1] as DbResult<List<Post>>;

    List<HotTopic> hotTopics = hotTopicsResult.dataOrNull ?? [];
    List<Post> posts = postsResult.dataOrNull ?? [];

    emit(state.copyWith(
      isLoading: false,
      hotTopics: hotTopics,
      posts: posts,
    ));
  }

  void onTabChanged(int index) {
    if (state.currentTabIndex == index) return;
    emit(state.copyWith(currentTabIndex: index));
    _fetchPostsByTab();
  }

  void openSearch() {
    router?.openSearch();
  }

  void openTopicDetail(HotTopic topic) {
    router?.pushPostByTopicList(topic.id);
  }

  Future<void> _fetchPostsByTab() async {
    emit(state.copyWith(isLoading: true));
    final result = await _hubRepository.getPostIndexList(_getSceneByTabIndex(state.currentTabIndex));
    
    result.when(
      success: (data) {
        emit(state.copyWith(isLoading: false, posts: data));
      },
      failure: (error) {
        emit(state.copyWith(isLoading: false, failure: error));
      },
    );
  }

  String _getSceneByTabIndex(int index) {
    switch (index) {
      case 0: return 'FOLLOWING'; // Gợi ý
      case 1: return 'RECOMMEND'; // Đề xuất
      case 2: return 'TRENDING';  // Thịnh hành
      default: return 'FOLLOWING';
    }
  }
}
