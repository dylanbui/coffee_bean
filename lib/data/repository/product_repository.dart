import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/data/model/category.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:db_core/db_core.dart';

class ProductRepository extends BaseRepository {
  ProductRepository({super.client});

  /// Lấy dữ liệu Shopping tổng hợp (Categories + Products) kèm Cache
  Future<DbResult<ShoppingData>> getShoppingData(int? storeId, {DbCacheConfig? cacheConfig}) async {
    final cache = locator<DbCacheProvider>();

    // 1. Thử lấy từ Cache
    if (cacheConfig != null && !cacheConfig.forceRefresh) {
      final cachedJson = await cache.get(cacheConfig.key);
      if (cachedJson != null) {
        return DbSuccess(ShoppingData.fromJson(cachedJson as Map<String, dynamic>));
      }
    }

    // 2. Gọi API song song
    final results = await Future.wait([
      getProductCategoryList(storeId),
      getProductSpuPage(storeId: storeId, pageSize: 200),
    ]);

    // Chuyển đổi từ ResultType (Record) sang DbResult (Sealed Class) để pattern matching đồng nhất
    final resCat = (results[0] as ResultType<List<Category>>).toResult();
    final resSpu = (results[1] as ResultType<ProductPageResult>).toResult();

    if (resCat is DbSuccess<List<Category>> && resSpu is DbSuccess<ProductPageResult>) {
      final categories = resCat.data;
      final products = resSpu.data.list;

      // 3. Xử lý Grouping
      final productsByCategory = <int, List<Product>>{};
      for (var cat in categories) {
        productsByCategory[cat.id] = products.where((p) => p.categoryId == cat.id).toList();
      }

      final shoppingData = ShoppingData(
        categories: categories,
        allProducts: products,
        productsByCategory: productsByCategory,
      );

      // 4. Lưu Cache
      if (cacheConfig != null) {
        await cache.set(
          cacheConfig.key,
          shoppingData.toJson(),
          ttl: cacheConfig.duration,
          group: cacheConfig.group,
        );
      }

      return DbSuccess(shoppingData);
    }

    // Ưu tiên trả về lỗi từ API nếu có
    final error = resCat.errorOrNull ?? resSpu.errorOrNull ?? NetworkError(500, "Unknown Error");
    return DbFailure(error);
  }

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
