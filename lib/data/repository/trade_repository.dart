import 'package:coffee_bean/data/network/network_response.dart';
import 'package:db_core/db_core.dart';

class TradeRepository extends BaseRepository {
  TradeRepository({super.client});

  // --- SHOPPING CART API ---

  /// Add items to cart: POST /app-api/trade/cart/add
  /// Returns the ID of the newly added/updated cart item
  Future<DbResult<int>> addToCart({required int skuId, required int count}) async {
    return await networkClient
        .request('/app-api/trade/cart/add', 
            type: NetworkType.post, 
            params: {
              'skuId': skuId,
              'count': count,
            })
        .mapResponse()
        .toValue<int>();
  }

  /// Delete shopping cart items: DELETE /app-api/trade/cart/delete
  /// [ids] is a list of shopping cart item IDs (Long[])
  Future<DbResult<bool>> deleteCartItems(List<int> ids) async {
    return await networkClient
        .request('/app-api/trade/cart/delete', 
            type: NetworkType.delete, 
            queryParameters: {'ids': ids.join(',')})
        .mapResponse()
        .toValue<bool>();
  }

  /// Query the number of items in the user's shopping cart: GET /app-api/trade/cart/get-count
  Future<DbResult<int>> getCartCount() async {
    return await networkClient
        .request('/app-api/trade/cart/get-count')
        .mapResponse()
        .toValue<int>();
  }

  /// Query the user's shopping cart list: GET /app-api/trade/cart/list
  Future<DbResult<dynamic>> getCartList() async {
    return await networkClient
        .request('/app-api/trade/cart/list')
        .mapResponse()
        .toObject();
  }

  /// Reset shopping cart items: PUT /app-api/trade/cart/reset
  /// Used when re-selecting SKU or resetting count for a cart item
  Future<DbResult<bool>> resetCartItem({required int id, required int skuId, required int count}) async {
    return await networkClient
        .request('/app-api/trade/cart/reset', 
            type: NetworkType.put, 
            params: {
              'id': id,
              'skuId': skuId,
              'count': count,
            })
        .mapResponse()
        .toValue<bool>();
  }

  /// Update shopping cart item quantity: PUT /app-api/trade/cart/update-count
  Future<DbResult<bool>> updateCartItemCount({required int id, required int count}) async {
    return await networkClient
        .request('/app-api/trade/cart/update-count', 
            type: NetworkType.put, 
            params: {
              'id': id,
              'count': count,
            })
        .mapResponse()
        .toValue<bool>();
  }

  /// Update shopping cart item selections: PUT /app-api/trade/cart/update-selected
  Future<DbResult<bool>> updateCartItemSelected({required List<int> ids, required bool selected}) async {
    return await networkClient
        .request('/app-api/trade/cart/update-selected', 
            type: NetworkType.put, 
            params: {
              'ids': ids,
              'selected': selected,
            })
        .mapResponse()
        .toValue<bool>();
  }
}
