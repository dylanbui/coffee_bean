import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:db_core/db_core.dart';

import 'package:coffee_bean/scenes/my_profile_features/change_mobile/interactor/change_mobile_page.dart';
import 'package:coffee_bean/scenes/my_profile_features/change_mobile/interactor/change_mobile_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/change_mobile/interactor/change_mobile_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/change_mobile/change_mobile_builder.dart';
import 'package:coffee_bean/shared/widget/phone_input_field.dart';
import 'package:coffee_bean/shared/widget/code_input_field.dart';

import 'change_mobile_test_data.dart';

// --- Mocks ---
class MockChangeMobileRoutable extends Mock implements ChangeMobileRoutable {}
class MockChangeMobileInteractor extends Mock implements ChangeMobileInteractor {}

void main() {
  late MockChangeMobileInteractor mockInteractor;
  late MockChangeMobileRoutable mockRouter;
  late StreamController<ChangeMobileState> stateController;

  setUpAll(() {
    // Register fallback for mocktail any() if needed
    registerFallbackValue(ChangeMobileInitial());
  });

  setUp(() {
    mockRouter = MockChangeMobileRoutable();
    mockInteractor = MockChangeMobileInteractor();
    stateController = StreamController<ChangeMobileState>.broadcast();

    // Stubbing basics
    when(() => mockInteractor.router).thenReturn(mockRouter);
    when(() => mockInteractor.state).thenReturn(ChangeMobileTestData.initialState);
    when(() => mockInteractor.stream).thenAnswer((_) => stateController.stream);
    
    // Default mock for methods
    when(() => mockInteractor.sendSmsCode(any())).thenAnswer((_) async {});
    when(() => mockInteractor.updateMobile(any(), any())).thenAnswer((_) async {});
    when(() => mockInteractor.close()).thenAnswer((_) async {});
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeMobilePage(interactor: mockInteractor),
    );
  }

  /// Helper to clear pending timers from Flash/Animations
  Future<void> clearTimers(WidgetTester tester) async {
    // Flash normally lasts 3-4 seconds, 5s is safe to clear all
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  }

  group('ChangeMobilePage - UI Display Tests', () {
    testWidgets('Nên hiển thị đầy đủ các thành phần UI ban đầu', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Thay đổi số điện thoại'), findsOneWidget);
      expect(find.text('Nhập số điện thoại mới'), findsOneWidget);
      expect(find.byType(PhoneInputField), findsOneWidget);
      expect(find.byType(CodeInputField), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.text('Cập Nhật'), findsOneWidget);
    });

    testWidgets('Nên hiển thị trạng thái loading khi interactor đang xử lý', (WidgetTester tester) async {
      when(() => mockInteractor.state).thenReturn(ChangeMobileTestData.loadingState);
      
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('ChangeMobilePage - Interaction & Validation Tests', () {
    testWidgets('Nên hiện thông báo lỗi nếu nhấn Gửi mã khi số điện thoại không hợp lệ', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final sendCodeBtn = find.text('Gửi mã');
      await tester.tap(sendCodeBtn);
      await tester.pumpAndSettle();

      expect(find.text("Vui lòng nhập số điện thoại mới hợp lệ"), findsOneWidget);
      verifyNever(() => mockInteractor.sendSmsCode(any()));
      
      await clearTimers(tester);
    });

    testWidgets('Nên gọi sendSmsCode khi nhập số điện thoại hợp lệ và nhấn Gửi mã', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField).first, '988123456');
      await tester.pump();

      final sendCodeBtn = find.text('Gửi mã');
      await tester.tap(sendCodeBtn);
      await tester.pump();

      verify(() => mockInteractor.sendSmsCode('+84988123456')).called(1);
    });

    testWidgets('Nên hiện thông báo lỗi nếu nhấn Cập nhật khi chưa nhập mã OTP', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final updateBtn = find.text('Cập Nhật');
      await tester.tap(updateBtn);
      await tester.pumpAndSettle();

      expect(find.text("Vui lòng nhập mã xác thực"), findsOneWidget);
      
      await clearTimers(tester);
    });
  });

  group('ChangeMobilePage - Business Logic & State Tests', () {
    testWidgets('Nên hiển thị Flash Error khi state trả về lỗi', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      stateController.add(ChangeMobileTestData.errorState('Mã OTP không chính xác'));
      await tester.pumpAndSettle();

      expect(find.text('Mã OTP không chính xác'), findsOneWidget);
      
      await clearTimers(tester);
    });

    testWidgets('Nên đóng màn hình khi cập nhật thành công', (WidgetTester tester) async {
      when(() => mockRouter.pop()).thenAnswer((_) async {});
      
      await tester.pumpWidget(createWidgetUnderTest());

      stateController.add(ChangeMobileTestData.successState);
      await tester.pumpAndSettle();

      expect(find.text("Cập nhật số điện thoại thành công"), findsOneWidget);
      
      await tester.pump(const Duration(seconds: 1));
      verify(() => mockRouter.pop()).called(1);
      
      await clearTimers(tester);
    });
  });
}
