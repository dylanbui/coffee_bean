import 'package:coffee_bean/data/repository/activity_repository.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/activity_list_builder.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/interactor/activity_list_event_state.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/db_core.dart';


class ActivityListInteractor extends CubitInteractor<ActivityListRoutable, ActivityListState> {
  final ActivityRepository _activityRepository = locator<ActivityRepository>();

  // ActivityListInteractor(this._repository) : super(ActivityListState());

  ActivityListInteractor(ActivityListRoutable router)
      : super(ActivityListState(), router: router);


  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _initData();
  }

  Future<void> _initData() async {
    emit(state.copyWith(isLoading: true));

    final cats = await _activityRepository.getCategories();
    final items = await _activityRepository.getActivities();

    emit(state.copyWith(
      categories: cats,
      activities: items,
      isLoading: false,
    ));
  }

  // void initData() {
  //   _loadCategories();
  //   _fetchActivities();
  // }

  // Future<void> _loadCategories() async {
  //   final categories = await _repository.getCategories();
  //   emit(state.copyWith(categories: categories));
  // }

  void onCategorySelected(TblCategory? category) async {
    if (state.selectedCategory?.serverId == category?.serverId && category != null) return;

    emit(state.copyWith(
      selectedCategory: category,
      clearSelectedCategory: category == null,
      isLoading: true,
    ));

    final items = await _activityRepository.getActivities(
      query: state.searchQuery,
      catId: category?.serverId,
    );

    emit(state.copyWith(activities: items, isLoading: false));
  }

  void onSearchChanged(String query) async {
    emit(state.copyWith(searchQuery: query, isLoading: true));

    final items = await _activityRepository.getActivities(
      query: query,
      catId: state.selectedCategory?.serverId,
    );

    emit(state.copyWith(activities: items, isLoading: false));
  }



  // Future<void> _fetchActivities() async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final activities = await _activityRepository.getActivities(
  //       query: state.searchQuery,
  //       catId: state.selectedCategory?.serverId,
  //     );
  //     emit(state.copyWith(activities: activities, isLoading: false));
  //   } catch (e) {
  //     emit(state.copyWith(isLoading: false));
  //   }
  // }
  //
  // void onSearchChanged(String query) {
  //   emit(state.copyWith(searchQuery: query));
  //   _fetchActivities();
  // }
  //
  // void onCategorySelected(TblCategory? category) {
  //   if (category == null) {
  //     emit(state.copyWith(clearCategory: true));
  //   } else {
  //     emit(state.copyWith(selectedCategory: category));
  //   }
  //   _fetchActivities();
  // }
}
