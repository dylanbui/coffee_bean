import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/data/model/response/product/product.dart';

class SkuGroup {
  final int propertyId;
  final String propertyName;
  final List<SkuProperty> options;

  SkuGroup({
    required this.propertyId,
    required this.propertyName,
    required this.options,
  });
}

class ProductDetailState extends BaseBlocState {
  final ProductDetail? product;
  final int quantity;
  final List<Product> suggestedProducts;
  final Map<int, int> selectedOptions; // propertyId -> valueId
  final List<SkuGroup> skuGroups;
  final Sku? currentSku;
  final bool isLoading;
  final bool isAddingToCart;
  final int cartItemCount;

  ProductDetailState({
    this.product,
    this.quantity = 1,
    this.suggestedProducts = const [],
    this.selectedOptions = const {},
    this.skuGroups = const [],
    this.currentSku,
    this.isLoading = true,
    this.isAddingToCart = false,
    this.cartItemCount = 0,
  });

  ProductDetailState copyWith({
    ProductDetail? product,
    int? quantity,
    List<Product>? suggestedProducts,
    Map<int, int>? selectedOptions,
    List<SkuGroup>? skuGroups,
    Sku? currentSku,
    bool? isLoading,
    bool? isAddingToCart,
    int? cartItemCount,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      suggestedProducts: suggestedProducts ?? this.suggestedProducts,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      skuGroups: skuGroups ?? this.skuGroups,
      currentSku: currentSku ?? this.currentSku,
      isLoading: isLoading ?? this.isLoading,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      cartItemCount: cartItemCount ?? this.cartItemCount,
    );
  }

  int get displayPrice => currentSku?.price ?? product?.price ?? 0;
  int get displayMarketPrice => currentSku?.marketPrice ?? product?.marketPrice ?? 0;
  String get displayImage => currentSku?.picUrl ?? product?.picUrl ?? "";

  double get totalPrice {
    return (displayPrice.toDouble()) * quantity;
  }

  @override
  List<Object?> get props => [
        product,
        quantity,
        suggestedProducts,
        selectedOptions,
        skuGroups,
        currentSku,
        isLoading,
        isAddingToCart,
        cartItemCount,
      ];
}
