import 'package:coffee_bean/data/model/response/hub/activity_info.dart';
import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:coffee_bean/data/repository/activity_repository.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/activity_list_builder.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/interactor/activity_list_event_state.dart';
import 'package:db_core/db_core.dart';

class ActivityListInteractor extends CubitInteractor<ActivityListRoutable, ActivityListState> {
  final ActivityRepository _activityRepository = locator<ActivityRepository>();

  ActivityListInteractor(ActivityListRoutable router)
      : super(const ActivityListState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _initData();
  }

  Future<void> _initData() async {
    emit(state.copyWith(isLoading: true));

    final catResult = await _activityRepository.getActivityCategories();
    final activityResult = await _activityRepository.getActivityPage();

    List<DictionaryData> cats = [];
    if (catResult case DbSuccess(data: final data)) {
      cats = data;
    }

    List<ActivityInfo> items = [];
    if (activityResult case DbSuccess(data: final data)) {
      items = data.list;
    }

    emit(state.copyWith(
      categories: cats,
      activities: items,
      isLoading: false,
    ));
  }

  void onCategorySelected(DictionaryData? category) async {
    if (state.selectedCategory?.id == category?.id && category != null) return;

    emit(state.copyWith(
      selectedCategory: category,
      clearSelectedCategory: category == null,
      isLoading: true,
    ));

    final activityResult = await _activityRepository.getActivityPage(
      keyword: state.searchQuery,
      activityType: category?.id != 0 ? category?.id : null,
    );

    if (activityResult case DbSuccess(data: final data)) {
      emit(state.copyWith(activities: data.list, isLoading: false));
    } else {
      emit(state.copyWith(activities: [], isLoading: false));
    }
  }

  void onSearchChanged(String query) async {
    emit(state.copyWith(searchQuery: query, isLoading: true));

    final activityResult = await _activityRepository.getActivityPage(
      keyword: query,
      activityType: state.selectedCategory?.id != 0 ? state.selectedCategory?.id : null,
    );

    if (activityResult case DbSuccess(data: final data)) {
      emit(state.copyWith(activities: data.list, isLoading: false));
    } else {
      emit(state.copyWith(activities: [], isLoading: false));
    }
  }

  void onActivitySelected(ActivityInfo activity) {
    router?.gotoActivityDetail(activity.id);
  }
}
