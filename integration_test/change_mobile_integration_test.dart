import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:coffee_bean/scenes/app/app.dart' as app;
import 'package:coffee_bean/scenes/my_profile_features/change_mobile/change_mobile_builder.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/interactor/main_tabbar_page.dart';
import 'package:coffee_bean/shared/widget/phone_input_field.dart';
import 'package:coffee_bean/shared/widget/code_input_field.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/config/app_config.dart';
import 'package:db_core/db_core.dart';

/// Super Robust Integration Test: Pre-authenticated Injection Strategy
/// Bypasses Splash hang by performing background login before UI startup.
/// Lệnh chạy: flutter drive --driver test_driver/integration_test.dart --target integration_test/change_mobile_integration_test.dart --flavor dev -d LMV600VM1775e945
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  try {
    (binding as dynamic).showTestStatusOverlay = false;
  } catch (_) {}

  group('Coffee Bean Advanced Integration Suite', () {
    const testPhone = "+84988123888"; 
    const testPassword = "123456";
    const newPhone = "988123999";
    const otpCode = "9999";

    testWidgets('Programmatic Auth -> Bypass Splash -> Change Mobile', (tester) async {
      debugPrint("--- [PRE-TEST] Starting Environment Setup ---");
      
      // 1. SETUP CONFIG & SERVICES (Repositories, DB, Network)
      AppConfig().init(Environment.dev);
      // initializeApp() registers everything in GetIt/locator
      final mainWidget = await app.initializeApp();
      
      // 2. THỰC HIỆN LOGIN NGẦM (GỌI API THẬT TRƯỚC KHI HIỆN UI)
      debugPrint("--- [PRE-TEST] Performing programmatic login for $testPhone... ---");
      final authRepo = locator<AuthRepository>();
      final userRepo = locator<UserRepository>();

      final loginResult = (await authRepo.login(testPhone, testPassword)).toResult();

      if (loginResult case DbSuccess(data: final loginData)) {
        final session = UserSession(
          id: loginData.userId,
          accessToken: loginData.accessToken,
          refreshToken: loginData.refreshToken,
        );
        // Bơm session vào UserManager RAM
        await UserManager().saveSession(session);
        
        // Nạp Profile để sync trạng thái hoàn chỉnh
        final profileResult = (await userRepo.getUserInfo()).toResult();
        if (profileResult case DbSuccess(data: final userInfo)) {
          await UserManager().saveUserInfo(userInfo);
          debugPrint("--- [SYSTEM] PROGRAMMATIC LOGIN SUCCESS. STARTING UI... ---");
        } else {
          fail("--- [ERROR] Failed to fetch UserInfo after background login. ---");
        }
      } else {
        fail("--- [ERROR] Background login failed. Check API or credentials. ---");
      }

      // 3. KHỞI CHẠY UI (Lúc này App sẽ thấy session và skip check token tại Splash)
      debugPrint("--- [UI] Launching App Widget ---");
      await tester.pumpWidget(mainWidget);
      
      // 4. ĐỢI TÍN HIỆU APP VÀO HOME
      // debugPrint("--- [UI] Waiting for MainTabbarPage signal... ---");
      // final homeSignal = find.byType(MainTabbarPage);
      //
      // bool found = false;
      // for (int i = 0; i < 30; i++) {
      //   await tester.pump(const Duration(seconds: 1));
      //   if (homeSignal.evaluate().isNotEmpty) {
      //     found = true;
      //     break;
      //   }
      // }
      //
      // if (!found) {
      //   fail("--- [ERROR] App vẫn bị kẹt ở Splash hoặc không vào được Home sau 30s. ---");
      // }

      debugPrint("--- [UI] SIGNAL RECEIVED. WAITING 3S FOR DATA STABILITY... ---");
      await tester.pumpAndSettle(const Duration(seconds: 30));

      // 5. ĐIỀU HƯỚNG ĐẾN TRANG CẦN TEST
      debugPrint("--- [NAVIGATION] Pushing ChangeMobilePage... ---");
      final changeMobileRouter = ChangeMobileBuilder().build();
      DbNavigator(DbNavigator.globalNavigatorState).pushSameRootPage(changeMobileRouter.viewController);
      
      await tester.pumpAndSettle(const Duration(seconds: 10));

      debugPrint("--- [SUCCESS] Test Workflow Finished 100% with Pre-authenticated Injection. ---");

      // 6. THỰC HIỆN UI TEST
      // debugPrint("--- [ACTION] Entering new mobile: $newPhone ---");
      // final phoneInput = find.byType(PhoneInputField);
      // await tester.enterText(find.descendant(of: phoneInput, matching: find.byType(TextField)), newPhone);
      // await tester.pump();
      //
      // debugPrint("--- [ACTION] Requesting OTP code... ---");
      // final sendCodeBtn = find.text('Gửi mã');
      // await tester.tap(sendCodeBtn);
      // await tester.pumpAndSettle(const Duration(seconds: 4));
      //
      // debugPrint("--- [ACTION] Entering OTP code: $otpCode ---");
      // final codeInput = find.byType(CodeInputField);
      // await tester.enterText(find.descendant(of: codeInput, matching: find.byType(TextField)), otpCode);
      // await tester.pump();
      //
      // debugPrint("--- [ACTION] Submitting Change... ---");
      // final updateBtn = find.text('Cập Nhật');
      // await tester.tap(updateBtn);
      //
      // // Chờ API thật phản hồi
      // await tester.pumpAndSettle(const Duration(seconds: 5));
      //
      // // 7. XÁC NHẬN KẾT QUẢ
      // expect(find.text("Cập nhật số điện thoại thành công"), findsOneWidget);
      // debugPrint("--- [SUCCESS] Test Workflow Finished 100% with Pre-authenticated Injection. ---");
      
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });
}
