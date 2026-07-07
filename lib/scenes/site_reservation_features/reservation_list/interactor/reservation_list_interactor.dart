import 'package:coffee_bean/data/model/response/hub/venue_info.dart';
import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:coffee_bean/data/repository/reservation_repository.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/interactor/reservation_list_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/reservation_list_builder.dart';
import 'package:db_core/db_core.dart';

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

    final result = await _repository.getVenueTypes();
    final List<DictionaryData> categories = [
      DictionaryData(id: 0, label: "Tất cả các loại", value: "", dictType: ""),
      ...(result.dataOrNull ?? [])
    ];
    
    fetchReservations(
      categories: categories,
      selectedCategory: categories.first,
    );
  }

  Future<void> fetchReservations({
    List<DictionaryData>? categories,
    DictionaryData? selectedCategory,
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

    final result = await _repository.getVenues(
      keyword: currentQuery,
      venueTypeId: (currentSelectedCategory?.id == 0) ? null : currentSelectedCategory?.id,
    );

    if (result case DbSuccess(data: final pageResult)) {
      emit(ReservationListLoaded(
        reservations: pageResult.list,
        categories: currentCategories,
        selectedCategory: currentSelectedCategory,
        searchQuery: currentQuery,
      ));
    } else {
      if (result case DbFailure(:final error)) {
        iLog("Fetch reservations failed: ${error.message} (Code: ${error.code})");
      }
      emit(ReservationListLoaded(
        reservations: const [],
        categories: currentCategories,
        selectedCategory: currentSelectedCategory,
        searchQuery: currentQuery,
      ));
    }
  }

  void onSearchChanged(String query) {
    fetchReservations(query: query);
  }

  void onCategorySelected(DictionaryData? category) {
    fetchReservations(selectedCategory: category);
  }

  void onVenueTapped(VenueInfo venue) {
    router?.openVenueDetail(venue);
  }
}
