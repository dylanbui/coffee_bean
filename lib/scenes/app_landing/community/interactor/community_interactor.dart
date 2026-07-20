import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/app_landing/community/community_builder.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_constants.dart';
import 'package:db_core/db_core.dart';

class CommunityInteractor extends CubitInteractor<CommunityRoutable, CommunityState> {
  final HubRepository _hubRepository = locator<HubRepository>();
  
  // Logic Auto-refresh: Lưu thời điểm refresh cuối cùng và thời gian chờ (cooldown)
  DateTime? _lastRefreshTime;
  static const Duration _refreshCooldown = Duration(minutes: 5);

  CommunityInteractor(CommunityRoutable router)
      : super(CommunityState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadData();
    
    // [Auto-refresh kịch bản 1]: Lắng nghe sự kiện đổi tab từ Main Tabbar
    collect(locator<DbEventBus>().on<AppMainTabSelectedEvent>().listen((event) {
      // Nếu người dùng chọn quay lại tab Community, kiểm tra xem có cần refresh không
      if (event.tabType == MainTabType.community) {
        checkAutoRefresh();
      }
    }));

    // [Auto-refresh kịch bản 2]: Lắng nghe sự kiện vòng đời ứng dụng qua EventBus
    collect(locator<DbEventBus>().on<AppLifecycleChangedEvent>().listen((event) {
      // Khi ứng dụng quay lại từ trạng thái chạy nền (Background) sang hiện diện (Foreground)
      if (event.isResumed) {
        checkAutoRefresh();
      }
    }));
  }

  /// Kiểm tra và thực hiện tải lại dữ liệu nếu đã quá thời gian cooldown (5 phút)
  void checkAutoRefresh() {
    if (_lastRefreshTime == null) return;
    final now = DateTime.now();
    if (now.difference(_lastRefreshTime!) > _refreshCooldown) {
      // Tải lại dữ liệu ở chế độ "Silent" (không hiện loading che màn hình nếu đã có data)
      _loadData(isSilent: true);
    }
  }

  /// Tải dữ liệu từ Server (Hot Topics và Posts)
  Future<void> _loadData({bool isSilent = false}) async {
    if (!isSilent) {
      emit(state.copyWith(isLoading: true));
    }
    
    final results = await Future.wait([
      _hubRepository.getHotTopics(),
      _hubRepository.getPostIndexList(_getSceneByTabIndex(state.currentTabIndex)),
    ]);

    final hotTopicsResult = results[0] as DbResult<List<HotTopic>>;
    final postsResult = results[1] as DbResult<List<Post>>;

    List<HotTopic> hotTopics = hotTopicsResult.dataOrNull ?? [];
    List<Post> posts = postsResult.dataOrNull ?? [];

    // Cập nhật thời điểm làm mới cuối cùng sau khi API trả về thành công
    _lastRefreshTime = DateTime.now();

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
