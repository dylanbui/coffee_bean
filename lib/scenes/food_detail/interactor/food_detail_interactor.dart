import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/food_detail_event_state.dart';
import 'package:coffee_bean/scenes/food_detail/food_detail_router.dart';
import 'package:db_core/utils/locator.dart';
import 'dart:math';

class FoodDetailInteractor extends CubitInteractor<FoodDetailRoutable, FoodDetailState> {
  final CartService _cartService = locator<CartService>();
  final DatabaseService _dbService = locator<DatabaseService>();

  FoodDetailInteractor(FoodDetailRoutable router, TblFood product) 
      : super(FoodDetailState(product: product), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadSuggestedProducts();
    _initDefaultOptions();
  }

  void _initDefaultOptions() {
    final defaultOptions = <int, TblProductOption>{};
    if (state.product.properties != null) {
      for (var prop in state.product.properties!) {
        if (prop.options != null && prop.options!.isNotEmpty) {
          final firstAvailable = prop.options!.firstWhere((o) => o.isAvailable, orElse: () => prop.options!.first);
          defaultOptions[prop.serverId] = firstAvailable;
        }
      }
    }
    emit(state.copyWith(selectedOptions: defaultOptions));
  }

  Future<void> _loadSuggestedProducts() async {
    final allFoods = await _dbService.isar.tblFoods.where()
        .serverIdNotEqualTo(state.product.serverId)
        .findAll();
    
    if (allFoods.isEmpty) return;

    final random = Random();
    final suggested = <TblFood>[];
    final count = min(5, allFoods.length);
    
    final indices = <int>{};
    while (indices.length < count) {
      indices.add(random.nextInt(allFoods.length));
    }
    
    for (var i in indices) {
      suggested.add(allFoods[i]);
    }

    emit(state.copyWith(suggestedProducts: suggested));
  }

  void updateQuantity(int delta) {
    final newQty = max(1, state.quantity + delta);
    if (newQty != state.quantity) {
      emit(state.copyWith(quantity: newQty));
      _syncToCartIfNeeded();
    }
  }

  void selectOption(int propertyId, TblProductOption option) {
    if (!option.isAvailable) return;
    
    final newOptions = Map<int, TblProductOption>.from(state.selectedOptions);
    newOptions[propertyId] = option;
    emit(state.copyWith(selectedOptions: newOptions));
    _syncToCartIfNeeded();
  }

  void _syncToCartIfNeeded() {
    _cartService.updateQuantityIfInCart(state.product, state.quantity, _getSelectedOptionsList());
  }

  List<SelectedOption> _getSelectedOptionsList() {
    final list = <SelectedOption>[];
    state.selectedOptions.forEach((propId, option) {
      final prop = state.product.properties?.firstWhere((p) => p.serverId == propId);
      list.add(SelectedOption()
        ..optionServerId = option.serverId
        ..groupName = prop?.groupName ?? ""
        ..optionName = option.name
        ..extraPrice = option.extraPrice);
    });
    return list;
  }

  void addToCart() {
    _cartService.addToCart(state.product, quantity: state.quantity, options: _getSelectedOptionsList());
  }

  void buyNow() {
    addToCart();
  }

  void goBack() {
    router?.pop();
  }
}
