import 'dart:async';
import 'package:db_core/commons_constants.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/logger.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/live_service/likes_service.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/data/repository/product_repository.dart';
import 'package:coffee_bean/scenes/rib_samples/product_list/interactor/product_list_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/product_list/product_list_router.dart';

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
        // Force refresh UI by emitting new state. 
        // Since we made Product immutable and Equatable, and we emit a new List instance,
        // it signals a change. We can remove dateTime now as we'll use list replacement.
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

    final result = await _productRepository.getProductSpuPage(pageSize: _limitItem, pageNo: 1);
    
    if (result case DbSuccess(data: final pageResult)) {
      final products = pageResult.list;
      bool hasReachedMax = products.length < _limitItem;
      emit(ProductListGetDataSuccess(products, hasReachedMax, pageResult.total, 1));
    } else if (result case DbFailure(:final error)) {
      emit(ProductListGetDataError(error));
    }
  }

  Future loadMoreData() async {
    final currentState = state;
    if (currentState is ProductListGetDataSuccess && !currentState.hasReachedMax) {
      emit(ProductListInLoadMoreProgress(currentState.items));

      int nextPage = currentState.currentPage + 1;

      final result = await _productRepository.getProductSpuPage(pageSize: _limitItem, pageNo: nextPage);

      if (result case DbSuccess(data: final pageResult)) {
        final newList = pageResult.list;
        bool hasReachedMax = (currentState.items.length + newList.length) >= pageResult.total;
        List<Product> allProducts = currentState.items + newList;

        emit(ProductListGetDataSuccess(allProducts, hasReachedMax, pageResult.total, nextPage));
      } else if (result case DbFailure(:final error)) {
        // Trả về lại state Success cũ để không bị mất list
        emit(ProductListGetDataSuccess(currentState.items, currentState.hasReachedMax, currentState.totalItems, currentState.currentPage));
        eLog("Load more error: ${error.message}");
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
