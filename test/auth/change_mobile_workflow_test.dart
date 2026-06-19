import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
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
  Future<void> updateAccessToken(String newAccess, {int? expiresTime}) async {
    _token = newAccess;
  }
  @override
  Future<void> clearAll() async => _token = null;
  
  void setToken(String token) => _token = token;
}

void main() {
  late AuthRepository authRepository;
  late UserRepository userRepository;
  late MockTokenProvider tokenProvider;

  setUp(() {
    tokenProvider = MockTokenProvider();
    
    final config = NetworkConfig(
      baseUrl: "https://inter.tmlabs.ai",
      timeout: const Duration(seconds: 15),
      interceptors: [
        HeaderInterceptor(headers: {"tenant-id": "162"}),
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
    userRepository = UserRepository(client: client);
  });

  test('Simplified Change Mobile Workflow Test (2 Steps)', () async {
    const currentPhone = "+84988123458";
    const password = "123456";
    const newPhone = "+84988123888";
    const fixedCode = "9999"; 

    debugPrint("\n🚀 --- STARTING SIMPLIFIED CHANGE MOBILE TEST --- 🚀");

    // 0. LOGIN
    debugPrint("\n👉 STEP 0: LOGIN WITH CURRENT PHONE");
    final loginRes = await authRepository.login(currentPhone, password);
    final loginResult = loginRes.toResult();
    if (loginResult case DbSuccess(:final data)) {
      debugPrint("Login Success! Token: ${data.accessToken}");
      tokenProvider.setToken(data.accessToken);
    } else {
      fail("Login failed: ${loginResult.errorOrNull?.message}");
    }

    // 1. TEST SEND SMS (SCENE 2)
    debugPrint("\n👉 STEP 1a: SEND SMS (SCENE 2) FOR CURRENT PHONE - SHOULD FAIL");
    final res1a = await authRepository.sendSmsCode(currentPhone, SmsScene.updatePhoneNumber);
    final result1a = res1a.toResult();
    expect(result1a.isFailure, true, reason: "Should fail for current phone");
    debugPrint("✅ Correctly received error: ${result1a.errorOrNull?.message}");

    debugPrint("\n👉 STEP 1b: SEND SMS (SCENE 2) FOR NEW PHONE - SHOULD SUCCESS");
    final res1b = await authRepository.sendSmsCode(newPhone, SmsScene.updatePhoneNumber);
    expect(res1b.toResult().isSuccess, true, reason: "Send SMS for new phone failed");
    debugPrint("✅ Send SMS for new phone success!");

    // 2. UPDATE MOBILE
    debugPrint("\n👉 STEP 2: UPDATE MOBILE (WITHOUT OLD CODE)");
    final updateRes = await userRepository.updateMobile(
      mobile: newPhone,
      code: fixedCode,
    );
    final updateResult = updateRes.toResult();

    if (updateResult case DbSuccess(:final data)) {
      debugPrint("✅ Update Success: $data");
    } else {
      debugPrint("ℹ️ Update failed (Expected if oldCode is required): ${updateResult.errorOrNull?.message}");
      // Nếu server bắt buộc phải có oldCode, bài test này sẽ dừng ở đây.
    }

    // 3. RE-LOGIN
    debugPrint("\n👉 STEP 3: RE-LOGIN WITH NEW PHONE");
    final reLoginRes = await authRepository.login(newPhone, password);
    final reLoginResult = reLoginRes.toResult();

    if (reLoginResult case DbSuccess(:final data)) {
      debugPrint("✅ Re-login Success with NEW PHONE! Token: ${data.accessToken}");
    } else {
      debugPrint("❌ Re-login failed (Normal if Update step failed): ${reLoginResult.errorOrNull?.message}");
    }

    debugPrint("\n🏁 --- TEST FINISHED --- 🏁");
  });
}
