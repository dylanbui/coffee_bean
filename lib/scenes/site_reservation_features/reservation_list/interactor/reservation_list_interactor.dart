import 'package:coffee_bean/data/repository/reservation_repository.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/interactor/reservation_list_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/reservation_list_router.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';

class ReservationListInteractor extends CubitInteractor<ReservationListRoutable, ReservationListState> {
  final ReservationRepository _repository = locator<ReservationRepository>();

  ReservationListInteractor(ReservationListRoutable router)
      : super(const ReservationListInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _initData();
  }

  Future<void> _initData() async {
    emit(ReservationListLoading(
      reservations: state.reservations,
      categories: state.categories,
      selectedCategory: state.selectedCategory,
      searchQuery: state.searchQuery,
    ));

    // Dữ liệu sẽ được tự động sync bên trong Repository nếu hết hạn hoặc trống
    final categories = await _repository.getCategories();
    
    fetchReservations(categories: categories);
  }

  Future<void> fetchReservations({
    List<TblCategory>? categories,
    TblCategory? selectedCategory,
    String? query,
  }) async {
    final currentCategories = categories ?? state.categories;
    final currentSelectedCategory = selectedCategory ?? state.selectedCategory;
    final currentQuery = query ?? state.searchQuery;

    emit(ReservationListLoading(
      reservations: state.reservations,
      categories: currentCategories,
      selectedCategory: currentSelectedCategory,
      searchQuery: currentQuery,
    ));

    final results = await _repository.getReservations(
      query: currentQuery,
      catId: currentSelectedCategory?.serverId,
    );

    emit(ReservationListLoaded(
      reservations: results,
      categories: currentCategories,
      selectedCategory: currentSelectedCategory,
      searchQuery: currentQuery,
    ));
  }

  void onSearchChanged(String query) {
    fetchReservations(query: query);
  }

  void onCategorySelected(TblCategory? category) {
    fetchReservations(selectedCategory: category);
  }

  void onVenueTapped(TblReservation venue) {
    router?.openVenueDetail(venue);
  }
}
