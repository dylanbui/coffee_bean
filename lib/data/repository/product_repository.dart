import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/data/model/category.dart';
import 'package:coffee_bean/data/network/network_response.dart';

class ProductRepository extends BaseRepository {
  ProductRepository({super.client});

  /// Lấy danh sách Product Categories theo storeId
  Future<ResultType<List<Category>>> getProductCategoryList(int? storeId) async {
    return await networkClient
        .request('/app-api/product/category/list', params: {'storeId': storeId})
        .mapResponseTo(Category.fromJson)
        .toList();
  }

  /// Lấy danh sách sản phẩm (SPU) phân trang
  Future<ResultType<ProductPageResult>> getProductSpuPage({
    int? storeId,
    int? categoryId,
    String? keyword,
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    final params = {
      if (storeId != null) 'storeId': storeId,
      if (categoryId != null) 'categoryId': categoryId,
      if (keyword != null) 'keyword': keyword,
      'pageNo': pageNo,
      'pageSize': pageSize,
    };
    return await networkClient
        .request('/app-api/product/spu/page', params: params)
        .mapResponseTo(ProductPageResult.fromJson)
        .toObject();
  }

  /// Lấy chi tiết sản phẩm (SPU Detail bao gồm SKUs)
  Future<ResultType<ProductDetail>> getProductSpuDetail(int id) async {
    return await networkClient
        .request('/app-api/product/spu/get-detail', params: {'id': id})
        .mapResponseTo(ProductDetail.fromJson)
        .toObject();
  }

  /// Tìm kiếm sản phẩm theo danh sách ID
  Future<ResultType<List<Product>>> getProductSpuListByIds(List<int> ids) async {
    return await networkClient
        .request('/app-api/product/spu/list-by-ids', params: {'ids': ids.join(',')})
        .mapResponseTo(Product.fromJson)
        .toList();
  }
}
