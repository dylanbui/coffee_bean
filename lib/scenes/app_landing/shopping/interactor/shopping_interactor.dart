import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/shopping_router.dart';
import 'package:coffee_bean/core/utils/locator.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class ShoppingInteractor extends CubitInteractor<ShoppingRoutable, ShoppingState> {
  final CartService _cartService = locator<CartService>();
  final DatabaseService _dbService = locator<DatabaseService>();

  ShoppingInteractor(ShoppingRoutable router) : super(ShoppingState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadData();
  }

  Future<void> _loadData() async {
    emit(state.copyWith(isLoading: true));

    // 1. Lấy Categories dành cho FOOD
    final categories = await _dbService.isar.tblCategorys
        .filter()
        .typeEqualTo(ProductType.food.name)
        .sortBySortOrder()
        .findAll();

    // 2. Lấy toàn bộ Food
    final foods = await _dbService.isar.tblFoods.where().findAll();

    // 3. Gom nhóm Food theo Category ID
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
      
      // Query thông minh: Tìm trên cả name (có dấu) và searchName (không dấu)
      final results = await _dbService.isar.tblFoods.filter()
          .nameContains(query, caseSensitive: false)
          .or()
          .searchNameContains(searchKey, caseSensitive: false)
          .or()
          .skuContains(query, caseSensitive: false)
          .findAll();
          
      emit(state.copyWith(isSearching: true, searchQuery: query, filteredProducts: results));
    }
  }

  void addToCart(TblFood product) {
    _cartService.addToCart(product);
  }

  void routeToProductDetail(TblFood product) {
    // router.routeToProductDetail(product);
    debugPrint(product.name);
  }

  CartService get cartService => _cartService;
}
