///
/// * HƯỚNG DẪN SỬ DỤNG PAYMENT MANAGER
//  *
//  * 1. Khởi tạo và Đăng ký Gateway:
//  *    final manager = PaymentManager();
//  *    manager.registerGateway(MomoProvider());
//  *    manager.registerGateway(VNPayProvider());
//  *
//  * 2. Cấu hình Backend Verifier (Bắt buộc để đối soát Server):
//  *    manager.backendVerifier = (orderId, type, params) async {
//  *      final res = await myApi.checkStatus(orderId);
//  *      return res.isPaid ? PaymentResult.success() : PaymentResult.failed();
//  *    };
//  *
//  * 3. Thực hiện thanh toán (Dùng URL từ Server để bảo mật):
//  *    await manager.pay(
//  *      type: PaymentType.momo,
//  *      request: PaymentRequest(orderId: '123', amount: 50000, ...),
//  *      paymentUrlFromServer: 'https://...',
//  *    );
//  *
//  * 4. Xử lý Callback (Deep Link / Webview):
//  *    final result = await manager.handleCallback(url);
//  */

import 'package:url_launcher/url_launcher.dart';
import 'package:coffee_bean/utils/payment_gateway/models/payment_enums.dart';
import 'package:coffee_bean/utils/payment_gateway/models/payment_request.dart';
import 'package:coffee_bean/utils/payment_gateway/models/payment_result.dart';
import 'package:coffee_bean/utils/payment_gateway/core/payment_gateway.dart';

/// Kiểu hàm để thực hiện verify kết quả với Backend
typedef BackendVerifier = Future<PaymentResult> Function(
  String orderId, 
  PaymentType type, 
  Map<String, String> rawParams
);

/// Kiểu hàm để mở trang thanh toán (có thể là Webview hoặc External App)
typedef PaymentLauncher = Future<bool> Function(String url, String returnUrl);

/// Lớp quản lý chính các cổng thanh toán (Facade/Manager)
class PaymentManager {
  final Map<PaymentType, PaymentGateway> _gateways = {};
  
  /// Callback dùng để verify với Backend của bạn
  BackendVerifier? backendVerifier;

  /// Callback tùy chỉnh cách mở URL (ví dụ: mở In-app Webview để che giấu link)
  PaymentLauncher? customLauncher;

  /// Đăng ký một cổng thanh toán
  void registerGateway(PaymentGateway gateway) {
    _gateways[gateway.type] = gateway;
  }

  /// Khởi tạo thanh toán
  /// [paymentUrlFromServer] Nếu có, sẽ dùng URL này thay vì tự tạo local
  Future<PaymentResult> pay({
    required PaymentType type,
    required PaymentRequest request,
    String? paymentUrlFromServer,
    bool autoLaunch = true,
  }) async {
    String? finalUrl = paymentUrlFromServer;

    if (finalUrl == null) {
      final gateway = _gateways[type];
      if (gateway == null) {
        return PaymentResult.failed(message: 'Cổng thanh toán $type chưa được đăng ký');
      }
      final result = await gateway.createPayment(request);
      if (!result.isSuccess) return result;
      finalUrl = result.paymentUrl;
    }

    if (finalUrl != null && autoLaunch) {
      bool success = false;
      if (customLauncher != null) {
        // Sử dụng launcher tùy chỉnh (ví dụ mở In-app Webview)
        success = await customLauncher!(finalUrl, request.returnUrl);
      } else {
        // Mặc định mở ứng dụng ngoài
        success = await launchPaymentUrl(finalUrl);
      }
      
      if (!success) {
        return PaymentResult.failed(message: 'Không thể mở trang thanh toán');
      }
    }

    return PaymentResult.success(url: finalUrl);
  }

  /// Hàm hỗ trợ mở URL thanh toán ra ứng dụng ngoài
  Future<bool> launchPaymentUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
    return false;
  }

  /// Xử lý dữ liệu trả về từ Deep Link hoặc từ Webview callback
  Future<PaymentResult> handleCallback(String url) async {
    final uri = Uri.parse(url);
    final params = uri.queryParameters;
    
    // 1. Nhận diện cổng thanh toán
    PaymentGateway? gateway;
    for (final g in _gateways.values) {
      if (g.matchesCallback(params)) {
        gateway = g;
        break;
      }
    }

    if (gateway == null) {
      return PaymentResult.failed(message: 'Không xác định được cổng thanh toán từ callback');
    }

    // 2. Kiểm tra chữ ký local (Bảo mật tầng 1)
    final isSignatureValid = gateway.verifyCallback(params);
    if (!isSignatureValid) {
      return PaymentResult.failed(message: 'Chữ ký phản hồi từ Gateway không hợp lệ');
    }

    final orderId = gateway.getOrderId(params);
    final localStatus = gateway.parseStatus(params);

    // 3. Nếu local báo Hủy, trả về luôn
    if (localStatus == TransactionStatus.cancelled) {
      return PaymentResult(
        isSuccess: false,
        status: TransactionStatus.cancelled,
        message: 'Người dùng đã hủy thanh toán',
        rawData: params,
      );
    }

    // 4. Nếu local báo Thành công (hoặc Pending), hỏi Backend (Bảo mật tầng 2 - Source of Truth)
    if (backendVerifier != null) {
      try {
        return await backendVerifier!(orderId, gateway.type, params);
      } catch (e) {
        return PaymentResult.failed(message: 'Lỗi xác nhận với Server: $e');
      }
    }

    return PaymentResult(
      isSuccess: localStatus == TransactionStatus.success,
      status: localStatus,
      rawData: params,
    );
  }
}
