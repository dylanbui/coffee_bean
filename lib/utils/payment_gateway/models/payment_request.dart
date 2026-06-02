/// Model chứa thông tin yêu cầu thanh toán chung cho tất cả các cổng
class PaymentRequest {
  /// Mã đơn hàng duy nhất
  final String orderId;

  /// Số tiền thanh toán (VND)
  final double amount;

  /// Mô tả đơn hàng
  final String orderInfo;

  /// URL quay lại ứng dụng sau khi thanh toán xong
  final String returnUrl;

  /// Các dữ liệu bổ sung tùy chọn cho từng cổng thanh toán cụ thể
  /// Ví dụ: items, userInfo cho MoMo
  final Map<String, dynamic>? extraData;

  PaymentRequest({
    required this.orderId,
    required this.amount,
    required this.orderInfo,
    required this.returnUrl,
    this.extraData,
  });
}
