import 'dart:async';
import 'dart:convert';

import 'package:db_core/architecture_ribs/note_interactor.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/scenes/app/app_router.dart';
import 'package:flutter/services.dart';

/// The State for the AppInteractor.
abstract class AppInteractorState extends BaseBlocState {}

class AppInteractorInitial extends AppInteractorState {}

/// The Interactor for the root of the application.
/// It contains business logic for bootstrapping, session management, and deep linking.
class AppInteractor extends DbNoteInteractor<AppRouter> {

  AppInteractor({required AppRouter router}) {
    this.router = router;
  }

  // @override
  // void onDidBecomeActive() {
  //   super.onDidBecomeActive();
  //   // Initialize and listen for deep links as soon as the app starts.
  //   _deepLinkService.init();
  //   _listenForDeepLinks();
  // }
  //
  // @override
  // void onWillResignActive() {
  //   _deepLinkSubscription?.cancel();
  //   _deepLinkService.dispose();
  //   super.onWillResignActive();
  // }

  /// Called by the AppBuilder when the splash screen is finished.
  Future<void> bootstrap() async {
    dLog("AppInteractor: Bootstrapping application...");

    // --- Phase 1: Load Data to Isar Cache ---
    try {
      final dbService = locator<DatabaseService>();
      
      // 1. Xóa sạch dữ liệu cũ để "làm như mới" hoàn toàn
      await dbService.clearAllDataForNewStore();
      dLog("AppInteractor: Database cleared for fresh start.");

      // 2. Đọc file sample data từ assets
      final String response = await rootBundle.loadString('assets/json/sample_data.json');
      final data = json.decode(response);

      // GIẢ LẬP: Chạy 3 API đồng thời (Category, Product, Property)
      dLog("AppInteractor: Fetching 3 APIs concurrently...");
      final results = await Future.wait([
        Future.delayed(const Duration(milliseconds: 500), () => data['categories']),
        Future.delayed(const Duration(milliseconds: 800), () => data['products']),
        Future.delayed(const Duration(milliseconds: 300), () => data['properties']),
      ]);

      // 3. Sync toàn bộ dữ liệu (Không truyền targetType để nạp sạch mọi thứ)
      await dbService.syncShoppingData(
        categoriesJson: results[0] as List<dynamic>,
        productsJson: results[1] as List<dynamic>,
        propertiesJson: results[2] as List<dynamic>,
      );

      // --- Kiểm tra dữ liệu sau khi sync ---
      final foodCount = await dbService.isar.tblFoods.count();
      final courseCount = await dbService.isar.tblCourses.count();
      final catCount = await dbService.isar.tblCategorys.count();
      dLog("AppInteractor: DB Sync Success -> Foods: $foodCount, Courses: $courseCount, Categories: $catCount");
      
      dLog("AppInteractor: Database bootstrapped successfully from simulated APIs.");
    } catch (e) {
      dLog("AppInteractor: Error bootstrapping database: $e");
    }

    // --- Phase 2: Load Critical Data ---
    // For example: Checking login status, fetching remote config.
    if (UserManager().isLogin) {
      dLog("AppInteractor: User is logged in. Navigating to Main App.");
    } else {
      dLog("AppInteractor: User is not logged in. Navigating to Login flow.");
    }

    // Giả lập xử lý load bootstrap 3s
    await Future.delayed(const Duration(seconds: 3));
    router?.successSyncDataFormServer();
  }
}
