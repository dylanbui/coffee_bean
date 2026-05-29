// This file defines logical routes for navigation, especially for deep linking.
// They are simple data classes that carry the necessary parameters for a destination.

import 'package:coffee_bean/scenes/food_detail/food_detail_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/dialog_demo_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/flash_demo_builder.dart';
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
    // Load trang dau tien
    MainTabbarBuilder mainTabbarBuilder = MainTabbarBuilder();
    final router = mainTabbarBuilder.build();
    navigator.pushSameRootPage(router.viewController);

    // final dbService = locator<DatabaseService>();
    // final product = await dbService.isar.tblFoods.where().serverIdEqualTo(1).findFirst();
    // FoodDetailBuilder builder = FoodDetailBuilder(1);
    // navigator.pushSameRootPage(builder.build().viewController);


    // final builder = DialogDemoBuilder();
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
