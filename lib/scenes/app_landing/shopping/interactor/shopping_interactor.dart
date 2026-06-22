import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/store_manager/store_manager.dart';
import 'package:coffee_bean/data/repository/product_repository.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/data/model/category.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/shopping_router.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:db_core/network/network_common.dart';

class ShoppingInteractor extends CubitInteractor<ShoppingRoutable, ShoppingState> {
  final CartService _cartService = locator<CartService>();
  final ProductRepository _productRepo = locator<ProductRepository>();

  ShoppingInteractor(ShoppingRoutable router) : super(ShoppingState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadData();
  }

  Future<void> _loadData({bool refresh = false}) async {
    emit(state.copyWith(isLoading: true));

    final storeId = StoreManager().selectedStore?.id;

    // 1. Fetch Categories from API
    final resultCat = (await _productRepo.getProductCategoryList(storeId)).toResult();
    List<Category> categories = [];
    if (resultCat case DbSuccess(:final data)) {
      categories = data;
    }

    // 2. Fetch Products (SPU) from API
    final resultSpu = (await _productRepo.getProductSpuPage(
      storeId: storeId,
      pageSize: 200, // Load enough for shopping display
    )).toResult();
    
    List<Product> products = [];
    if (resultSpu case DbSuccess(:final data)) {
      products = data.list;
    }

    // 3. Group Products by Category ID
    final productsByCategory = <int, List<Product>>{};
    for (var cat in categories) {
      productsByCategory[cat.id] = products.where((p) => p.categoryId == cat.id).toList();
    }

    emit(state.copyWith(
      categories: categories,
      productsByCategory: productsByCategory,
      allProducts: products,
      isLoading: false,
    ));
  }

  void selectCategory(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void onSearchChanged(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(isSearching: false, searchQuery: '', filteredProducts: []));
    } else {
      final searchKey = Utils.toNoSign(query).toLowerCase();
      
      final results = state.allProducts.where((p) {
        final nameMatch = p.name.toLowerCase().contains(query.toLowerCase());
        final searchNameMatch = Utils.toNoSign(p.name).toLowerCase().contains(searchKey);
        return nameMatch || searchNameMatch;
      }).toList();
          
      emit(state.copyWith(isSearching: true, searchQuery: query, filteredProducts: results));
    }
  }

  void addToCart(Product product) {
    // Note: Product from API doesn't have defaultSelectedOptions directly in the SPU list model.
    // If it has specs (specType == true), we should probably route to detail instead of direct add.
    if (product.specType) {
      routeToProductDetail(product);
    } else {
      _cartService.addToCart(product);
    }
  }

  void routeToProductDetail(Product product) {
    router?.navigate(FoodDetailRoute(product));
  }

  void checkout() {
    if (_cartService.currentItems.isNotEmpty) {
      router?.navigate(OrderConfirmationRoute());
    }
  }

  CartService get cartService => _cartService;
}
