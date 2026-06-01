import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

enum DeliveryMethod {
  dineIn,
  takeAway
}

enum OrderConfirmationStatus {
  confirming,
  processing,
  success,
  failure
}


class OrderConfirmationState extends BaseBlocState {
  final OrderConfirmationStatus status;
  final String processingMessage;
  final String? orderNumber;
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
    this.status = OrderConfirmationStatus.confirming,
    this.processingMessage = '',
    this.orderNumber,
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
    OrderConfirmationStatus? status,
    String? processingMessage,
    String? orderNumber,
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
      status: status ?? this.status,
      processingMessage: processingMessage ?? this.processingMessage,
      orderNumber: orderNumber ?? this.orderNumber,
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
        status,
        processingMessage,
        orderNumber,
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

class OrderConfirmationLoginNotifyState extends OrderConfirmationState {
  final DateTime _timestamp = DateTime.now(); // Đảm bảo state luôn duy nhất để trigger listener

  OrderConfirmationLoginNotifyState(OrderConfirmationState state)
      : super(
          status: state.status,
          processingMessage: state.processingMessage,
          orderNumber: state.orderNumber,
          isLoading: state.isLoading,
          selectedStore: state.selectedStore,
          cartItems: state.cartItems,
          selectedCoupon: state.selectedCoupon,
          couponDiscount: state.couponDiscount,
          usedPoints: state.usedPoints,
          pointsDiscount: state.pointsDiscount,
          paymentMethod: state.paymentMethod,
          deliveryMethod: state.deliveryMethod,
          note: state.note,
        );

  @override
  List<Object?> get props => super.props..add(_timestamp);
}
