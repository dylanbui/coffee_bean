/**
 * HƯỚNG DẪN SỬ DỤNG VNPAY PROVIDER
 * 
 * 1. Khởi tạo không dùng Key (Ưu tiên bảo mật, nhận URL từ Backend):
 *    final vnpayProvider = VNPayProvider();
 * 
 * 2. Khởi tạo có dùng Key (Dùng để tự tạo URL offline tại App):
 *    final vnpayProvider = VNPayProvider(
 *      tmnCode: 'VNPAY...',
 *      hashSecret: '...',
 *      isSandbox: true,
 *    );
 * 
 * 3. Đăng ký vào PaymentManager:
 *    paymentManager.registerGateway(vnpayProvider);
 */

import 'package:coffee_bean/utils/payment_gateway/core/payment_gateway.dart';
import 'package:coffee_bean/utils/payment_gateway/models/payment_enums.dart';
import 'package:coffee_bean/utils/payment_gateway/models/payment_request.dart';
import 'package:coffee_bean/utils/payment_gateway/models/payment_result.dart';
import 'package:coffee_bean/utils/payment_gateway/vnpay_payment/vnpay_payment.dart';

class VNPayProvider implements PaymentGateway {
  final VNPAYPayment _service;

  VNPayProvider({
    String? tmnCode,
    String? hashSecret,
    bool isSandbox = true,
  }) : _service = VNPAYPayment(
          tmnCode: tmnCode,
          hashSecret: hashSecret,
          isSandbox: isSandbox,
        );

  @override
  PaymentType get type => PaymentType.vnpay;

  @override
  Future<PaymentResult> createPayment(PaymentRequest request) async {
    try {
      final url = _service.generatePaymentUrl(
        txnRef: request.orderId,
        amount: request.amount,
        orderInfo: request.orderInfo,
        returnUrl: request.returnUrl,
        bankCode: request.extraData?['bankCode'],
        ipAddr: request.extraData?['ipAddr'] ?? '127.0.0.1',
      );
      
      // VNPay tạo URL offline nên trả về ngay lập tức qua Future.value
      return PaymentResult.success(url: url);
    } catch (e) {
      return PaymentResult.failed(message: e.toString());
    }
  }

  @override
  bool verifyCallback(Map<String, String> queryParameters) {
    // Nếu có key thì verify, nếu không có thì trả về true để delegate cho backend verify
    return _service.verifyResponse(queryParameters);
  }

  @override
  Future<PaymentResult> checkTransactionStatus(String orderId, {String? requestId}) async {
    // Lưu ý: Việc gọi API QueryDR của VNPay cần gọi Server-to-Server
    // Ở đây ta mô phỏng việc chuẩn bị request hoặc gọi nếu service có hỗ trợ
    try {
      // VNPayPayment hiện tại chỉ có buildQueryTransactionRequest, chưa có hàm call http
      // Trong tương lai nên đưa việc call này vào service
      return PaymentResult(
        isSuccess: true,
        status: TransactionStatus.pending,
        message: "Tính năng kiểm tra trạng thái cần thực hiện qua Backend"
      );
    } catch (e) {
      return PaymentResult.failed(message: e.toString());
    }
  }

  @override
  TransactionStatus parseStatus(Map<String, String> queryParameters) {
    final responseCode = queryParameters['vnp_ResponseCode'];
    if (responseCode == '00') {
      return TransactionStatus.success;
    } else if (responseCode == '24') {
      return TransactionStatus.cancelled;
    } else {
      return TransactionStatus.failed;
    }
  }

  @override
  String getOrderId(Map<String, String> queryParameters) {
    return queryParameters['vnp_TxnRef'] ?? '';
  }
}
