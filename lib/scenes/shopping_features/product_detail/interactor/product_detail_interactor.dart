import 'package:coffee_bean/features/cart_workflow/cart_checkout_factory.dart';
import 'package:coffee_bean/data/model/response/product/product.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/product_detail_builder.dart';
import 'package:db_core/network/network_utils.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/data/repository/product_repository.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_event_state.dart';
import 'package:db_core/utils/toast.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/data/tracking/tracking_service.dart';
import 'dart:math';

class ProductDetailInteractor extends CubitInteractor<ProductDetailRoutable, ProductDetailState> implements CommentListSmallListener {
  final CartService _cartService = locator<CartService>();
  final ProductRepository _productRepository = locator<ProductRepository>();
  final int productId;
  
  // Khởi tạo Controller tại đây để giữ vòng đời bền vững
  final commentController = CommentListSmallController();

  ProductDetailInteractor(ProductDetailRoutable router, this.productId) 
      : super(ProductDetailState(), router: router) {
    // Đăng ký listener ngay khi khởi tạo
    commentController.listener = this;
  }

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadProductDetail();

    // Lắng nghe thay đổi giỏ hàng để cập nhật số lượng hiển thị (Badge)
    collect(_cartService.cartStream.listen((items) {
      final totalQty = items.fold<int>(0, (sum, item) => sum + item.quantity);
      emit(state.copyWith(cartItemCount: totalQty));
    }));
  }

  Future<void> _loadProductDetail() async {
    emit(state.copyWith(isLoading: true));

    final result = await _productRepository.getProductSpuDetail(productId);

    if (result case DbSuccess(data: final product)) {
      // [TRACKING]: Log product view detail
      appTracking.productAction(
        productId: product.id.toString(),
        action: EventAction.view,
        parameters: {
          'product_name': product.name,
          'category_id': product.categoryId,
        },
      );

      _processInitialData(product);
    } else if (result case DbFailure(:final error)) {
      emit(state.copyWith(isLoading: false));
      DbToast.show(error.message);
    }
  }

  void _processInitialData(ProductDetail product) {
    final groups = <int, SkuGroup>{};

    for (var sku in product.skus) {
      for (var prop in sku.properties) {
        if (!groups.containsKey(prop.propertyId)) {
          groups[prop.propertyId] = SkuGroup(
            propertyId: prop.propertyId,
            propertyName: prop.propertyName,
            options: [],
          );
        }

        final group = groups[prop.propertyId]!;
        if (!group.options.any((o) => o.valueId == prop.valueId)) {
          group.options.add(prop);
        }
      }
    }

    // Khởi tạo mặc định: Chọn option đầu tiên của mỗi nhóm
    final initialSelected = <int, int>{};
    for (var group in groups.values) {
      if (group.options.isNotEmpty) {
        initialSelected[group.propertyId] = group.options.first.valueId;
      }
    }

    final matchedSku = _findMatchedSku(product.skus, initialSelected);
    final cartQty = _cartService.getItemQuantity(skuId: matchedSku?.id);

    emit(state.copyWith(
      product: product,
      skuGroups: groups.values.toList(),
      selectedOptions: initialSelected,
      currentSku: matchedSku,
      isLoading: false,
      quantity: cartQty > 0 ? cartQty : 1,
    ));
  }

  Sku? _findMatchedSku(List<Sku> skus, Map<int, int> selected) {
    for (var sku in skus) {
      // SKU khớp nếu mọi thuộc tính của nó đều nằm trong Map đang chọn
      bool isMatch = sku.properties.every((p) => selected.containsKey(p.propertyId) && selected[p.propertyId] == p.valueId);
      if (isMatch) return sku;
    }
    return null;
  }

  void updateQuantity(int delta) {
    final newQty = max(1, state.quantity + delta);
    if (newQty != state.quantity) {
      emit(state.copyWith(quantity: newQty));
    }
  }

  void selectOption(int propertyId, int valueId) {
    final newSelected = Map<int, int>.from(state.selectedOptions);
    newSelected[propertyId] = valueId;

    final matchedSku = _findMatchedSku(state.product?.skus ?? [], newSelected);

    emit(state.copyWith(
      selectedOptions: newSelected,
      currentSku: matchedSku,
    ));
  }

  void addToCart() {
    if (state.isAddingToCart || state.product == null) return;

    emit(state.copyWith(isAddingToCart: true));

    _executeAddToCart();

    // Cho phép bấm lại sau 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      if (isClosed) return;
      emit(state.copyWith(isAddingToCart: false));
    });
  }

  void _executeAddToCart() {
    if (state.product == null) return;

    // Chuyển đổi SkuProperty sang SelectedOption để lưu vào Cart
    final List<SelectedOption>? selectedOptions = state.currentSku?.properties
        .map((p) => SelectedOption()
          ..optionServerId = p.valueId
          ..groupName = p.propertyName
          ..optionName = p.valueName
          ..extraPrice = 0.0)
        .toList();

    _cartService.addToCart(
      skuId: state.currentSku?.id ?? 0,
      quantity: state.quantity,
      product: state.product!,
      options: selectedOptions,
    );
  }

  void buyNow() async {
    if (state.product == null) return;

    if (_cartService.currentItems.isNotEmpty) {
      // Nếu trong giỏ hàng đã có sản phẩm => chuyển trang thanh toán
      final contract = CartCheckoutFactory.createFromCurrentCart();
      router?.gotoCheckout(contract);
    } else {
      // Nếu trong giỏ hàng chưa có sản phẩm nào => thêm vào giỏ rồi chuyển trang
      // Thực hiện âm thầm (không set isAddingToCart để tránh hiện loading trên nút kia)
      _executeAddToCart();
      // Chuyển trang ngay sau khi lệnh add được gửi đi (Optimistic UI của CartService sẽ lo phần còn lại)
      final contract = CartCheckoutFactory.createFromCurrentCart();
      router?.gotoCheckout(contract);
    }
  }

  @override
  void onNavigateToAllComments(int productId, int type) {
    router?.gotoCommentList(productId, type);
  }
}
