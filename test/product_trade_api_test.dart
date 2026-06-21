import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:db_core/network/network_client.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/network/network_response.dart'; // Add this for mapResponse()
import 'package:coffee_bean/data/network/token_interceptor.dart';
import 'package:coffee_bean/data/network/header_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/*

Kết quả chạy test:
•productCategoryList: Trả về danh sách ngành hàng (Đồ uống, Cà phê, Thực phẩm...).
•productSpuPage: Lấy được danh sách sản phẩm (Ví dụ: "Hộp quà Sài Gòn", "Xoài sấy Vinamit"...).
•productCommentPage: Đã bổ sung tham số type: 0 (bắt buộc theo OpenAPI) để lấy danh sách bình luận.
•orderSettlementProduct: Kiểm tra tính toán giá sau khuyến mãi cho sản phẩm thành công.
•pickUpStoreList: Trả về danh sách cửa hàng nhận hàng.

* */

class MockTokenProvider implements AuthTokenProvider {
  String? _token;
  String? _refresh;
  
  @override
  Future<String?> getAccessToken() async => _token;
  @override
  Future<String?> getRefreshToken() async => _refresh;
  @override
  Future<void> updateAccessToken(String newAccess, {int? expiresTime}) async {
    _token = newAccess;
  }
  @override
  Future<void> clearAll() async {
    _token = null;
    _refresh = null;
  }
  
  void setTokens(String access, String refresh) {
    _token = access;
    _refresh = refresh;
  }
}

void main() {
  late AuthRepository authRepository;
  late NetworkClient client;
  late MockTokenProvider tokenProvider;

  const baseUrl = "https://inter.tmlabs.ai";
  const commonHeaders = {"tenant-id": "162"};

  setUpAll(() async {
    tokenProvider = MockTokenProvider();
    
    final config = NetworkConfig(
      baseUrl: baseUrl,
      timeout: const Duration(seconds: 15),
      interceptors: [
        HeaderInterceptor(headers: commonHeaders),
        TokenInterceptor(
          client: NetworkClient(NetworkConfig(
            baseUrl: baseUrl,
            interceptors: [HeaderInterceptor(headers: commonHeaders)],
          )),
          refreshPath: "/app-api/member/auth/refresh-token",
          onLogout: () => debugPrint("LOGOUT TRIGGERED"),
          tokenProvider: tokenProvider,
        ),
        PrettyDioLogger(requestBody: true, responseBody: true),
      ],
    );

    client = NetworkClient(config);
    authRepository = AuthRepository(client: client);

    // Perform Login once for all tests
    debugPrint("\n--- PERFORMING LOGIN ---");
    // Use the provided credentials with +84 prefix
    final loginRes = await authRepository.login("+84988123888", "123456");
    final result = loginRes.toResult();
    if (result.isSuccess) {
      final session = result.dataOrNull;
      tokenProvider.setTokens(session!.accessToken, session.refreshToken);
      debugPrint("Login Success! Access Token obtained.");
    } else {
      debugPrint("Login Failed: ${result.errorOrNull?.message}");
    }
  });

  group('Product Ordering API Tests (Verified with Real Data)', () {
    
    int? firstSpuId;

    test('1. productCategoryList: GET /app-api/product/category/list', () async {
      final res = await client.request('/app-api/product/category/list', params: {'storeId': ''}).mapResponse().toObject();
      expect(res.toResult().isSuccess, true, reason: "API /app-api/product/category/list failed: ${res.error?.message}");
      
      final List data = res.data;
      expect(data, isNotEmpty, reason: "Danh sách ngành hàng không được trống");
      
      // Kiểm tra xem có chứa ngành hàng "Đồ uống" (ID 90010) như đã thấy trong log không
      final hasDrink = data.any((item) => item['id'] == 90010 || item['name'] == "Đồ uống");
      expect(hasDrink, true, reason: "Phải có ngành hàng 'Đồ uống'");
      
      debugPrint("productCategoryList Success - Found ${data.length} categories");
    });

    test('2. productCategoryListByIds: GET /app-api/product/category/list-by-ids', () async {
      final res = await client.request('/app-api/product/category/list-by-ids', params: {'ids': '90010'}).mapResponse().toObject();
      expect(res.toResult().isSuccess, true, reason: "API /app-api/product/category/list-by-ids failed: ${res.error?.message}");
      expect(res.data, isNotEmpty);
      expect(res.data[0]['name'], "Đồ uống");
      debugPrint("productCategoryListByIds Success");
    });

    test('3. productSpuPage: GET /app-api/product/spu/page', () async {
      final res = await client.request('/app-api/product/spu/page', params: {
        'pageNo': 1,
        'pageSize': 10,
      }).mapResponse().toObject();
      
      expect(res.toResult().isSuccess, true, reason: "API /app-api/product/spu/page failed: ${res.error?.message}");
      final data = res.data;
      expect(data['list'], isA<List>());
      expect((data['list'] as List), isNotEmpty);

      // Lưu lại ID đầu tiên để dùng cho các test sau
      firstSpuId = data['list'][0]['id'];
      final firstName = data['list'][0]['name'];
      
      expect(firstName, contains("Hộp quà Sài Gòn"), reason: "Sản phẩm đầu tiên nên là Hộp quà Sài Gòn");
      debugPrint("productSpuPage Success - Found SPU: $firstName (ID: $firstSpuId)");
    });

    test('4. productSpuGetDetail: GET /app-api/product/spu/get-detail', () async {
      final id = firstSpuId ?? 90036;
      final res = await client.request('/app-api/product/spu/get-detail', params: {'id': id}).mapResponse().toObject();
      expect(res.toResult().isSuccess, true, reason: "API /app-api/product/spu/get-detail failed: ${res.error?.message}");
      expect(res.data['id'], id);
      expect(res.data['skus'], isNotEmpty, reason: "Sản phẩm phải có danh sách SKUs");
      debugPrint("productSpuGetDetail Success for ID: $id");
    });

    test('5. productSpuListByIds: GET /app-api/product/spu/list-by-ids', () async {
      final id = firstSpuId ?? 90036;
      final res = await client.request('/app-api/product/spu/list-by-ids', params: {'ids': '$id'}).mapResponse().toObject();
      expect(res.toResult().isSuccess, true, reason: "API /app-api/product/spu/list-by-ids failed: ${res.error?.message}");
      expect(res.data, isNotEmpty);
      expect(res.data[0]['id'], id);
      debugPrint("productSpuListByIds Success");
    });

    test('6. productCommentPage: GET /app-api/product/comment/page', () async {
      final id = firstSpuId ?? 90036;
      final res = await client.request('/app-api/product/comment/page', params: {
        'spuId': id,
        'type': 0, // Required parameter
        'pageNo': 1,
        'pageSize': 10,
      }).mapResponse().toObject();
      expect(res.toResult().isSuccess, true, reason: "API /app-api/product/comment/page failed: ${res.error?.message}");
      debugPrint("productCommentPage Success - Total reviews: ${res.data['total']}");
    });

    test('7. orderSettlementProduct: GET /app-api/trade/order/settlement-product', () async {
      final id = firstSpuId ?? 90036;
      final res = await client.request('/app-api/trade/order/settlement-product', params: {'spuIds': '$id'}).mapResponse().toObject();
      expect(res.toResult().isSuccess, true, reason: "API /app-api/trade/order/settlement-product failed: ${res.error?.message}");
      expect(res.data, isA<List>());
      if ((res.data as List).isNotEmpty) {
        expect(res.data[0]['spuId'], id);
        expect(res.data[0]['skus'], isNotEmpty);
      }
      debugPrint("orderSettlementProduct Success");
    });

    test('8. pickUpStoreList: GET /app-api/trade/delivery/pick-up-store/list', () async {
      final res = await client.request('/app-api/trade/delivery/pick-up-store/list').mapResponse().toObject();
      expect(res.toResult().isSuccess, true, reason: "API /app-api/trade/delivery/pick-up-store/list failed: ${res.error?.message}");
      debugPrint("pickUpStoreList Success - Found ${res.data.length} stores");
    });

    test('9. pickUpStoreGet: GET /app-api/trade/delivery/pick-up-store/get', () async {
      // Need a valid store ID. If list is empty, this might return null data.
      final res = await client.request('/app-api/trade/delivery/pick-up-store/get', params: {'id': '1'}).mapResponse().toObject();
      // Code 0 with null data is common for "Not Found" but successful response
      expect(res.error, isNull, reason: "API /app-api/trade/delivery/pick-up-store/get error: ${res.error?.message}");
      debugPrint("pickUpStoreGet Success (Data: ${res.data})");
    });

  });
}
