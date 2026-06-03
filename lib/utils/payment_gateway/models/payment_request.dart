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

  /// URL IPN (server nhận thông báo giao dịch) - tùy chọn
  final String? notifyUrl;

  /// Mã requestId (nếu gateway yêu cầu) - tùy chọn
  final String? requestId;

  /// URL thanh toán từ server (đã ký hash) - tùy chọn
  final String? paymentUrlFromServer;

  /// Các dữ liệu bổ sung tùy chọn cho từng cổng thanh toán cụ thể
  final Map<String, dynamic>? extraData;

  PaymentRequest({
    required this.orderId,
    required this.amount,
    required this.orderInfo,
    required this.returnUrl,
    this.notifyUrl,
    this.requestId,
    this.paymentUrlFromServer,
    this.extraData,
  });
}
