import 'package:coffee_bean/data/repository/store_point_repository.dart';
import 'package:coffee_bean/scenes/store_point_list/store_point_list_router.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/scenes/store_point_list/interactor/store_point_list_event_state.dart';

//class StoreListInteractor extends CubitInteractor<StoreListRouter, StoreListState> {
class StorePointListInteractor extends CubitInteractor<StorePointListRouter, StorePointListState> {
  final StorePointRepository _repository = locator<StorePointRepository>();

  StorePointListInteractor(StorePointListRouter router) : super(StorePointListInitial(), router: router) {
    _init();
  }

  void _init() async {
    final categories = _repository.getCategories();
    emit(StorePointListDataState(categories: categories, isLoading: true));
    await _loadData();
  }

  Future<void> _loadData() async {
    final currentState = state;
    final items = await _repository.getStorePoints(
      query: currentState.searchText,
      catId: currentState.selectedCatId,
    );
    emit(StorePointListDataState(
      items: items,
      categories: currentState.categories,
      selectedCatId: currentState.selectedCatId,
      isSearchMode: currentState.isSearchMode,
      searchText: currentState.searchText,
      isLoading: false,
      userPoints: currentState.userPoints,
    ));
  }

  void onCategorySelected(int catId) async {
    if (state.selectedCatId == catId) return;
    
    emit((state as StorePointListDataState).copyWith(
      selectedCatId: catId,
      isLoading: true,
    ));
    await _loadData();
  }

  void toggleSearchMode(bool isSearch) {
    if (state is StorePointListDataState) {
      emit((state as StorePointListDataState).copyWith(
        isSearchMode: isSearch,
        // Reset search text when closing search mode
        searchText: isSearch ? state.searchText : "",
      ));
      if (!isSearch) {
        _loadData();
      }
    }
  }

  void onSearchChanged(String text) {
    if (state is StorePointListDataState) {
      emit((state as StorePointListDataState).copyWith(
        searchText: text,
      ));
      _loadData();
    }
  }

  void clearSearch() {
    onSearchChanged("");
  }
}
