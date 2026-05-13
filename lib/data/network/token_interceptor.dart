/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 16/4/26 - 23:19
 * To change this template use File | Settings | File Templates.
 */

import 'dart:ui';

import 'package:coffee_bean/core/network/network_client.dart';
import 'package:coffee_bean/core/network/network_common.dart';
import 'package:coffee_bean/data/local/user_session.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends QueuedInterceptorsWrapper {

    final NetworkClient client;
    final String refreshPath;
    final VoidCallback onLogout; // Tín hiệu logout cho UI/App layer
    late final NetworkClient _refreshClient;

    TokenInterceptor({required this.client, required this.refreshPath, required this.onLogout,}) {
        // Instance riêng để gọi Refresh API, tránh bị loop bởi chính interceptor này
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
        // Get accessToken insert to Header Auth
        final accessToken = await _getAccessTokenFromStorage();
        if (accessToken != null && accessToken.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $accessToken";
        }
        return handler.next(options);
    }

    @override
    void onError(DioException err, ErrorInterceptorHandler handler) async {
        // Chỉ xử lý 401 khi không phải là lỗi từ chính API Refresh
        if (err.response?.statusCode == 401 && !err.requestOptions.path.contains(refreshPath)) {
            await _handle401(err, handler);
        } else {
            return handler.next(err);
        }
    }

    // region Private Functions

    Future<void> _handle401(DioException err, ErrorInterceptorHandler handler) async {
        // final refreshToken = await LocalStorage.getRefreshToken();
        final refreshToken = await _getRefreshTokenFromStorage();
        if (refreshToken == null) {
            _performLogout();
            return handler.next(err);
        }

        try {
            // TODO: Gọi Refresh API
            // TODO: Cho nay chua hoan thanh, khi su dung den day, phai kiem tra ham ben duoi coi goi len server
            // kieu tra ve la gi, con phai xư ly them
            // Temporarily not fixing the expired token bug
            _performLogout();

            // final response = await _refreshClient.makeCall(refreshPath, type: NetworkType.post, params: {'refresh_token': refreshToken});
            // final response = await _refreshDio.post(refreshPath, data: {'refresh_token': refreshToken});
            // if (response.statusCode == 200) {
            //     final newAccess = response.data['access_token'];
            //     final newRefresh = response.data['refresh_token'];
            //
            //     // await LocalStorage.saveTokens(newAccess, newRefresh);
            //     await _saveTokenToStorage(newAccess, newRefresh);
            //
            //     // Retry lại request cũ với token mới
            //     final opts = err.requestOptions;
            //     opts.headers["Authorization"] = "Bearer $newAccess";
            //
            //     final retryResponse = await client.reTryConnectionWithOption(options: opts);// dio.fetch(opts);
            //     return handler.resolve(retryResponse);
            // }
        } catch (e) {
            _performLogout();
            return handler.next(err);
        }
    }

    // --- Các hàm bổ trợ logic (Thay bằng storage thực tế của bạn) ---
    Future<String?> _getAccessTokenFromStorage() async {
        return UserSession.readAccessToken();
    }

    Future<String?> _getRefreshTokenFromStorage() async {
        return UserSession.readRefreshToken();
    }

    Future<void> _saveTokenToStorage(String accessToken, String refreshToken) async {
        UserSession.updateAccessToken(accessToken);
    }

    Future<String?> _performRefreshToken() async {
        // Gọi API refresh ở đây
        return "NEW_ACCESS_TOKEN";
    }

    void _performLogout() {
        // Clear Token
        UserSession.clearAll();
        onLogout(); // Gọi tín hiệu ra ngoài app
    }
    // endregion

}


