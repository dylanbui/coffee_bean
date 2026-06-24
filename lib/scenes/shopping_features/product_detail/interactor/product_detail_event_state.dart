import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/data/model/product.dart';

class ProductDetailState extends BaseBlocState {
  final ProductDetail? product;
  final int quantity;
  final List<Product> suggestedProducts;
  final Map<int, dynamic> selectedOptions;
  final bool isLoading;
  final bool isAddingToCart;

  ProductDetailState({
    this.product,
    this.quantity = 1,
    this.suggestedProducts = const [],
    this.selectedOptions = const {},
    this.isLoading = true,
    this.isAddingToCart = false,
  });

  ProductDetailState copyWith({
    ProductDetail? product,
    int? quantity,
    List<Product>? suggestedProducts,
    Map<int, dynamic>? selectedOptions,
    bool? isLoading,
    bool? isAddingToCart,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      suggestedProducts: suggestedProducts ?? this.suggestedProducts,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      isLoading: isLoading ?? this.isLoading,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
    );
  }

  double get totalPrice {
    if (product == null) return 0;
    return (product!.price.toDouble()) * quantity;
  }

  @override
  List<Object?> get props => [product, quantity, suggestedProducts, selectedOptions, isLoading, isAddingToCart];
}
