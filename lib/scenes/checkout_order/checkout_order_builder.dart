import 'package:coffee_bean/scenes/checkout_order/checkout_order_common.dart';
import 'package:coffee_bean/scenes/checkout_order/interactor/checkout_order_interactor.dart';
import 'package:coffee_bean/scenes/checkout_order/interactor/checkout_order_page.dart';
import 'package:coffee_bean/scenes/checkout_order/checkout_order_router.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';

class CheckoutOrderBuilder extends DbNoteBuilder<CheckoutOrderRouter> {
  final CheckoutItemContract checkoutItem;

  CheckoutOrderBuilder({required this.checkoutItem});

  @override
  CheckoutOrderRouter build() {
    final router = CheckoutOrderRouter();
    final interactor = CheckoutOrderInteractor(router, checkoutItem);
    final page = CheckoutOrderPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
