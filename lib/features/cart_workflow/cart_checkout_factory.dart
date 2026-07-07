import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/store_manager/store_manager.dart';
import 'package:coffee_bean/features/cart_workflow/cart_checkout_contract.dart';
import 'package:db_core/utils/locator.dart';

class CartCheckoutFactory {
  static AppCartCheckoutContract createFromCurrentCart() {
    final cartService = locator<CartService>();
    final store = StoreManager().selectedStore; 
    
    return AppCartCheckoutContract(
      items: cartService.currentItems,
      store: store,
    );
  }
}
