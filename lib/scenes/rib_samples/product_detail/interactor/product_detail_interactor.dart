/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 07/07/2022 - 19:34
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/commons_constants.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
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

    final (product, error) = await _productRepository.getProductDetail(productId);
    if (product != null) {
      emit(ProductDetailGetDataSuccess(product));
    } else {
      emit(ProductDetailGetDataError(error ?? const BaseError(404, "Lỗi không load được dữ liệu")));
    }
  }
}
