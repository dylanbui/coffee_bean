import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/repository/product_repository.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/shopping_router.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:db_core/network/network_common.dart';

class ShoppingInteractor extends CubitInteractor<ShoppingRoutable, ShoppingState> {
  final CartService _cartService = locator<CartService>();
  final DatabaseService _dbService = locator<DatabaseService>();
  final ProductRepository _productRepo = locator<ProductRepository>();

  ShoppingInteractor(ShoppingRoutable router) : super(ShoppingState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadData();
  }

  Future<void> _loadData({bool refresh = false}) async {
    emit(state.copyWith(isLoading: true));

    final storeId = UserManager().selectedStore?.id;

    // 1. Sync Categories from API
    final resultCat = await _productRepo.getProductCategoryList(storeId);
    if (resultCat case DbSuccess(:final data)) {
      await _dbService.syncAppCategories(data.map((e) => e.toJson()).toList(), storeId);
    }

    // 2. Load/Cache Products
    List<TblFood> foods = [];
    if (!refresh) {
      foods = await _dbService.getCachedProducts(storeId);
    }

    if (refresh || foods.isEmpty) {
      // Fetch products (SPU) for the store
      final resultSpu = await _productRepo.getProductSpuPage(
        storeId: storeId, 
        pageSize: 100, // Load enough for shopping display
      );
      
      if (resultSpu case DbSuccess(:final data)) {
        await _dbService.syncAppProducts(data.list.map((e) => e.toJson()).toList(), storeId);
        foods = await _dbService.getCachedProducts(storeId);
      }
    }

    // 3. Get Categories from DB for display
    final categories = await _dbService.isar.tblCategorys
        .filter()
        .storeIdEqualTo(storeId)
        .findAll();

    // 4. Group Products by Category ID
    final productsByCategory = <int, List<TblFood>>{};
    for (var cat in categories) {
      productsByCategory[cat.serverId] = foods.where((f) => f.catId == cat.serverId).toList();
    }

    emit(state.copyWith(
      categories: categories,
      productsByCategory: productsByCategory,
      allProducts: foods,
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
      final searchKey = Utils.toNoSign(query);
      
      final results = await _dbService.isar.tblFoods.filter()
          .nameContains(query, caseSensitive: false)
          .or()
          .searchNameContains(searchKey, caseSensitive: false)
          .findAll();
          
      emit(state.copyWith(isSearching: true, searchQuery: query, filteredProducts: results));
    }
  }

  void addToCart(TblFood product) {
    _cartService.addToCart(product, options: product.defaultSelectedOptions);
  }

  void routeToProductDetail(TblFood product) {
    router?.navigate(FoodDetailRoute(product));
  }

  void checkout() {
    if (_cartService.currentItems.isNotEmpty) {
      router?.navigate(OrderConfirmationRoute());
    }
  }

  CartService get cartService => _cartService;
}
