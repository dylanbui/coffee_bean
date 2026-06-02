import 'payment_enums.dart';

/// Kết quả trả về từ việc khởi tạo thanh toán hoặc kiểm tra trạng thái
class PaymentResult {
  /// Thành công hay thất bại (ở bước gọi gateway)
  final bool isSuccess;

  /// URL thanh toán để mở (nếu có)
  final String? paymentUrl;

  /// Thông báo từ gateway hoặc backend
  final String? message;

  /// Trạng thái giao dịch chi tiết
  final TransactionStatus status;

  /// Mã lỗi (nếu có)
  final String? errorCode;

  /// Dữ liệu thô từ gateway
  final Map<String, dynamic>? rawData;

  /// Dữ liệu từ Backend trả về sau khi xác thực
  final dynamic backendData;

  PaymentResult({
    required this.isSuccess,
    this.paymentUrl,
    this.message,
    this.status = TransactionStatus.unknown,
    this.errorCode,
    this.rawData,
    this.backendData,
  });

  factory PaymentResult.success({
    String? url, 
    Map<String, dynamic>? rawData,
    dynamic backendData,
  }) {
    return PaymentResult(
      isSuccess: true,
      paymentUrl: url,
      status: TransactionStatus.success,
      rawData: rawData,
      backendData: backendData,
    );
  }

  factory PaymentResult.failed({String? message, String? errorCode}) {
    return PaymentResult(
      isSuccess: false,
      message: message,
      errorCode: errorCode,
      status: TransactionStatus.failed,
    );
  }
}
