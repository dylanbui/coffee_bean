import 'package:coffee_bean/data/repository/store_point_repository.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

abstract class StorePointListState {
  final List<TblStorePoint> items;
  final List<StorePointCategory> categories;
  final int selectedCatId;
  final bool isSearchMode;
  final String searchText;
  final bool isLoading;
  final double userPoints;

  StorePointListState({
    this.items = const [],
    this.categories = const [],
    this.selectedCatId = 1,
    this.isSearchMode = false,
    this.searchText = "",
    this.isLoading = false,
    this.userPoints = 1998,
  });
}

class StorePointListInitial extends StorePointListState {
  StorePointListInitial() : super();
}

class StorePointListDataState extends StorePointListState {
  StorePointListDataState({
    super.items,
    super.categories,
    super.selectedCatId,
    super.isSearchMode,
    super.searchText,
    super.isLoading,
    super.userPoints,
  });

  StorePointListDataState copyWith({
    List<TblStorePoint>? items,
    List<StorePointCategory>? categories,
    int? selectedCatId,
    bool? isSearchMode,
    String? searchText,
    bool? isLoading,
    double? userPoints,
  }) {
    return StorePointListDataState(
      items: items ?? this.items,
      categories: categories ?? this.categories,
      selectedCatId: selectedCatId ?? this.selectedCatId,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      searchText: searchText ?? this.searchText,
      isLoading: isLoading ?? this.isLoading,
      userPoints: userPoints ?? this.userPoints,
    );
  }
}
