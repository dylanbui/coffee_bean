import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:db_core/network/network_client.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/network/token_interceptor.dart';
import 'package:coffee_bean/data/network/header_interceptor.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Mock Provider để quản lý token thủ công trong lúc test
class TestTokenProvider implements AuthTokenProvider {
  String? _accessToken;
  String? _refreshToken;
  int? _expiresTime;

  @override
  Future<String?> getAccessToken() async => _accessToken;
  @override
  Future<String?> getRefreshToken() async => _refreshToken;
  @override
  Future<void> updateAccessToken(String newAccess, {int? expiresTime}) async {
    _accessToken = newAccess;
    if (expiresTime != null) _expiresTime = expiresTime;
  }
  @override
  Future<void> clearAll() async {
    _accessToken = null;
    _refreshToken = null;
    _expiresTime = null;
  }
  
  void setTokens(String access, String refresh, {int? expires}) {
    _accessToken = access;
    _refreshToken = refresh;
    _expiresTime = expires;
  }

  int? get expiresTime => _expiresTime;

  void expireAccessToken() => _accessToken = "INVALID_OR_EXPIRED_TOKEN";
}

void main() {
  late AuthRepository authRepository;
  late UserRepository userRepository;
  late TestTokenProvider tokenProvider;
  late NetworkClient mainClient;

  setUp(() {
    tokenProvider = TestTokenProvider();
    const baseUrl = "https://inter.tmlabs.ai";
    
    // 1. Tạo một "clean client" cho việc refresh token (không có TokenInterceptor để tránh loop)
    final cleanClient = NetworkClient(NetworkConfig(
      baseUrl: baseUrl,
      interceptors: [
        HeaderInterceptor(headers: {"tenant-id": "162"}),
      ],
    ));

    // 2. Cấu hình Main Network Client
    final config = NetworkConfig(
      baseUrl: baseUrl,
      timeout: const Duration(seconds: 15),
      interceptors: [
        HeaderInterceptor(headers: {"tenant-id": "162"}),
        TokenInterceptor(
          client: cleanClient, // Truyền cleanClient vào đây
          refreshPath: "/app-api/member/auth/refresh-token",
          tokenProvider: tokenProvider,
          onLogout: () => debugPrint("❌ [Test] Session Expired - Logout forced"),
        ),
        PrettyDioLogger(
          requestHeader: true, 
          requestBody: true, 
          responseHeader: true,
          responseBody: true
        ),
      ],
    );

    mainClient = NetworkClient(config);
    authRepository = AuthRepository(client: mainClient);
    userRepository = UserRepository(client: mainClient);
  });

  test('Auth & User Repository Flow Test', () async {
    const mobile = "+84988123458";
    const password = "123456";

    debugPrint("\n🚀 --- BẮT ĐẦU TEST LUỒNG AUTH & USER --- 🚀");

    // BƯỚC 1: Login với Username/Password
    debugPrint("\n👉 STEP 1: LOGIN (POST /app-api/member/auth/login)");
    final loginRes = await authRepository.login(mobile, password);
    
    if (loginRes case DbSuccess(data: final authData)) {
      debugPrint("✅ Login thành công!");
      debugPrint("AccessToken: ${authData.accessToken.substring(0, 15)}...");
      debugPrint("ExpiresAt: ${UtcUtils.formatTimestamp(authData.expiresTime ?? 0)}");
      tokenProvider.setTokens(authData.accessToken, authData.refreshToken, expires: authData.expiresTime);
      
      // BƯỚC 2: Lấy thông tin User
      debugPrint("\n👉 STEP 2: GET USER INFO (GET /app-api/member/user/get)");
      final userRes = await userRepository.getUserInfo();
      if (userRes case DbSuccess(data: final user)) {
        debugPrint("✅ Lấy profile thành công: ${user.nickname} (ID: ${user.id})");
      } else if (userRes case DbFailure(:final error)) {
        debugPrint("❌ Lấy profile thất bại: ${error.message}");
      }

      // BƯỚC 3: Chủ động Refresh Token
      debugPrint("\n👉 STEP 3: ACTIVE REFRESH TOKEN (POST /app-api/member/auth/refresh-token)");
      final refreshRes = await authRepository.refreshToken(authData.refreshToken);
      if (refreshRes case DbSuccess(data: final newAuth)) {
        debugPrint("✅ Chủ động Refresh thành công.");
        debugPrint("New AccessToken: ${newAuth.accessToken.substring(0, 15)}...");
        debugPrint("New ExpiresAt: ${UtcUtils.formatTimestamp(newAuth.expiresTime ?? 0)}");
        tokenProvider.setTokens(newAuth.accessToken, newAuth.refreshToken, expires: newAuth.expiresTime);
      } else if (refreshRes case DbFailure(:final error)) {
        debugPrint("❌ Chủ động Refresh thất bại: ${error.message}");
      }

      // BƯỚC 4: Giả lập hết hạn Access Token để test Auto-Refresh của Interceptor
      debugPrint("\n👉 STEP 4: SIMULATE EXPIRED ACCESS TOKEN & CALL USER INFO");
      tokenProvider.expireAccessToken(); // Làm hỏng Access Token trong provider
      
      // Lần gọi này, Interceptor sẽ gửi request với "INVALID_OR_EXPIRED_TOKEN"
      // Server trả về 401 -> Interceptor tự động thực hiện _executeRefreshTokenFlow
      // Sau đó Retry lại request cũ.
      final userResRetry = await userRepository.getUserInfo();
      
      if (userResRetry case DbSuccess(data: final user)) {
        debugPrint("✅ Auto-Refresh & Retry thành công! Profile: ${user.nickname}");
      } else if (userResRetry case DbFailure(:final error)) {
        debugPrint("❌ Auto-Refresh thất bại: ${error.message}");
      }

    } else if (loginRes case DbFailure(:final error)) {
      fail("Login thất bại ngay từ đầu: ${error.message}");
    }
    
    debugPrint("\n🏁 --- KẾT THÚC TEST --- 🏁");
  });
}
