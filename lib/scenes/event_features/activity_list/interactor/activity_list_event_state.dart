import 'package:coffee_bean/data/model/response/hub/activity_info.dart';
import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:db_core/db_core.dart';

class ActivityListState extends Equatable {
  final List<ActivityInfo> activities;
  final List<DictionaryData> categories;
  final DictionaryData? selectedCategory;
  final String searchQuery;
  final bool isLoading;

  const ActivityListState({
    this.activities = const [],
    this.categories = const [],
    this.selectedCategory,
    this.searchQuery = "",
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [activities, categories, selectedCategory, searchQuery, isLoading];

  ActivityListState copyWith({
    List<ActivityInfo>? activities,
    List<DictionaryData>? categories,
    DictionaryData? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    bool clearSelectedCategory = false,
  }) {
    return ActivityListState(
      activities: activities ?? this.activities,
      categories: categories ?? this.categories,
      selectedCategory: clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ActivityListInitial extends ActivityListState {
  const ActivityListInitial() : super();
}

class ActivityListLoading extends ActivityListState {
  const ActivityListLoading({
    super.activities,
    super.categories,
    super.selectedCategory,
    super.searchQuery,
  }) : super(isLoading: true);
}
