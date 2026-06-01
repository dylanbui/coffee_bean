import 'package:coffee_bean/scenes/coupon_list/coupon_list_builder.dart';
import 'package:coffee_bean/scenes/coupon_list/interactor/coupon_list_interactor.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class OrderConfirmationRoutable implements DbNoteRoutable {
  void openCouponList(CouponListListener listener);
}

class OrderConfirmationRouter extends DbNoteRouter implements OrderConfirmationRoutable {
  @override
  void openCouponList(CouponListListener listener) {
    // Navigate to CouponList module
    final builder = CouponListBuilder(listener: listener);
    navigator.push(builder.build().viewController);

  }
}
