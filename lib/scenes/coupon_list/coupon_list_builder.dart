import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/coupon_list/coupon_list_router.dart';
import 'package:coffee_bean/scenes/coupon_list/interactor/coupon_list_interactor.dart';
import 'package:coffee_bean/scenes/coupon_list/interactor/coupon_list_page.dart';

class CouponListBuilder extends DbNoteBuilder<CouponListRouter> {
  final CouponListListener? listener;

  CouponListBuilder({this.listener});

  @override
  CouponListRouter build() {
    final router = CouponListRouter();
    final interactor = CouponListInteractor(router, listener: listener);
    final page = CouponListPage(interactor: interactor);

    router.attach(interactor, page);

    return router;
  }
}
