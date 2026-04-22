import 'package:coffee_bean/commons/network/base_repository.dart';
import 'package:coffee_bean/commons/network/network_common.dart';
import 'package:coffee_bean/data/model/product.dart';

class ProductRepository extends BaseRepository {
  ProductRepository({super.client});

  Future<(List<Product>?, NetworkError?)> getProducts({int limit = 10, int offset = 0}) async {
    return await networkClient.request('/products', params: {'limit': limit, 'offset': offset}).mapToObjectList(Product.fromJson);
  }

  Future<(Product?, NetworkError?)> getProductDetail(int productId) async {
    return await networkClient.request('/products/$productId').mapToObject<Product>(Product.fromJson);
  }

  // Future<ResultType<Product>> getProductDetail(int productId) async {
  //   return await networkClient.request('/products/$productId').mapToObject<Product>(Product.fromJson);
  // }

}
