import 'dart:async';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/utils/logger.dart';
import 'package:db_core/utils/shared_preferences.dart';
import 'package:coffee_bean/data/local/live_service/model/liked_product.dart';
import 'package:coffee_bean/data/model/response/product/product.dart';

class LikesService implements DbLocatorDisposable {
  static const String _likesKey = 'cache_liked_products';

  final _likesController = StreamController<List<LikedProduct>>.broadcast();
  List<LikedProduct> _items = [];

  LikesService() {
    _loadLikes();
  }

  Stream<List<LikedProduct>> get likedStream {
    return Stream<List<LikedProduct>>.multi((controller) {
      // Emit current state immediately to new listeners
      controller.add(List.unmodifiable(_items));

      final subscription = _likesController.stream.listen(
        (event) => controller.add(event),
        onError: (e) => controller.addError(e),
        onDone: () => controller.close(),
      );

      controller.onCancel = () => subscription.cancel();
    }, isBroadcast: true);
  }

  List<LikedProduct> get currentLikedItems => List.from(_items);

  bool isLiked(int? productId) {
    if (productId == null) return false;
    return _items.any((item) => item.productId == productId);
  }

  void toggleLike(Product product) {
    final int index = _items.indexWhere((item) => item.productId == product.id);

    if (index != -1) {
      // Already liked, so remove it
      _items.removeAt(index);
    } else {
      // Not liked, so add it
      _items.add(LikedProduct(
        product: product,
        likedAt: DateTime.now(),
      ));
    }

    _notifyChange();
  }

  @override
  void dispose() {
    _likesController.close();
  }

  // region Private functions
  void _notifyChange() {
    _likesController.add(List.from(_items));
    _saveLikes();
  }

  Future<void> _saveLikes() async {
    final List<Map<String, dynamic>> jsonList = _items.map((e) => e.toJson()).toList();
    await DbSharedPreferences().set(_likesKey, jsonList);
  }

  void _loadLikes() {
    try {
      final dynamic data = DbSharedPreferences().get(_likesKey);
      if (data != null && data is List) {
        _items = data.map((e) => LikedProduct.fromJson(e)).toList();
        _likesController.add(List.from(_items));
      }
    } catch (e) {
      eLog("Error loading likes: $e");
      _items = [];
    }
  }
  // endregion
}
