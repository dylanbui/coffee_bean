import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:db_core/db_core.dart';

class TopicSelectionState extends BaseBlocState {
  final bool isLoading;
  final List<HotTopic> topics;
  final List<int> selectedIds;
  final DbFailure? failure;

  TopicSelectionState({
    this.isLoading = false,
    this.topics = const [],
    this.selectedIds = const [],
    this.failure,
  });

  @override
  TopicSelectionState copyWith({
    bool? isLoading,
    List<HotTopic>? topics,
    List<int>? selectedIds,
    DbFailure? failure,
  }) {
    return TopicSelectionState(
      isLoading: isLoading ?? this.isLoading,
      topics: topics ?? this.topics,
      selectedIds: selectedIds ?? this.selectedIds,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [isLoading, topics, selectedIds, failure];
}
