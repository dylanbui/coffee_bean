/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 07/07/2022 - 19:34
 * To change this template use File | Settings | File Templates.
 */

// Provider

import 'package:coffee_bean/commons/commons_constants.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/commons/utils/logger.dart';
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
  final _limitItem = 10;

  ProductListInteractor(ProductListRoutable router) : super(ProductListInitial(), router: router) {
    // Gọi loadData ngay tại đây
    loadData(firstLoad: true);
  }

  Future onRefresh() async {
    await loadData(firstLoad: false);
  }

  Future loadData({bool firstLoad = false}) async {
    if (firstLoad) {
      emit(ProductListInProgress());
    }

    // router.gotoPostDetail(productDetail);

    // Sử dụng Positional Records Destructuring: (products, err)
    final (products, err) = await _productRepository.getProducts(limit: _limitItem, offset: 0);
    if (products != null) {
      // Giả sử mỗi page 10 item, nếu lấy được ít hơn 10 tức là đã hết dữ liệu
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
}
