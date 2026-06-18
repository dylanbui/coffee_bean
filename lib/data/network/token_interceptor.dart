/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 16/4/26 - 23:19
 * To change this template use File | Settings | File Templates.
 */

import 'dart:ui';

import 'package:coffee_bean/data/model/response/user/auth_login_response.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:db_core/network/network_client.dart';
import 'package:db_core/network/network_common.dart';
import 'package:dio/dio.dart';

abstract class AuthTokenProvider {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> updateAccessToken(String newAccess, {int? expiresTime});
  Future<void> clearAll();
}

class TokenInterceptor extends QueuedInterceptorsWrapper {
  final NetworkClient client;
  final String refreshPath;
  final VoidCallback onLogout; // Tín hiệu logout cho UI/App layer
  late final NetworkClient _refreshClient;
  final AuthTokenProvider tokenProvider; // Nhận interface được tiêm từ ngoài vào

  TokenInterceptor({
    required this.client,
    required this.refreshPath,
    required this.onLogout,
    required this.tokenProvider,
  }) {
    // Sử dụng trực tiếp client được truyền vào làm refresh client.
    // Client này phải được cấu hình là một "clean client" (không chứa chính TokenInterceptor này).
    _refreshClient = client;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Bỏ qua nếu là API công khai
    if (options.extra["isPublic"] == true) {
      return handler.next(options);
    }

    // Get accessToken insert to Header Auth
    final accessToken = await tokenProvider.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final data = response.data;

    /** 
     * TRƯỜNG HỢP 1: Lỗi 401 nằm trong Body (Business Logic Error)
     * Tại sao phải xử lý ở đây?
     * Một số Server trả về HTTP 200 (Thành công ở tầng vận chuyển) nhưng thực tế 
     * phiên làm việc đã hết hạn (Thất bại ở tầng nghiệp vụ). Dio sẽ không coi đây là Error.
     */
    if (data is Map<String, dynamic> &&
        (data['code'] == 401 || data['code'] == "401") &&
        !response.requestOptions.path.contains(refreshPath)) {
      
      final retryResponse = await _doRefreshAndRetry(response.requestOptions);
      if (retryResponse != null) {
        return handler.resolve(retryResponse);
      }
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    /** 
     * TRƯỜNG HỢP 2: Lỗi 401 HTTP Standard (HTTP Status Code Error)
     * Tại sao phải xử lý ở đây?
     * Đây là cách chuẩn của giao thức HTTP. Khi Server trả về Status 401, 
     * Dio sẽ ném ra DioException và nhảy vào hàm onError này.
     */
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains(refreshPath)) {
      final retryResponse = await _doRefreshAndRetry(err.requestOptions);
      if (retryResponse != null) {
        return handler.resolve(retryResponse);
      }
    }
    
    return handler.next(err);
  }

  // region Private Functions

  /// Thực hiện luồng Refresh Token và thử lại Request cũ
  /// Trả về [Response] nếu retry thành công, [null] nếu thất bại hoàn toàn.
  Future<Response?> _doRefreshAndRetry(RequestOptions options) async {
    final success = await _executeRefreshTokenFlow();
    if (success) {
      // 1. Lấy Token mới vừa được cập nhật trong bộ nhớ
      final newAccess = await tokenProvider.getAccessToken();
      
      // 2. Cập nhật lại Header Authorization cho Request bị lỗi ban đầu
      options.headers["Authorization"] = "Bearer $newAccess";

      try {
        // 3. Thực hiện gọi lại chính Request đó với Token mới (Retry)
        return await client.reTryConnectionWithOption(options: options);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Thực hiện luồng Refresh Token
  Future<bool> _executeRefreshTokenFlow() async {
    final refreshToken = await tokenProvider.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _performLogout();
      return false;
    }

    try {
      // Gọi API Refresh Token (Dùng Query Parameter theo đúng đặc tả OpenAPI)
      final result = await _refreshClient
          .request(refreshPath, 
              type: NetworkType.post, 
              queryParameters: {'refreshToken': refreshToken})
          .mapResponseTo(AuthLoginResponse.fromJson)
          .toObject();

      if (result.data != null) {
        // Cập nhật Access Token mới và thời gian hết hạn vào bộ nhớ của App
        await tokenProvider.updateAccessToken(
          result.data!.accessToken, 
          expiresTime: result.data!.expiresTime
        );
        return true;
      } else {
        await _performLogout();
        return false;
      }
    } catch (e) {
      await _performLogout();
      return false;
    }
  }

  Future<void> _performLogout() async {
    await tokenProvider.clearAll(); // Dọn sạch bộ nhớ của App
    onLogout(); // Phát tín hiệu Callback ra ngoài để UI điều hướng về màn Login
  }

  // endregion
}
