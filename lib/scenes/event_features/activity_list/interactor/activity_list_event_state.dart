import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/db_core.dart';

class ActivityListState extends Equatable {
  final List<TblActivity> activities;
  final List<TblCategory> categories;
  final TblCategory? selectedCategory;
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
    List<TblActivity>? activities,
    List<TblCategory>? categories,
    TblCategory? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    // bool clearCategory = false,
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
