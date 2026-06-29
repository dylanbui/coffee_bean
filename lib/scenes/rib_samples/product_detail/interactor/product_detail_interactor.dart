/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 07/07/2022 - 19:34
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/db_core.dart';
import 'package:coffee_bean/data/repository/product_repository.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/interactor/product_detail_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/product_detail_router.dart';

class ProductDetailInteractor extends CubitInteractor<ProductDetailRoutable, ProductDetailState> {

  final _productRepository = ProductRepository();
  final int productId;

  ProductDetailInteractor(ProductDetailRoutable router, this.productId) : super(ProductDetailInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadData();
  }

  Future loadData() async {
    emit(ProductDetailInProgress());

    final result = await _productRepository.getProductSpuDetail(productId);
    
    if (result case DbSuccess(data: final product)) {
      emit(ProductDetailGetDataSuccess(product));
    } else if (result case DbFailure(:final error)) {
      emit(ProductDetailGetDataError(error));
    }
  }
}
