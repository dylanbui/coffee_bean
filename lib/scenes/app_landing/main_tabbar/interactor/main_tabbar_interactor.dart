import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/interactor/main_tabbar_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_router.dart';
import 'package:flutter/widgets.dart';

class MainTabbarInteractor extends CubitInteractor<MainTabbarRoutable, MainTabbarState> {
  MainTabbarInteractor(MainTabbarRoutable router) : super(const MainTabbarInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();

    // --- XỬ LÝ DEEP LINK / PUSH NOTIFICATION (COLD START) ---
    // 1. Thực hiện load các tài nguyên thiết yếu cho MainTabbar trước (nếu có)
    _initEssentialData().then((_) {
      // 2. Chờ cho đến khi UI của MainTabbar đã render xong frame đầu tiên để tránh giật lag (animation mượt hơn)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndProcessDeepLink();
      });
    });
  }

  Future<void> _initEssentialData() async {
    // Gi giả lập load data khởi tạo cần thiết cho Tabbar (User Profile, Config, v.v.)
    // await Future.delayed(const Duration(milliseconds: 500));
  }

  void _checkAndProcessDeepLink() {
    // 3. Kiểm tra xem có Deep Link đang chờ xử lý hay không (được lưu từ AppModule khi nhận Notification)
    // Đây là nơi xử lý cho trường hợp App khởi động từ trạng thái tắt (Cold Start)
    
    /*
    // Pseudo-code tham khảo:
    final pendingLink = DeepLinkService.instance.getPendingLink();
    if (pendingLink != null) {
      if (pendingLink.type == 'product') {
        // Thực hiện điều hướng stack [ProductList -> ProductDetail]
        // router?.showProductFlow(pendingLink.productId);
      }
      
      // Sau khi xử lý xong, xóa link để tránh việc điều hướng lặp lại khi rebuild
      DeepLinkService.instance.clearPendingLink();
    }
    */
  }

  void selectTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
