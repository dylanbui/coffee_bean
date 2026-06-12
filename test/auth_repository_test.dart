import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:db_core/network/network_client.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/network/token_interceptor.dart';
import 'package:coffee_bean/data/network/header_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class MockTokenProvider implements AuthTokenProvider {
  String? _token;
  @override
  Future<String?> getAccessToken() async => _token;
  @override
  Future<String?> getRefreshToken() async => "MOCK_REFRESH_TOKEN";
  @override
  Future<void> updateAccessToken(String newAccess) async => _token = newAccess;
  @override
  Future<void> clearAll() async => _token = null;
  
  void setToken(String token) => _token = token;

  bool get hasToken => _token != null;
}

void main() {
  late AuthRepository authRepository;
  late MockTokenProvider tokenProvider;

  setUp(() {
    tokenProvider = MockTokenProvider();
    
    final config = NetworkConfig(
      baseUrl: "https://inter.tmlabs.ai",
      timeout: const Duration(seconds: 5),
      interceptors: [
        HeaderInterceptor(headers: {
          "tenantId": "162",
        }),
        TokenInterceptor(
          client: NetworkClient(NetworkConfig(baseUrl: "https://inter.tmlabs.ai")),
          refreshPath: "/app-api/member/auth/refresh-token",
          onLogout: () {},
          tokenProvider: tokenProvider,
        ),
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      ],
    );

    final client = NetworkClient(config);
    authRepository = AuthRepository(client: client);
  });

  test('Full Workflow Test: Send SMS -> Login -> Reset Password', () async {
    const mobile = "+840988123456";
    const code = "9999";
    const newPassword = "coffee123";

    debugPrint("\n🚀 --- STARTING WORKFLOW TEST --- 🚀");

    debugPrint("\n👉 STEP 1: SEND SMS CODE");
    final res1 = await authRepository.sendSmsCode(mobile, 1);
    debugPrint("Result Step 1: Success = ${res1.toResult().isSuccess}, Error = ${res1.toResult().errorOrNull?.message}");
    
    debugPrint("\n👉 STEP 2: SMS LOGIN");
    final res2 = await authRepository.smsLogin(mobile, code);
    debugPrint("Result Step 2: Success = ${res2.toResult().isSuccess}, Error = ${res2.toResult().errorOrNull?.message}");

    if (res2.toResult().isSuccess) {
      final token = res2.toResult().dataOrNull?.accessToken;
      debugPrint("Received Access Token: $token");
      tokenProvider.setToken(token!);
    } else {
      debugPrint("Skipping Step 3 due to Login failure.");
    }

    debugPrint("\n👉 STEP 3: RESET PASSWORD");
    if (tokenProvider.hasToken) {
      final res3 = await authRepository.resetPassword(mobile, code, newPassword);
      debugPrint("Result Step 3: Success = ${res3.toResult().isSuccess}, Error = ${res3.toResult().errorOrNull?.message}");
    }
    
    debugPrint("\n🏁 --- WORKFLOW TEST FINISHED --- 🏁");
  });
}
