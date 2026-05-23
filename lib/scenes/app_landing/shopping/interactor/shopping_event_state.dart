import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

// States
class ShoppingState extends BaseBlocState {
  final List<TblCategory> categories;
  final Map<int, List<TblFood>> productsByCategory;
  final List<TblFood> allProducts;
  final List<TblFood> filteredProducts;
  final int selectedCategoryIndex;
  final bool isSearching;
  final String searchQuery;
  final bool isLoading;

  ShoppingState({
    this.categories = const [],
    this.productsByCategory = const {},
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.selectedCategoryIndex = 0,
    this.isSearching = false,
    this.searchQuery = '',
    this.isLoading = false,
  });

  ShoppingState copyWith({
    List<TblCategory>? categories,
    Map<int, List<TblFood>>? productsByCategory,
    List<TblFood>? allProducts,
    List<TblFood>? filteredProducts,
    int? selectedCategoryIndex,
    bool? isSearching,
    String? searchQuery,
    bool? isLoading,
  }) {
    return ShoppingState(
      categories: categories ?? this.categories,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        productsByCategory,
        allProducts,
        filteredProducts,
        selectedCategoryIndex,
        isSearching,
        searchQuery,
        isLoading,
      ];
}
