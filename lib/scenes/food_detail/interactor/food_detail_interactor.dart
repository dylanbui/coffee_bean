import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/food_detail_event_state.dart';
import 'package:coffee_bean/scenes/food_detail/food_detail_router.dart';
import 'package:db_core/utils/toast.dart';
import 'package:db_core/utils/locator.dart';
import 'dart:math';

class FoodDetailInteractor extends CubitInteractor<FoodDetailRoutable, FoodDetailState> implements CommentListSmallListener {
  final CartService _cartService = locator<CartService>();
  final DatabaseService _dbService = locator<DatabaseService>();
  final int foodId;
  
  // Khởi tạo Controller tại đây để giữ vòng đời bền vững
  final commentController = CommentListSmallController();

  FoodDetailInteractor(FoodDetailRoutable router, this.foodId) 
      : super(FoodDetailState(), router: router) {
    // Đăng ký listener ngay khi khởi tạo
    commentController.listener = this;
  }

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadProductDetail();
  }

  Future<void> _loadProductDetail() async {
    // Giả lập delay mạng
    await Future.delayed(const Duration(milliseconds: 500));

    final product = await _dbService.isar.tblFoods.where().serverIdEqualTo(foodId).findFirst();
    
    if (product == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    emit(state.copyWith(product: product, isLoading: false));
    
    // Sau khi có product mới load các thành phần liên quan
    _loadSuggestedProducts();
    _initDefaultOptions();
  }

  void _initDefaultOptions() {
    final product = state.product;
    if (product == null) return;

    final defaultOptions = product.defaultOptionsMap;

    // Đồng bộ số lượng từ giỏ hàng cho tổ hợp mặc định
    final optionsList = _getSelectedOptionsList(optionsMap: defaultOptions);
    final cartQty = _cartService.getQuantity(product, optionsList);

    emit(state.copyWith(
      selectedOptions: defaultOptions,
      quantity: cartQty > 0 ? cartQty : 1,
    ));
  }

  Future<void> _loadSuggestedProducts() async {
    if (state.product == null) return;

    final allFoods = await _dbService.isar.tblFoods.where()
        .serverIdNotEqualTo(foodId)
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
    }
  }

  void selectOption(int propertyId, TblProductOption option) {
    if (!option.isAvailable || state.product == null) return;
    
    final newOptions = Map<int, TblProductOption>.from(state.selectedOptions);
    newOptions[propertyId] = option;

    // Khi đổi option, kiểm tra xem tổ hợp mới này đã có trong giỏ hàng chưa
    final optionsList = _getSelectedOptionsList(optionsMap: newOptions);
    final cartQty = _cartService.getQuantity(state.product!, optionsList);

    emit(state.copyWith(
      selectedOptions: newOptions,
      quantity: cartQty > 0 ? cartQty : 1,
    ));
  }

  void addToCart() {
    if (state.isAddingToCart || state.product == null) return;
    
    emit(state.copyWith(isAddingToCart: true));
    
    _cartService.upsertCartItem(state.product!, state.quantity, _getSelectedOptionsList());
    
    DbToast.show(
      "Đã thêm vào giỏ hàng thành công",
      gravity: DbToastGravity.top,
      duration: const Duration(milliseconds: 900),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      emit(state.copyWith(isAddingToCart: false));
    });
  }

  List<SelectedOption> _getSelectedOptionsList({Map<int, TblProductOption>? optionsMap}) {
    final list = <SelectedOption>[];
    final targetMap = optionsMap ?? state.selectedOptions;
    final product = state.product;
    if (product == null) return list;
    
    targetMap.forEach((propId, option) {
      final prop = product.properties?.firstWhere((p) => p.serverId == propId);
      list.add(SelectedOption()
        ..optionServerId = option.serverId
        ..groupName = prop?.groupName ?? ""
        ..optionName = option.name
        ..extraPrice = option.extraPrice);
    });
    return list;
  }

  void buyNow() {
    addToCart();
  }

  void goBack() {
    router?.pop();
  }

  @override
  void onNavigateToAllComments(int productId, int type) {
    // Thêm log để kiểm tra xem event đã lên tới Cha chưa
    print("DEBUG: FoodDetailInteractor.onNavigateToAllComments called for product: $productId");
    router?.gotoCommentList(productId, type);
  }
}
