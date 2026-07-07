import 'package:coffee_bean/scenes/my_profile_features/course_learning_list/interactor/mock_data.dart';
import 'package:db_core/db_core.dart';

class CourseLearningListState extends BaseBlocState {
  final List<CourseLearningProgressModel> items;
  final bool isLoading;

  CourseLearningListState({
    this.items = const [],
    this.isLoading = true,
  });

  @override
  List<Object?> get props => [items, isLoading];

  CourseLearningListState copyWith({
    List<CourseLearningProgressModel>? items,
    bool? isLoading,
  }) {
    return CourseLearningListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
