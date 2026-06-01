import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_interactor.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_page.dart';
import 'package:coffee_bean/scenes/order_confirmation/order_confirmation_router.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';

class OrderConfirmationBuilder extends DbNoteBuilder<OrderConfirmationRouter> {
  OrderConfirmationBuilder();

  @override
  OrderConfirmationRouter build() {
    final router = OrderConfirmationRouter();
    final interactor = OrderConfirmationInteractor(router);
    final page = OrderConfirmationPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
