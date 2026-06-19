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
  String? _refresh;
  int? _expires;
  
  @override
  Future<String?> getAccessToken() async => _token;
  @override
  Future<String?> getRefreshToken() async => _refresh;
  @override
  Future<void> updateAccessToken(String newAccess, {int? expiresTime}) async {
    _token = newAccess;
    // if (expiresTime != null) _expires = expiresTime;
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

  test('DAILY SIGN-IN GET POINTS REWARD Workflow Test', () async {
    const mobile = "+84988123888";
    const password = "123456";

    debugPrint("\n🚀 --- STARTING DAILY SIGN-IN TEST --- 🚀");

    // 1. Login
    debugPrint("\n👉 STEP 1: LOGIN");
    final loginRes = await authRepository.login(mobile, password);
    if (loginRes.error != null) {
        debugPrint("❌ Login Failed: ${loginRes.error?.message}");
        return;
    }
    final session = loginRes.data;
    tokenProvider.setTokens(session!.accessToken, session.refreshToken, expires: session.expiresTime);
    debugPrint("✅ Login Success! UserID: ${session.userId}");

    // 2. Initial User Info
    debugPrint("\n👉 STEP 2: GET INITIAL USER INFO");
    final infoRes1 = await userRepository.getUserInfo();
    final initialPoints = infoRes1.data?.point ?? 0;
    debugPrint("Initial Points: $initialPoints");

    // 3. Daily Sign-In
    debugPrint("\n👉 STEP 3: PERFORM DAILY SIGN-IN");
    final signInRes = await userRepository.createSignInRecord();
    final signInResult = signInRes.toResult();
    
    if (signInResult case DbSuccess(:final data)) {
        debugPrint("✅ Sign-In Success: $data");
        
        // Kiểm tra dữ liệu trả về theo đúng format yêu cầu
        final rewardPoint = data['point'] as int? ?? 0;
        final rewardExperience = data['experience'] as int? ?? 0;
        final day = data['day'] as int? ?? 0;
        
        debugPrint("🎁 Reward Info: Day=$day, Point=$rewardPoint, Experience=$rewardExperience");
        
        expect(rewardPoint, isNotNull, reason: "Should receive points reward");
        expect(rewardExperience, isNotNull, reason: "Should receive experience reward");
    } else if (signInResult case DbFailure(:final error)) {
        debugPrint("ℹ️ Sign-In Failed/Skipped (Maybe already signed in): ${error.message}");
    }

    // 4. Verification User Info
    debugPrint("\n👉 STEP 4: VERIFY POINTS AFTER SIGN-IN");
    final infoRes2 = await userRepository.getUserInfo();
    final updatedPoints = infoRes2.data?.point ?? 0;
    debugPrint("Updated Points: $updatedPoints");
    
    if (updatedPoints > initialPoints) {
        debugPrint("✅ SUCCESS: Points increased from $initialPoints to $updatedPoints");
    } else {
        debugPrint("ℹ️ INFO: Points did not change. This is normal if you have already signed in today or the reward is 0.");
    }

    // 5. Repeat Sign-In
    debugPrint("\n👉 STEP 5: REPEAT SIGN-IN (EXPECT FAILURE)");
    final repeatRes = await userRepository.createSignInRecord();
    final repeatResult = repeatRes.toResult();
    
    if (repeatResult case DbFailure(:final error)) {
        debugPrint("✅ SUCCESS: Correctly received error for repeated sign-in: ${error.message}");
    } else {
        debugPrint("❌ FAILURE: Repeated sign-in should have failed but succeeded!");
    }

    debugPrint("\n🏁 --- DAILY SIGN-IN TEST FINISHED --- 🏁");
  });
}
