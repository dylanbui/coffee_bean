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

  Future<void> confirm() async {
    final selectedTopics = state.topics
        .where((t) => state.selectedIds.contains(t.id))
        .toList();
    
    final selectedTags = selectedTopics
        .map((t) => t.topicName ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    if (UserManager().isLogin) {
      emit(state.copyWith(isLoading: true));
      final result = await _hubRepository.saveTopicTags(selectedTags);
      emit(state.copyWith(isLoading: false));
      
      if (result case DbSuccess()) {
        controller.listener?.onTopicSelectionFinish(selectedTopics);
      } else if (result case DbFailure(:final error)) {
        emit(state.copyWith(failure: null));
      }
    } else {
      // Save to SharedPreferences using AppPrefs if not logged in
      AppPrefs().setTopicInterested(selectedTags);
      controller.listener?.onTopicSelectionFinish(selectedTopics);
    }
  }

  void skip() {
    controller.listener?.onTopicSelectionFinish(null);
  }
}
