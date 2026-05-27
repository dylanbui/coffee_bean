import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

class FoodDetailState extends BaseBlocState {
  final TblFood? product;
  final int quantity;
  final List<TblFood> suggestedProducts;
  final Map<int, TblProductOption> selectedOptions; // groupId -> selectedOption
  final bool isLoading;
  final bool isAddingToCart;

  FoodDetailState({
    this.product,
    this.quantity = 1,
    this.suggestedProducts = const [],
    this.selectedOptions = const {},
    this.isLoading = true,
    this.isAddingToCart = false,
  });

  FoodDetailState copyWith({
    TblFood? product,
    int? quantity,
    List<TblFood>? suggestedProducts,
    Map<int, TblProductOption>? selectedOptions,
    bool? isLoading,
    bool? isAddingToCart,
  }) {
    return FoodDetailState(
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
    double extra = 0;
    selectedOptions.forEach((key, value) {
      extra += value.extraPrice;
    });
    return (product!.price + extra) * quantity;
  }

  @override
  List<Object?> get props => [product, quantity, suggestedProducts, selectedOptions, isLoading, isAddingToCart];
}
