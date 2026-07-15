import 'package:coffee_bean/config/app_pref.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/interactor/topic_selection_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/topic_selection_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';

class TopicSelectionPluginInteractor extends CubitInteractor<TopicSelectionRoutable, TopicSelectionState> {
  final TopicSelectionPluginController controller;
  final HubRepository _hubRepository = locator<HubRepository>();

  TopicSelectionPluginInteractor(
    TopicSelectionRoutable router, {
    required this.controller,
  }) : super(TopicSelectionState(), router: router) {
    controller.attach(this);
  }

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    emit(state.copyWith(isLoading: true));
    final result = await _hubRepository.getChooseTopicList();
    
    result.when(
      success: (data) {
        List<HotTopic> topics = data;
        if (topics.isEmpty) {
          topics = TopicSelectionMockData.mockTopics;
        }
        emit(state.copyWith(isLoading: false, topics: topics, failure: null));
      },
      failure: (error) {
        emit(state.copyWith(
          isLoading: false, 
          failure: null,
          topics: TopicSelectionMockData.mockTopics,
        ));
      },
    );
  }

  void toggleTopic(int id) {
    final currentSelected = List<int>.from(state.selectedIds);
    if (currentSelected.contains(id)) {
      currentSelected.remove(id);
    } else {
      currentSelected.add(id);
    }
    emit(state.copyWith(selectedIds: currentSelected));
  }

  Future<void> _saveTopics(List<String> tags) async {
    // Save to SharedPreferences using AppPrefs
    AppPrefs().setTopicInterested(tags);
    if (UserManager().isLogin) {
      await _hubRepository.saveTopicTags(tags);
    }
  }

  Future<void> confirm() async {
    final selectedTopics = state.topics
        .where((t) => state.selectedIds.contains(t.id))
        .toList();
    
    final selectedTags = selectedTopics
        .map((t) => t.topicName ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    emit(state.copyWith(isLoading: true));
    await _saveTopics(selectedTags);
    emit(state.copyWith(isLoading: false));
    
    controller.listener?.onTopicSelectionFinish(selectedTopics);
  }

  void skip() {
    // Khi user chọn "bỏ qua", mặc định lấy 5 topic đầu tiên
    final selectedTopics = state.topics.take(5).toList();
    
    final selectedTags = selectedTopics
        .map((t) => t.topicName ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    // Chạy ngầm việc lưu vào hệ thống (không await)
    _saveTopics(selectedTags);
    
    // Kết thúc plugin ngay lập tức
    controller.listener?.onTopicSelectionFinish(selectedTopics);
  }
}
