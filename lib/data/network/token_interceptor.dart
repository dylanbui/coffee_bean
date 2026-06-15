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
    Future<void> updateAccessToken(String newAccess);
    Future<void> clearAll();
}

class TokenInterceptor extends QueuedInterceptorsWrapper {

    final NetworkClient client;
    final String refreshPath;
    final VoidCallback onLogout; // Tín hiệu logout cho UI/App layer
    late final NetworkClient _refreshClient;
    final AuthTokenProvider tokenProvider; // Nhận interface được tiêm từ ngoài vào

    TokenInterceptor({required this.client, required this.refreshPath, required this.onLogout, required this.tokenProvider,}) {
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
    void onError(DioException err, ErrorInterceptorHandler handler) async {
        // Chỉ xử lý 401 khi không phải là lỗi từ chính API Refresh
        if (err.response?.statusCode == 401 && !err.requestOptions.path.contains(refreshPath)) {
            final success = await _executeRefreshTokenFlow();
            if (success) {
                // Retry lại request cũ với token mới
                final newAccess = await tokenProvider.getAccessToken();
                final opts = err.requestOptions;
                opts.headers["Authorization"] = "Bearer $newAccess";
                
                final retryResponse = await client.reTryConnectionWithOption(options: opts);
                return handler.resolve(retryResponse);
            } else {
                return handler.next(err);
            }
        } else {
            return handler.next(err);
        }
    }

    // region Private Functions

    /// Thực hiện luồng Refresh Token
    Future<bool> _executeRefreshTokenFlow() async {
        final refreshToken = await tokenProvider.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
            await _performLogout();
            return false;
        }

        try {
            // Gọi API Refresh Token (POST với Query Parameter theo OpenAPI)
            final result = await _refreshClient
                .request(refreshPath, 
                    type: NetworkType.post, 
                    queryParameters: {'refreshToken': refreshToken})
                .mapResponseTo(AuthLoginResponse.fromJson)
                .toObject();

            if (result.data != null) {
                // CHỈ CẬP NHẬT: accessToken
                await tokenProvider.updateAccessToken(result.data!.accessToken);
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

/*

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// Giả định NetworkClient và NetworkConfig của bạn đã được định nghĩa ở nơi khác
// import 'package:your_project/network/network_client.dart';

class TokenInterceptor extends QueuedInterceptorsWrapper {
  final NetworkClient client;
  final String refreshPath;
  final VoidCallback onLogout;
  final AuthTokenProvider tokenProvider; // Nhận interface được tiêm từ ngoài vào

  late final NetworkClient _refreshClient;

  TokenInterceptor({
    required this.client,
    required this.refreshPath,
    required this.onLogout,
    required this.tokenProvider,
  }) {
    // Tạo Instance riêng để gọi API Refresh, tránh dính Interceptor này gây loop vô hạn
    NetworkConfig refreshConfig = NetworkConfig(
      baseUrl: client.config.baseUrl,
      timeout: client.config.timeout
    );
    _refreshClient = NetworkClient(refreshConfig);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Bỏ qua nếu là API công khai
    if (options.extra["isPublic"] == true) {
      return handler.next(options);
    }

    // Lấy cực nhanh từ Cache RAM của UserManager thông qua Interface
    final accessToken = await tokenProvider.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Chỉ xử lý mã lỗi 401 Unauthorized khi không phải lỗi phát ra từ chính API Refresh
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains(refreshPath)) {
      await _handle401(err, handler);
    } else {
      return handler.next(err);
    }
  }

  Future<void> _handle401(DioException err, ErrorInterceptorHandler handler) async {
    final refreshToken = await tokenProvider.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _performLogout();
      return handler.next(err);
    }

    try {
      // Bắn API Refresh Token lên Server
      final response = await _refreshClient.post(
        refreshPath,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccess = response.data['access_token'];

        // Lưu token mới (Hàm này tự động ghi đè lên RAM và đẩy xuống ổ cứng ngầm)
        await tokenProvider.updateAccessToken(newAccess);

        // Đắp Token mới vào Header của Request bị lỗi ban đầu để thử lại (Retry)
        final opts = err.requestOptions;
        opts.headers["Authorization"] = "Bearer $newAccess";

        // Thực hiện tái gọi API (Retry Connection)
        final retryResponse = await client.reTryConnectionWithOption(options: opts);
        return handler.resolve(retryResponse);
      } else {
        await _performLogout();
        return handler.next(err);
      }
    } catch (e) {
      await _performLogout();
      return handler.next(err);
    }
  }

  Future<void> _performLogout() async {
    await tokenProvider.clearAll(); // Dọn sạch bộ nhớ của App
    onLogout(); // Phát tín hiệu Callback ra ngoài để UI điều hướng về màn Login
  }
}



*
* */
