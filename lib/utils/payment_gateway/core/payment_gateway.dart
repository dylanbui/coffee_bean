import '../models/payment_request.dart';
import '../models/payment_result.dart';
import '../models/payment_enums.dart';

/// Abstract class định nghĩa các phương thức mà mọi cổng thanh toán phải có
abstract class PaymentGateway {
  /// Tên định danh của cổng thanh toán
  PaymentType get type;

  /// Khởi tạo giao dịch thanh toán
  Future<PaymentResult> createPayment(PaymentRequest request);

  /// Xác thực callback từ DeepLink hoặc IPN
  /// Trả về true nếu chữ ký hợp lệ
  bool verifyCallback(Map<String, String> queryParameters);

  /// Kiểm tra trạng thái giao dịch hiện tại từ server của gateway
  Future<PaymentResult> checkTransactionStatus(String orderId, {String? requestId});
  
  /// Phân tích query parameters từ callback thành TransactionStatus
  TransactionStatus parseStatus(Map<String, String> queryParameters);

  /// Lấy mã đơn hàng từ query parameters của callback
  String getOrderId(Map<String, String> queryParameters);

  /// NEW: mỗi gateway tự biết cách nhận diện callback
  bool matchesCallback(Map<String, String> queryParameters);
}
