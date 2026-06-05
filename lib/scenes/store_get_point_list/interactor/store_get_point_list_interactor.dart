import 'package:coffee_bean/data/repository/store_point_repository.dart';
import 'package:coffee_bean/scenes/store_get_point_list/store_get_point_list_router.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/scenes/store_get_point_list/interactor/store_get_point_list_event_state.dart';

class StoreGetPointListInteractor extends CubitInteractor<StoreGetPointListRouter, StoreGetPointListState> {
  final StorePointRepository _repository = locator<StorePointRepository>();

  StoreGetPointListInteractor(StoreGetPointListRouter router) : super(StoreGetPointListInitial(), router: router) {
    _init();
  }

  void _init() async {
    final categories = _repository.getCategories();
    emit(StoreGetPointListDataState(categories: categories, isLoading: true));
    await _loadData();
  }

  Future<void> _loadData() async {
    final currentState = state;
    final items = await _repository.getStorePoints(
      query: currentState.searchText,
      catId: currentState.selectedCatId,
    );
    emit(StoreGetPointListDataState(
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
    
    emit((state as StoreGetPointListDataState).copyWith(
      selectedCatId: catId,
      isLoading: true,
    ));
    await _loadData();
  }

  void toggleSearchMode(bool isSearch) {
    if (state is StoreGetPointListDataState) {
      if (state.isSearchMode == isSearch) return;

      emit((state as StoreGetPointListDataState).copyWith(
        isSearchMode: isSearch,
        // Reset search text when closing search mode
        searchText: isSearch ? state.searchText : "",
      ));
      if (!isSearch) {
        _loadData();
      }
    }
  }

  void onRewardHistoryTap() {
    router?.navigate(RewardPointHistoryRoute());
  }

  void onStorePointTap(TblStorePoint item) {
    // Xử lý khi chọn item, ví dụ: mở chi tiết hoặc thực hiện đổi điểm
    iLog("Selected store point: ${item.name} with ID: ${item.id}");
  }

  void onSearchChanged(String text) {
    if (state is StoreGetPointListDataState) {
      emit((state as StoreGetPointListDataState).copyWith(
        searchText: text,
      ));
      _loadData();
    }
  }

  void clearSearch() {
    onSearchChanged("");
  }
}
