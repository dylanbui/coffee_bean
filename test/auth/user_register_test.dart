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

  // Hàm tạo số điện thoại ngẫu nhiên để tránh lỗi Rate Limit của Server
  String generateRandomMobile() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    return "156${random.substring(random.length - 8)}";
  }

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
        PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true),
      ],
    );

    final client = NetworkClient(config);
    authRepository = AuthRepository(client: client);
    userRepository = UserRepository(client: client);
  });

  group('User Registration Workflow Tests', () {
    late String mobile;
    const smsCode = "9999";
    const wrongSmsCode = "0000";
    const newPassword = "newPassword123";

    setUp(() {
      mobile = generateRandomMobile();
    });

    // Helper function to delay between steps
    Future<void> wait() => Future.delayed(const Duration(seconds: 3));

    test('Full Registration Workflow: Send SMS -> SMS Login (Auto-register) -> Set Password -> Fetch Profile', () async {
      debugPrint("\n🚀 --- STARTING REGISTRATION WORKFLOW TEST --- 🚀");

      // STEP 1: Send SMS Code
      debugPrint("\n👉 STEP 1: SEND SMS CODE");
      final sendSmsRes = await authRepository.sendSmsCode(mobile, SmsScene.smsLogin);
      expect(sendSmsRes.toResult().isSuccess, true, reason: "Send SMS should succeed");
      debugPrint("Result Step 1: SMS Sent successfully");

      await wait();
      // -----------------------------------------------------

      // STEP 2: SMS Login (Auto-registers if new user)
      debugPrint("\n👉 STEP 2: SMS LOGIN (Auto-register)");
      final loginRes = await authRepository.smsLogin(mobile, smsCode);
      expect(loginRes.toResult().isSuccess, true, reason: "SMS Login should succeed");
      
      final session = loginRes.toResult().dataOrNull;
      expect(session, isNotNull);
      debugPrint("Result Step 2: Login Success! UserID: \${session?.userId}");
      
      tokenProvider.setTokens(session!.accessToken, session.refreshToken, expires: session.expiresTime);
      expect(session.expiresTime, isNotNull);
      debugPrint("Token expires at: ${UtcUtils.formatTimestamp(session.expiresTime!)}");

      await wait();
      // -----------------------------------------------------

      // STEP 3: Set Password
      debugPrint("\n👉 STEP 3: SET PASSWORD");
      final setPwdRes = await authRepository.updatePassword(newPassword);
      expect(setPwdRes.toResult().isSuccess, true, reason: "Set password should succeed");
      debugPrint("Result Step 3: Password set successfully");

      await wait();
      // -----------------------------------------------------

      // STEP 4: Verify by fetching profile
      debugPrint("\n👉 STEP 4: FETCH PROFILE");
      final profileRes = await userRepository.getUserInfo();
      expect(profileRes.toResult().isSuccess, true, reason: "Fetch profile should succeed");
      
      final userInfo = profileRes.toResult().dataOrNull;
      expect(userInfo, isNotNull);
      expect(userInfo?.id, session.userId);
      debugPrint("Result Step 4: Profile Fetched! Nickname: \${userInfo?.nickname}");

      debugPrint("\n🏁 --- REGISTRATION WORKFLOW TEST FINISHED --- 🏁");
    });

    test('Registration Failure: Send SMS -> SMS Login with WRONG OTP', () async {
      debugPrint("\n🚀 --- STARTING WRONG OTP TEST --- 🚀");

      // STEP 1: Send SMS Code
      debugPrint("\n👉 STEP 1: SEND SMS CODE");
      final sendSmsRes = await authRepository.sendSmsCode(mobile, SmsScene.smsLogin);
      expect(sendSmsRes.toResult().isSuccess, true, reason: "Send SMS should succeed");
      debugPrint("Result Step 1: SMS Sent successfully");

      await wait();

      // STEP 2: SMS Login with Wrong Code
      debugPrint("\n👉 STEP 2: SMS LOGIN WITH WRONG CODE (\${wrongSmsCode})");
      final loginRes = await authRepository.smsLogin(mobile, wrongSmsCode);
      
      final result = loginRes.toResult();
      expect(result.isFailure, true, reason: "SMS Login should fail with wrong code");
      debugPrint("Result Step 2: Expected failure occurred. Error: \${result.errorOrNull?.message}");

      debugPrint("\n🏁 --- WRONG OTP TEST FINISHED --- 🏁");
    });
  });
}
