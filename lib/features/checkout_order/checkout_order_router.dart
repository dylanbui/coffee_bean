import 'package:coffee_bean/scenes/my_profile_features/coupon_list/coupon_list_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/coupon_list/interactor/coupon_list_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class CheckoutOrderRoutable implements DbNoteRoutable {
  void openCouponList(CouponListListener listener);
  void doLoginFlow(UserAuthFlowListener listener);
}

class CheckoutOrderRouter extends DbNoteRouter implements CheckoutOrderRoutable {
  @override
  void openCouponList(CouponListListener listener) {
    final builder = CouponListBuilder(listener: listener);
    navigator.push(builder.build().viewController);
  }

  @override
  void doLoginFlow(UserAuthFlowListener listener) {
    UserAuthFlow(startStep: AuthStartStep.login).start(this, listener);
  }
}