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

    final resCat = results[0] as DbResult<List<Category>>;
    final resSpu = results[1] as DbResult<ProductPageResult>;

    if (resCat case DbSuccess(data: final categories)) {
      if (resSpu case DbSuccess(data: final spuData)) {
        final products = spuData.list;

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
    }

    // Ưu tiên trả về lỗi từ API nếu có
    final error = resCat.errorOrNull ?? resSpu.errorOrNull ?? NetworkError(500, "Unknown Error");
    return DbFailure(error);
  }

  /// Lấy danh sách Product Categories theo storeId
  Future<DbResult<List<Category>>> getProductCategoryList(int? storeId) async {
    return await networkClient
        .request('/app-api/product/category/list', params: {'storeId': storeId})
        .mapResponseTo(Category.fromJson)
        .toList();
  }

  /// Lấy danh sách sản phẩm (SPU) phân trang
  Future<DbResult<ProductPageResult>> getProductSpuPage({
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
  Future<DbResult<ProductDetail>> getProductSpuDetail(int id) async {
    final result = await networkClient
        .request('/app-api/product/spu/get-detail', params: {'id': id})
        .mapResponseTo(ProductDetail.fromJson)
        .toObject();

    if (result case DbSuccess(data: final detail)) {
      // GIẢ LẬP DATA ĐỂ TEST UI (MOCK DATA)
      final mockSkus = <Sku>[];
      final sizes = [
        {'id': 10, 'name': 'Size S', 'price': 120000},
        {'id': 11, 'name': 'Size M', 'price': 145000},
        {'id': 12, 'name': 'Size L', 'price': 160000},
      ];
      final sugars = [
        {'id': 20, 'name': '0% Đường'},
        {'id': 21, 'name': '50% Đường'},
        {'id': 22, 'name': '100% Đường'},
      ];

      int skuIdCounter = 1000;
      for (var size in sizes) {
        for (var sugar in sugars) {
          mockSkus.add(Sku(
            id: skuIdCounter++,
            price: size['price'] as int,
            marketPrice: (size['price'] as int) + 20000,
            picUrl: detail.picUrl,
            stock: 50,
            properties: [
              SkuProperty(
                propertyId: 1,
                propertyName: 'Kích thước',
                valueId: size['id'] as int,
                valueName: size['name'] as String,
              ),
              SkuProperty(
                propertyId: 2,
                propertyName: 'Mức đường',
                valueId: sugar['id'] as int,
                valueName: sugar['name'] as String,
              ),
            ],
          ));
        }
      }

      final mockDetail = ProductDetail(
        id: detail.id,
        name: detail.name,
        introduction: detail.introduction,
        categoryId: detail.categoryId,
        picUrl: detail.picUrl,
        sliderPicUrls: detail.sliderPicUrls,
        specType: true, // Bật specType để UI hiểu là có nhiều option
        price: detail.price,
        marketPrice: detail.marketPrice,
        stock: detail.stock,
        salesCount: detail.salesCount,
        description: detail.description,
        deliveryTypes: detail.deliveryTypes,
        skus: mockSkus, // Thay bằng danh sách mock
      );

      return DbSuccess(mockDetail);
    }

    return result;
  }

  /// Tìm kiếm sản phẩm theo danh sách ID
  Future<DbResult<List<Product>>> getProductSpuListByIds(List<int> ids) async {
    return await networkClient
        .request('/app-api/product/spu/list-by-ids', params: {'ids': ids.join(',')})
        .mapResponseTo(Product.fromJson)
        .toList();
  }
}
