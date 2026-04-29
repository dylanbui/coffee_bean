import 'dart:async';
import 'package:coffee_bean/commons/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/commons/utils/locator.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/scenes/rib_samples/product_cart/interactor/product_cart_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/product_cart/product_cart_router.dart';


class ProductCartInteractor extends CubitInteractor<ProductCartRouter, ProductCartState> {
  final CartService _cartService = locator<CartService>();
  StreamSubscription? _cartSubscription;

  ProductCartInteractor(ProductCartRouter router) : super(ProductCartInitial(), router: router);

  @override
  void didBecomeActive() {
    super.didBecomeActive();
    _setupSubscription();
  }

  void _setupSubscription() {
    _cartSubscription = _cartService.cartStream.listen((items) {
      emit(ProductCartGetDataSuccess(items, _cartService.totalAmount));
    });
  }

  void updateQuantity(String cartItemId, int quantity) {
    _cartService.updateQuantity(cartItemId, quantity);
  }

  void removeItem(String cartItemId) {
    _cartService.removeItem(cartItemId);
  }

  void gotoDetail(Product product) {
      router?.navigate(ProductDetailRoute(product.id));
  }

  @override
  void willResignActive() {
    _cartSubscription?.cancel();
    super.willResignActive();
  }
}
