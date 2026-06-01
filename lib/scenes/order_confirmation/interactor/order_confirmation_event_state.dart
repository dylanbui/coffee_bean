import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

enum DeliveryMethod {
  dineIn,
  takeAway
}

class OrderConfirmationState extends BaseBlocState {
  final bool isLoading;
  final TblStore? selectedStore;
  final List<TblCartItem> cartItems;
  final String? selectedCoupon;
  final double couponDiscount;
  final int usedPoints;
  final double pointsDiscount;
  final String paymentMethod;
  final DeliveryMethod deliveryMethod;
  final String note;

  OrderConfirmationState({
    this.isLoading = true,
    this.selectedStore,
    this.cartItems = const [],
    this.selectedCoupon,
    this.couponDiscount = 0,
    this.usedPoints = 4500,
    this.pointsDiscount = 4000,
    this.paymentMethod = 'Tiền mặt',
    this.deliveryMethod = DeliveryMethod.dineIn,
    this.note = '',
  });

  OrderConfirmationState copyWith({
    bool? isLoading,
    TblStore? selectedStore,
    List<TblCartItem>? cartItems,
    String? selectedCoupon,
    double? couponDiscount,
    int? usedPoints,
    double? pointsDiscount,
    String? paymentMethod,
    DeliveryMethod? deliveryMethod,
    String? note,
  }) {
    return OrderConfirmationState(
      isLoading: isLoading ?? this.isLoading,
      selectedStore: selectedStore ?? this.selectedStore,
      cartItems: cartItems ?? this.cartItems,
      selectedCoupon: selectedCoupon ?? this.selectedCoupon,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      usedPoints: usedPoints ?? this.usedPoints,
      pointsDiscount: pointsDiscount ?? this.pointsDiscount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      note: note ?? this.note,
    );
  }

  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  double get totalDiscount => couponDiscount + pointsDiscount;
  double get totalAmount => subtotal - totalDiscount;

  @override
  List<Object?> get props => [
        isLoading,
        selectedStore,
        cartItems,
        selectedCoupon,
        couponDiscount,
        usedPoints,
        pointsDiscount,
        paymentMethod,
        deliveryMethod,
        note,
      ];
}
