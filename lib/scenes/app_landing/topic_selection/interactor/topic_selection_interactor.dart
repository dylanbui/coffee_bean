import 'package:coffee_bean/config/app_pref.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/interactor/topic_selection_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/topic_selection_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';

class TopicSelectionInteractor extends CubitInteractor<TopicSelectionRoutable, TopicSelectionState> {
  final TopicSelectionListener? listener;
  final HubRepository _hubRepository = locator<HubRepository>();

  TopicSelectionInteractor(TopicSelectionRoutable router, {this.listener})
      : super(TopicSelectionState(), router: router);

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
        final processed = _sortAndExtractSelected(data.isEmpty ? TopicSelectionMockData.mockTopics : data);
        emit(state.copyWith(
          isLoading: false, 
          topics: processed.topics, 
          selectedIds: processed.selectedIds, 
          failure: null
        ));
      },
      failure: (error) {
        final processed = _sortAndExtractSelected(TopicSelectionMockData.mockTopics);
        emit(state.copyWith(
          isLoading: false, 
          failure: null,
          topics: processed.topics,
          selectedIds: processed.selectedIds,
        ));
      },
    );
  }

  ({List<HotTopic> topics, List<int> selectedIds}) _sortAndExtractSelected(List<HotTopic> originalTopics) {
    final savedTags = AppPrefs().getTopicInterested();
    if (savedTags.isEmpty) {
      return (topics: originalTopics, selectedIds: <int>[]);
    }

    final matched = <HotTopic>[];
    final others = <HotTopic>[];

    for (var topic in originalTopics) {
      if (savedTags.contains(topic.topicName)) {
        matched.add(topic);
      } else {
        others.add(topic);
      }
    }

    // Không thêm các id vào selectedIds, chỉ sắp xếp lại danh sách
    return (topics: [...matched, ...others], selectedIds: <int>[]);
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
    
    listener?.onTopicSelectionFinish(selectedTopics);
    router?.pop();
  }

  void skip() {
    router?.pop();
  }
}
