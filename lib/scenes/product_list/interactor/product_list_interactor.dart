import 'dart:async';
import 'package:coffee_bean/commons/commons_constants.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/commons/utils/logger.dart';
import 'package:coffee_bean/commons/utils/locator.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/live_service/likes_service.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/data/repository/product_repository.dart';
import 'package:coffee_bean/scenes/product_list/interactor/product_list_event_state.dart';
import 'package:coffee_bean/scenes/product_list/product_list_router.dart';

// Cach 2 :
/*
abstract class BlocInteractor<T extends DbNoteRouter, Event, State> extends Bloc<Event, State> {

  T? router;

  BlocInteractor(super.initialState);
}

class UserInterListBloc extends BlocInteractor<UserListRouter, UserListEvent, UserListState> {
  UserInterListBloc({r}) : super(InitListGetDataState()) {
    router = r;
  }
}
*/

class ProductListInteractor extends CubitInteractor<ProductListRoutable, ProductListState> {

  final _productRepository = ProductRepository();
  final _cartService = locator<CartService>();
  final _likesService = locator<LikesService>();
  final _limitItem = 10;

  StreamSubscription? _likesSubscription;

  ProductListInteractor(ProductListRoutable router) : super(ProductListInitial(), router: router);

  @override
  void didBecomeActive() {
    super.didBecomeActive();
    _setupLikesSubscription();
    // Gọi loadData ngay tại đây
    loadData(firstLoad: true);
  }

  void _setupLikesSubscription() {
    _likesSubscription = _likesService.likedStream.listen((likedIds) {
      final currentState = state;
      if (currentState is ProductListGetDataSuccess) {
        // Force refresh UI by emitting new state with updated like status
        emit(ProductListGetDataSuccess(
          List.from(currentState.items),
          currentState.hasReachedMax,
          currentState.totalItems,
          currentState.currentPage,
        ));
      } else if (currentState is ProductListInLoadMoreProgress) {
        emit(ProductListInLoadMoreProgress(List.from(currentState.items)));
      }
    });
  }

  Future onRefresh() async {
    await loadData(firstLoad: false);
  }

  Future loadData({bool firstLoad = false}) async {
    if (firstLoad) {
      emit(ProductListInProgress());
    }

    // Sử dụng Positional Records Destructuring: (products, err)
    final (products, err) = await _productRepository.getProducts(limit: _limitItem, offset: 0);
    if (products != null) {
      bool hasReachedMax = products.length < _limitItem;
      emit(ProductListGetDataSuccess(products, hasReachedMax, products.length, 0));
    } else {
      emit(ProductListGetDataError(err ?? const BaseError(404, "Lỗi không load được dữ liệu")));
    }
  }

  Future loadMoreData() async {
    final currentState = state;
    if (currentState is ProductListGetDataSuccess && !currentState.hasReachedMax) {
      emit(ProductListInLoadMoreProgress(currentState.items));

      // Tính toán offset dựa trên số lượng item hiện có
      int currentOffset = currentState.items.length;

      // Bóc tách theo vị trí (Positional)
      final (newList, err) = await _productRepository.getProducts(limit: _limitItem, offset: currentOffset);

      if (newList != null) {
        bool hasReachedMax = newList.length < _limitItem;
        List<Product> allProducts = currentState.items + newList;

        emit(ProductListGetDataSuccess(allProducts, hasReachedMax, allProducts.length, currentState.currentPage + 1));
      } else {
        // Trả về lại state Success cũ để không bị mất list
        emit(ProductListGetDataSuccess(currentState.items, currentState.hasReachedMax, currentState.totalItems, currentState.currentPage));
        if (err != null) eLog("Load more error: ${err.message}");
      }
    }
  }

  void addToCart(Product product) {
    _cartService.addToCart(product);
  }

  bool isProductLiked(int productId) {
    return _likesService.isLiked(productId);
  }

  void toggleLike(Product product) {
    _likesService.toggleLike(product);
  }

  @override
  void willResignActive() {
    _likesSubscription?.cancel();
    super.willResignActive();
  }
}
