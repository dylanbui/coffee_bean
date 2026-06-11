// This file defines logical routes for navigation, especially for deep linking.
// They are simple data classes that carry the necessary parameters for a destination.

import 'package:coffee_bean/config/app_pref.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/scenes/coupon_list/coupon_list_builder.dart';
import 'package:coffee_bean/scenes/course_features/course_list/course_list_builder.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/activity_list_builder.dart';
import 'package:coffee_bean/scenes/food_detail/food_detail_builder.dart';
import 'package:coffee_bean/scenes/order_confirmation/order_confirmation_builder.dart';
import 'package:coffee_bean/scenes/point_features/daily_sign_in/daily_sign_in_builder.dart';
import 'package:coffee_bean/scenes/point_features/point_task/point_task_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/dialog_demo_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/flash_demo_builder.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/venue_detail_builder.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/venue_payment_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/user_register_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_builder.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/shopping_builder.dart';
import 'package:coffee_bean/scenes/store_list/store_list_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_login/user_login_builder.dart';
import 'package:db_core/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/utils/locator.dart';

class AppRouter extends DbNoteRouter {
  Future<void> successSyncDataFormServer() async {

    // Set default store id to match mock data
    AppPrefs().setSelectedStoreId(3);

    // --- GIẢ LẬP ĐĂNG NHẬP (Bật/Tắt dòng dưới để test Guest/Member) ---
    await _simulateLogin();

    // Load trang dau tien
    MainTabbarBuilder mainTabbarBuilder = MainTabbarBuilder();
    final router = mainTabbarBuilder.build();
    navigator.pushSameRootPage(router.viewController);

    // --- TẠO DỮ LIỆU MOCK ĐỂ TEST UI VENUE PAYMENT ---
    // final params = VenuePaymentParams(
    //   venueName: "Sân Pickle ball",
    //   imageUrl: "https://images.unsplash.com/photo-1599423088114-f81d83764835?q=80&w=2670&auto=format&fit=crop",
    //   address: "27 Nguyễn Cửu Vân, phường Gia Định, TP HCM",
    //   openingHours: "6h00' - 23h00'",
    //   selectedSlots: [
    //     VenueBookingSlot(
    //       date: DateTime.now(),
    //       courtId: "vip2",
    //       time: "07:00 - 8:00",
    //       price: 400000,
    //     ),
    //     VenueBookingSlot(
    //       date: DateTime.now(),
    //       courtId: "std1",
    //       time: "09:00 - 10:00",
    //       price: 300000,
    //     ),
    //     VenueBookingSlot(
    //       date: DateTime.now(),
    //       courtId: "std2",
    //       time: "14:00 - 15:00",
    //       price: 300000,
    //     ),
    //     VenueBookingSlot(
    //       date: DateTime.now(),
    //       courtId: "vip1",
    //       time: "19:00 - 20:00",
    //       price: 450000,
    //     ),
    //   ],
    //   courts: [
    //     const VenueCourtModel(id: 'vip2', name: 'VIP 2'),
    //     const VenueCourtModel(id: 'vip1', name: 'VIP 1'),
    //     const VenueCourtModel(id: 'std1', name: 'Sân 1'),
    //     const VenueCourtModel(id: 'std2', name: 'Sân 2'),
    //   ],
    // );
    //
    // final builder = VenuePaymentBuilder(params);
    // navigator.pushSameRootPage(builder.build().viewController);


    // await dataTestOrderConfirmationBuilder();
    // Điều hướng đến màn hình xác nhận đơn hàng
    // final builder = VenueDetailBuilder();
    // navigator.pushSameRootPage(builder.build().viewController);

    // final builder = DailySignInBuilder();
    // final builder = MyPointListBuilder();
    // final builder = RewardPointHistoryBuilder();
    // navigator.pushSameRootPage(builder.build().viewController);

    
    // final builder = FlashDemoBuilder();
    // navigator.pushSameRootPage(builder.build().viewController);

    // final builder = StoreListBuilder();
    // navigator.pushSameRootPage(builder.build().viewController);
    // UserLoginBuilder builder = UserLoginBuilder();
    // navigator.pushSameRootPage(builder.build().viewController,);

    // final builder = ShoppingBuilder();
    // navigator.pushSameRootPage(builder.build().viewController);
  }

  Future<void> _simulateLogin() async {
    final mockUser = UserSession(
      id: 1,
      userName: "dylanbui",
      fullName: "Dylan Bui",
      email: "dylan@example.com",
      accessToken: "mock_access_token",
    );
    await UserManager().saveSession(mockUser);
  }

  Future<void> dataTestOrderConfirmationBuilder() async {
    final dbService = locator<DatabaseService>();
    final cartService = locator<CartService>();

    // Xóa dữ liệu cũ để đảm bảo môi trường test sạch
    await dbService.isar.writeTxn(() async {
      await dbService.isar.tblStores.clear();
      await dbService.isar.tblCartItems.clear();

      // 1. Tạo Store Mock (Lấy từ sample_store.json - ID 1)
      final mockStore = TblStore()
        ..serverId = 1
        ..name = "Coffee Bean - Hàn Thuyên"
        ..address = "27 Hàn Thuyên, P. Bến Nghé, Quận 1, TP. HCM"
        ..phone = "028 3827 3001"
        ..openingTime = "07:00"
        ..closingTime = "22:00"
        ..images = [
          TblImage()..url = "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400&q=80"..isPrimary = true
        ];
      await dbService.isar.tblStores.put(mockStore);
    });


    // 2. Tạo Cart Items Mock (Lấy từ sample_data.json)

    // Món 1: Cà Phê Sữa Đá Sài Gòn (ID 2)
    final food1 = TblFood()
      ..serverId = 2
      ..name = "Cà Phê Sữa Đá Sài Gòn"
      ..price = 35000.0
      ..images = [TblImage()..url = "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=800&q=80"..isPrimary = true];

    final options1 = [
      SelectedOption()..groupName = "Size"..optionName = "L"..extraPrice = 10000,
      SelectedOption()..groupName = "Độ ngọt"..optionName = "50% Đường"..extraPrice = 0,
    ];

    // Món 2: Trà Sữa Trân Châu Đen (ID 11)
    final food2 = TblFood()
      ..serverId = 11
      ..name = "Trà Sữa Trân Châu Đen"
      ..price = 45000.0
      ..images = [TblImage()..url = "https://images.unsplash.com/photo-1544333346-64e4fe18274b?w=800&q=80"..isPrimary = true];

    final options2 = [
      SelectedOption()..groupName = "Topping"..optionName = "Trân châu đen"..extraPrice = 5000,
      SelectedOption()..groupName = "Topping"..optionName = "Kem cheese"..extraPrice = 10000,
    ];

    // Món 3: Cappuccino Art (ID 3)
    final food3 = TblFood()
      ..serverId = 3
      ..name = "Cappuccino Art"
      ..price = 45000.0
      ..images = [TblImage()..url = "https://images.unsplash.com/photo-1534778101976-62847782c213?w=800&q=80"..isPrimary = true];

    final options3 = [
      SelectedOption()..groupName = "Size"..optionName = "M"..extraPrice = 0,
    ];

    // Món 4: Tiramisu Classic (ID 17)
    final food4 = TblFood()
      ..serverId = 17
      ..name = "Tiramisu Classic"
      ..price = 45000.0
      ..images = [TblImage()..url = "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800&q=80"..isPrimary = true];

    // Thêm vào giỏ hàng thông qua CartService
    await cartService.addToCart(food1, quantity: 1, options: options1);
    await cartService.addToCart(food2, quantity: 2, options: options2);
    await cartService.addToCart(food3, quantity: 1, options: options3);
    await cartService.addToCart(food4, quantity: 3);
  }


  // Future<void> successSyncDataFormServer() async {
  //
  //   // TEST UI FoodDetail
  //   // final dbService = locator<DatabaseService>();
  //   // final product = await dbService.isar.tblFoods.where().findFirst();
  //   // final product = await dbService.isar.tblFoods.where().serverIdEqualTo(1).findFirst();
  //
  //   // --- TẠO DỮ LIỆU MOCK ĐỂ TEST UI FOOD DETAIL ---
  //   final mockProduct = TblFood()
  //     ..serverId = 999
  //     ..name = "CAPUCHINO ĐẶC BIỆT"
  //     ..price = 40000.0
  //     ..description = "Dòng cà phê ý kết hợp cùng sữa tươi đánh nóng tạo nên lớp bọt mịn màng, thơm béo. Phù hợp cho những ai yêu thích sự nhẹ nhàng nhưng vẫn đậm đà vị cà phê."
  //     ..images = [
  //       TblImage()..url = "https://images.unsplash.com/photo-1541167760496-162955ed8a9f?w=800&q=80"..isPrimary = true,
  //       TblImage()..url = "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80",
  //       TblImage()..url = "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800&q=80",
  //       TblImage()..url = "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&q=80",
  //       TblImage()..url = "https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800&q=80",
  //     ]
  //     ..properties = [
  //       TblProductProperty()
  //         ..serverId = 1
  //         ..groupName = "Size"
  //         ..options = [
  //           TblProductOption()..serverId = 11..name = "M"..extraPrice = 0,
  //           TblProductOption()..serverId = 12..name = "L"..extraPrice = 10000,
  //           TblProductOption()..serverId = 13..name = "XL"..extraPrice = 15000,
  //         ],
  //       TblProductProperty()
  //         ..serverId = 2
  //         ..groupName = "Chất liệu coffee"
  //         ..options = [
  //           TblProductOption()..serverId = 21..name = "Rang nhẹ"..isAvailable = true,
  //           TblProductOption()..serverId = 22..name = "Rang đậm"..isAvailable = false,
  //         ],
  //       TblProductProperty()
  //         ..serverId = 3
  //         ..groupName = "Tỉ lệ sữa"
  //         ..options = [
  //           TblProductOption()..serverId = 31..name = "Ít sữa",
  //           TblProductOption()..serverId = 32..name = "Nhiều sữa"..isAvailable = false,
  //         ],
  //       TblProductProperty()
  //         ..serverId = 4
  //         ..groupName = "Độ ngọt"
  //         ..options = [
  //           TblProductOption()..serverId = 41..name = "Ngọt vừa",
  //           TblProductOption()..serverId = 42..name = "Ít ngọt",
  //           TblProductOption()..serverId = 43..name = "Nhiều ngọt"..isAvailable = false,
  //           TblProductOption()..serverId = 44..name = "Siêu ngọt"..isAvailable = false,
  //           TblProductOption()..serverId = 45..name = "Không ngọt",
  //         ],
  //     ];
  //
  //   dLog(mockProduct.toString());
  //
  //   final nextBuilder = FoodDetailBuilder(mockProduct);
  //   final nextRouter = nextBuilder.build();
  //   navigator.pushSameRootPage(nextRouter.viewController);
  // }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}
}
