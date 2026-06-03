/**
 * HƯỚNG DẪN SỬ DỤNG MOMO PROVIDER
 * 
 * 1. Khởi tạo không dùng Key (Ưu tiên bảo mật, ký URL tại Backend):
 *    final momoProvider = MomoProvider();
 * 
 * 2. Khởi tạo có dùng Key (Dùng để tự ký URL tại App):
 *    final momoProvider = MomoProvider(
 *      partnerCode: 'MOMO...',
 *      accessKey: '...',
 *      secretKey: '...',
 *      isTestMode: true,
 *    );
 * 
 * 3. Đăng ký vào PaymentManager:
 *    paymentManager.registerGateway(momoProvider);
 */

import 'package:coffee_bean/utils/payment_gateway/core/payment_gateway.dart';
import 'package:coffee_bean/utils/payment_gateway/models/payment_enums.dart';
import 'package:coffee_bean/utils/payment_gateway/models/payment_request.dart';
import 'package:coffee_bean/utils/payment_gateway/models/payment_result.dart';
import 'package:coffee_bean/utils/payment_gateway/momo_payment/momo_payment.dart';
import 'package:coffee_bean/utils/payment_gateway/momo_payment/models/payment_info.dart';

class MomoProvider implements PaymentGateway {
  final MomoPayment _service;

  MomoProvider({
    String? partnerCode,
    String? accessKey,
    String? secretKey,
    bool isTestMode = true,
  }) : _service = MomoPayment(
          partnerCode: partnerCode,
          accessKey: accessKey,
          secretKey: secretKey,
          isTestMode: isTestMode,
        );

  @override
  PaymentType get type => PaymentType.momo;

  @override
  Future<PaymentResult> createPayment(PaymentRequest request) async {
    try {
      final info = MomoPaymentInfo(
        orderId: request.orderId,
        orderInfo: request.orderInfo,
        amount: request.amount.toInt(),
        redirectUrl: request.returnUrl,
        ipnUrl: request.extraData?['ipnUrl'] ?? request.returnUrl,
        requestId: request.extraData?['requestId'],
        extraData: request.extraData?['extraData'] ?? '',
        items: request.extraData?['items'],
        userInfo: request.extraData?['userInfo'],
      );

      final response = await _service.createPayment(info);

      if (response.resultCode == 0) {
        return PaymentResult.success(
          url: response.payUrl,
          rawData: response.toJson(),
        );
      } else {
        return PaymentResult.failed(
          message: response.message,
          errorCode: response.resultCode.toString(),
        );
      }
    } catch (e) {
      return PaymentResult.failed(message: e.toString());
    }
  }

  @override
  bool verifyCallback(Map<String, String> queryParameters) {
    // MoMo thường verify qua signature trong query parameters
    // Tùy vào cách MoMo trả về, ta sẽ implement logic verify ở đây
    // Nếu App không có SecretKey, ta mặc định là đúng để chuyển sang bước Backend Verify
    return true;
  }

  @override
  Future<PaymentResult> checkTransactionStatus(String orderId, {String? requestId}) async {
    try {
      final response = await _service.checkStatus(
        orderId: orderId,
        requestId: requestId ?? orderId,
      );
      
      return PaymentResult(
        isSuccess: response.resultCode == 0,
        status: _mapMomoStatus(response.resultCode),
        message: response.message,
        rawData: response.toJson(),
      );
    } catch (e) {
      return PaymentResult.failed(message: e.toString());
    }
  }

  @override
  TransactionStatus parseStatus(Map<String, String> queryParameters) {
    final resultCode = int.tryParse(queryParameters['resultCode'] ?? '');
    return _mapMomoStatus(resultCode);
  }

  TransactionStatus _mapMomoStatus(int? resultCode) {
    if (resultCode == 0) return TransactionStatus.success;
    if (resultCode == 1006 || resultCode == 9000) return TransactionStatus.cancelled;
    return TransactionStatus.failed;
  }

  @override
  String getOrderId(Map<String, String> queryParameters) {
    return queryParameters['orderId'] ?? '';
  }
}
