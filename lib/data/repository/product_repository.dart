import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/data/network/network_response.dart';

class ProductRepository extends BaseRepository {
  ProductRepository({super.client});

  /// 1. Sử dụng GET với tham số (Chaining - Khuyên dùng)
  /// Trả về danh sách sản phẩm, tự động bóc vỏ {code, msg, data}
  Future<ResultType<List<Product>>> getProducts({int limit = 10, int offset = 0}) async {
    return await networkClient
        .request('/products', params: {'limit': limit, 'offset': offset})
        .mapResponseTo(Product.fromJson)
        .toList();
  }

  /// 2. Sử dụng GET cho chi tiết (Chaining)
  Future<ResultType<Product>> getProductDetail(int productId) async {
    return await networkClient
        .request('/products/$productId')
        .mapResponseTo(Product.fromJson)
        .toObject();
  }

  /// 3. Ví dụ sử dụng POST để tạo sản phẩm mới
  Future<ResultType<Product>> createProduct(Product product) async {
    return await networkClient
        .request('/products', type: NetworkType.post, params: product.toJson())
        .mapResponseTo(Product.fromJson)
        .toObject();
  }

  /// 4. Ví dụ sử dụng hàm mapToObject cũ (Không có vỏ bọc JSON Project)
  /// Dùng khi API trả về trực tiếp dữ liệu (Map hoặc List) mà không có code/msg/data
  Future<ResultType<Product>> getRawProductDetail(int productId) async {
    return await networkClient
        .request('/products/$productId')
        .mapTo(Product.fromJson) // Lưu ý: mapTo thay vì mapResponseTo
        .toObject();
  }
}
