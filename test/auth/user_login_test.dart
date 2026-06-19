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

class MockTokenProvider implements AuthTokenProvider {
  String? _token;
  String? _refresh;
  int? _expires;
  
  @override
  Future<String?> getAccessToken() async => _token;
  @override
  Future<String?> getRefreshToken() async => _refresh;
  @override
  Future<void> updateAccessToken(String newAccess, {int? expiresTime}) async {
    _token = newAccess;
    if (expiresTime != null) _expires = expiresTime;
  }
  @override
  Future<void> clearAll() async {
    _token = null;
    _refresh = null;
    _expires = null;
  }
  
  void setTokens(String access, String refresh, {int? expires}) {
    _token = access;
    _refresh = refresh;
    _expires = expires;
  }
}

void main() {
  late AuthRepository authRepository;
  late UserRepository userRepository;
  late MockTokenProvider tokenProvider;

  setUp(() {
    tokenProvider = MockTokenProvider();
    
    const commonHeaders = {"tenant-id": "162"};

    final config = NetworkConfig(
      baseUrl: "https://inter.tmlabs.ai",
      timeout: const Duration(seconds: 15),
      interceptors: [
        HeaderInterceptor(headers: commonHeaders),
        TokenInterceptor(
          client: NetworkClient(NetworkConfig(
            baseUrl: "https://inter.tmlabs.ai",
            interceptors: [HeaderInterceptor(headers: commonHeaders)],
          )),
          refreshPath: "/app-api/member/auth/refresh-token",
          onLogout: () => debugPrint("LOGOUT TRIGGERED"),
          tokenProvider: tokenProvider,
        ),
        PrettyDioLogger(requestBody: true, responseBody: true),
      ],
    );

    final client = NetworkClient(config);
    authRepository = AuthRepository(client: client);
    userRepository = UserRepository(client: client);
  });

  group('User Login Functionality Tests', () {
    const mobile = "+840988123456"; // Use a valid test mobile
    const smsCode = "9999";
    const password = "password123";

    test('Test: Login with Password -> Fetch Profile', () async {
      debugPrint("\n--- LOGIN WITH PASSWORD TEST ---");

      // 1. Login
      final loginRes = await authRepository.login(mobile, password);
      expect(loginRes.toResult().isSuccess, true, reason: "Login with password should succeed");
      
      final session = loginRes.toResult().dataOrNull;
      expect(session, isNotNull);
      debugPrint("Login Success! UserID: ${session?.userId}");

      // 2. Set token for subsequent requests
      tokenProvider.setTokens(session!.accessToken, session.refreshToken, expires: session.expiresTime);
      expect(session.expiresTime, isNotNull);
      debugPrint("Token expires at: ${UtcUtils.formatTimestamp(session.expiresTime!)}");

      // 3. Fetch Profile
      final profileRes = await userRepository.getUserInfo();
      expect(profileRes.toResult().isSuccess, true, reason: "Fetch profile after login should succeed");
      
      final userInfo = profileRes.toResult().dataOrNull;
      expect(userInfo, isNotNull);
      expect(userInfo?.id, session.userId);
      debugPrint("Profile Fetched: ${userInfo?.nickname}, Mobile: ${userInfo?.mobile}");
    });

    test('Test: Login with SMS -> Fetch Profile', () async {
      debugPrint("\n--- LOGIN WITH SMS TEST ---");
      // 1. Send SMS
      final sendSmsRes = await authRepository.sendSmsCode(mobile, SmsScene.smsLogin);
      expect(sendSmsRes.toResult().isSuccess, true, reason: "Send SMS should succeed");
      debugPrint("SMS Sent successfully");

      // 2. Login with SMS
      final loginRes = await authRepository.smsLogin(mobile, smsCode);
      expect(loginRes.toResult().isSuccess, true, reason: "Login with SMS should succeed");
      
      final session = loginRes.toResult().dataOrNull;
      expect(session, isNotNull);
      debugPrint("SMS Login Success! UserID: ${session?.userId}");

      // 3. Set token
      tokenProvider.setTokens(session!.accessToken, session.refreshToken, expires: session.expiresTime);
      expect(session.expiresTime, isNotNull);
      debugPrint("Token expires at: ${UtcUtils.formatTimestamp(session.expiresTime!)}");

      // 4. Fetch Profile
      final profileRes = await userRepository.getUserInfo();
      expect(profileRes.toResult().isSuccess, true, reason: "Fetch profile after SMS login should succeed");
      
      final userInfo = profileRes.toResult().dataOrNull;
      expect(userInfo, isNotNull);
      expect(userInfo?.id, session.userId);
      debugPrint("Profile Fetched: ${userInfo?.nickname}, Mobile: ${userInfo?.mobile}");
    });
  });
}
