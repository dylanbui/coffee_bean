import 'package:coffee_bean/scenes/my_profile_features/coupon_list/coupon_list_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/coupon_list/interactor/coupon_list_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class OrderConfirmationRoutable implements DbNoteRoutable {
  void openCouponList(CouponListListener listener);
  void doLoginFlow(UserAuthFlowListener listener);
}

class OrderConfirmationRouter extends DbNoteRouter implements OrderConfirmationRoutable {
  @override
  void openCouponList(CouponListListener listener) {
    // Navigate to CouponList module
    final builder = CouponListBuilder(listener: listener);
    navigator.push(builder.build().viewController);

  }

  @override
  void doLoginFlow(UserAuthFlowListener listener) {
    // Khởi chạy luồng Auth bắt đầu từ Login
    UserAuthFlow(startStep: AuthStartStep.login).start(this, listener);
  }
}
