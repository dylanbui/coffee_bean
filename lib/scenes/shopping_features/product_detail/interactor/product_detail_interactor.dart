import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/product_detail_builder.dart';
import 'package:db_core/network/network_utils.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/data/repository/product_repository.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_event_state.dart';
import 'package:db_core/utils/toast.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/data/tracking/tracking_service.dart';
import 'dart:math';

class ProductDetailInteractor extends CubitInteractor<ProductDetailRoutable, ProductDetailState> implements CommentListSmallListener {
  final CartService _cartService = locator<CartService>();
  final ProductRepository _productRepository = locator<ProductRepository>();
  final int productId;
  
  // Khởi tạo Controller tại đây để giữ vòng đời bền vững
  final commentController = CommentListSmallController();

  ProductDetailInteractor(ProductDetailRoutable router, this.productId) 
      : super(ProductDetailState(), router: router) {
    // Đăng ký listener ngay khi khởi tạo
    commentController.listener = this;
  }

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadProductDetail();
  }

  Future<void> _loadProductDetail() async {
    emit(state.copyWith(isLoading: true));

    final result = await _productRepository.getProductSpuDetail(productId);

    if (result case DbSuccess(data: final product)) {
      // [TRACKING]: Log product view detail
      appTracking.productAction(
        productId: product.id.toString(),
        action: EventAction.view,
        parameters: {
          'product_name': product.name,
          'category_id': product.categoryId,
        },
      );

      final cartQty = _cartService.getQuantity(product, null);
      emit(state.copyWith(
        product: product, 
        isLoading: false,
        quantity: cartQty > 0 ? cartQty : 1,
      ));
    } else if (result case DbFailure(:final error)) {
      emit(state.copyWith(isLoading: false));
      DbToast.show(error.message);
    }
  }

  void updateQuantity(int delta) {
    final newQty = max(1, state.quantity + delta);
    if (newQty != state.quantity) {
      emit(state.copyWith(quantity: newQty));
    }
  }

  void selectOption(int propertyId, dynamic option) {
  }

  void addToCart() {
    if (state.isAddingToCart || state.product == null) return;
    
    emit(state.copyWith(isAddingToCart: true));
    
    _cartService.upsertCartItem(state.product!, state.quantity, null);
    
    DbToast.show(
      "Đã thêm vào giỏ hàng thành công",
      gravity: DbToastGravity.top,
      duration: const Duration(milliseconds: 900),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      emit(state.copyWith(isAddingToCart: false));
    });
  }

  void buyNow() {
    addToCart();
  }

  void goBack() {
    router?.pop();
  }

  @override
  void onNavigateToAllComments(int productId, int type) {
    router?.gotoCommentList(productId, type);
  }
}
