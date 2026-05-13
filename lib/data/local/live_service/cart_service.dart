import 'dart:async';
import 'package:coffee_bean/core/utils/locator.dart';
import 'package:coffee_bean/core/utils/logger.dart';
import 'package:coffee_bean/core/utils/shared_preferences.dart';
import 'package:coffee_bean/data/local/live_service/model/cart_item.dart';
import 'package:coffee_bean/data/model/product.dart';

class CartService implements DbLocatorDisposable {
    static const String _cartKey = 'cache_cart_items';

    final _cartController = StreamController<List<CartItem>>.broadcast();
    List<CartItem> _items = [];

    CartService() {
        // Since SharedPreferences is already initialized in main(),
        // we can load data immediately.
        _loadCart();
    }

    Stream<List<CartItem>> get cartStream {
        return Stream<List<CartItem>>.multi((controller) {
            // When a new listener subscribes, emit the current value immediately
            controller.add(List.unmodifiable(_items));

            // Subscribe this listener to the main controller to receive future updates
            final subscription = _cartController.stream.listen(
                (event) => controller.add(event),
                onError: (e) => controller.addError(e),
                onDone: () => controller.close(),
            );

            // Cancel internal subscription when the listener is cancelled
            controller.onCancel = () => subscription.cancel();
        }, isBroadcast: true);
    }

    List<CartItem> get currentItems => List.from(_items);

    void addToCart(Product product, {int quantity = 1, String? note}) {
        final newItem = CartItem(product: product, quantity: quantity, note: note);
        int index = _items.indexWhere((item) => item.cartItemId == newItem.cartItemId);

        if (index != -1) {
            _items[index].quantity += quantity;
        } else {
            _items.add(newItem);
        }

        _notifyChange();
    }

    void updateQuantity(String cartItemId, int quantity) {
        int index = _items.indexWhere((item) => item.cartItemId == cartItemId);
        if (index != -1) {
            if (quantity <= 0) {
                _items.removeAt(index);
            } else {
                _items[index].quantity = quantity;
            }
            _notifyChange();
        }
    }

    void removeItem(String cartItemId) {
        _items.removeWhere((item) => item.cartItemId == cartItemId);
        _notifyChange();
    }

    double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

    @override
    void dispose() {
        _cartController.close();
    }

    // region Private functions
    void _notifyChange() {
        _cartController.add(List.from(_items));
        _saveCart();
    }

    Future<void> _saveCart() async {
        // Convert item list to JSON
        final List<Map<String, dynamic>> jsonList = _items.map((e) => e.toJson()).toList();
        // Use set(key, value) from DbSharedPreferences
        await DbSharedPreferences().set(_cartKey, jsonList);
    }

    void _loadCart() {
        try {
            // DbSharedPreferences returns dynamic via get(key)
            final dynamic data = DbSharedPreferences().get(_cartKey);
            if (data != null && data is List) {
                _items = data.map((e) => CartItem.fromJson(e)).toList();
                _cartController.add(List.from(_items));
            }
        } catch (e) {
            eLog("Error loading cart: $e");
            _items = [];
        }
    }

    // endregion
}
