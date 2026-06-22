import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/data/model/category.dart';

// States
class ShoppingState extends BaseBlocState {
  final List<Category> categories;
  final Map<int, List<Product>> productsByCategory;
  final List<Product> allProducts;
  final List<Product> filteredProducts;
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
    List<Category>? categories,
    Map<int, List<Product>>? productsByCategory,
    List<Product>? allProducts,
    List<Product>? filteredProducts,
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
