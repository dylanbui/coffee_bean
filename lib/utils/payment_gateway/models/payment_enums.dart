/// Danh sách các cổng thanh toán hỗ trợ
enum PaymentType {
  momo,
  vnpay,
  zaloPay, // Sẵn sàng cho tương lai
  shopeePay // Sẵn sàng cho tương lai
}

/// Trạng thái giao dịch
enum TransactionStatus {
  pending,
  success,
  failed,
  cancelled,
  unknown
}
