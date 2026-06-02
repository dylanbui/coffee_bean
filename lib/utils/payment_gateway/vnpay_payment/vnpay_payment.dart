import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

/// Enum xác định loại hàm hash (mặc định SHA512)
enum VNPayHashType { sha512 }

/// Lớp xử lý thanh toán VNPAY
/// Cung cấp các chức năng: tạo URL thanh toán, xác minh chữ ký, truy vấn giao dịch, hoàn tiền
class VNPAYPayment {
  // URL thanh toán
  static const String sandboxPaymentUrl =
      'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';
  static const String productionPaymentUrl = 'https://pay.vnpay.vn/vpcpay.html';

  // URL API truy vấn giao dịch
  static const String sandboxQueryUrl =
      'https://sandbox.vnpayment.vn/merchant_webapi/api/transaction';
  static const String productionQueryUrl =
      'https://api.vnpayment.vn/merchant_webapi/api/transaction';

  /// Mã đơn vị tính tiền (TMN Code) của merchant
  final String tmnCode;

  /// Khóa bí mật cho việc tính toán HMAC
  final String hashSecret;

  /// true = Sandbox (test), false = Production (thực tế)
  final bool isSandbox;

  /// Loại hash, mặc định SHA512
  final VNPayHashType hashType;

  /// Khởi tạo VNPAY Payment
  /// [tmnCode]: Mã đơn vị của bạn từ VNPAY
  /// [hashSecret]: Khóa bí mật từ VNPAY
  /// [isSandbox]: Sử dụng sandbox hay production
  /// [hashType]: Loại hàm hash (mặc định SHA512)
  VNPAYPayment({
    required this.tmnCode,
    required this.hashSecret,
    this.isSandbox = true,
    this.hashType = VNPayHashType.sha512,
  });

  /// Tính toán HMAC-SHA512
  /// [data]: Dữ liệu cần mã hóa
  /// Returns: Chuỗi hex đại diện cho hash
  String _generateHash(String data) {
    final hmac = Hmac(sha512, utf8.encode(hashSecret));
    final bytes = hmac.convert(utf8.encode(data)).bytes;
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Mã hóa URL theo VNPAY: space được encode thành '+' thay vì '%20'
  /// [value]: Chuỗi cần mã hóa
  /// Returns: Chuỗi đã mã hóa theo chuẩn VNPAY
  String _encodeVNPay(String value) {
    return Uri.encodeComponent(value).replaceAll('%20', '+');
  }

  /// Tạo chuỗi URL thanh toán có chữ ký HMAC-SHA512
  /// Phương thức này chỉ tạo URL, không mở trình duyệt
  /// [txnRef]: Mã giao dịch duy nhất (tối đa 40 ký tự)
  /// [amount]: Số tiền (VND)
  /// [orderInfo]: Mô tả thanh toán
  /// [returnUrl]: URL quay lại app (deeplink scheme)
  /// [bankCode]: Mã ngân hàng tùy chọn
  /// [expireDate]: Hạn thanh toán
  /// [ipAddr]: Địa chỉ IP
  /// [locale]: Ngôn ngữ hiển thị
  /// [orderType]: Loại đơn hàng
  /// Returns: URL thanh toán đầy đủ với chữ ký
  String generatePaymentUrl({
    required String txnRef,
    required double amount,
    required String orderInfo,
    required String returnUrl,
    String? bankCode,
    DateTime? expireDate,
    String ipAddr = '127.0.0.1',
    String locale = 'vn',
    String orderType = 'billpayment',
  }) {
    final now = DateTime.now();
    final createDate = DateFormat('yyyyMMddHHmmss').format(now);
    final finalExpireDate = expireDate ?? now.add(const Duration(minutes: 15));
    final expireDateStr = DateFormat('yyyyMMddHHmmss').format(finalExpireDate);
    final amountStr = (amount * 100).toInt().toString();

    // BƯỚC 1: Tạo danh sách tham số gửi đến VNPAY
    final params = <String, String>{
      'vnp_Version': '2.1.0', // API version
      'vnp_Command': 'pay', // Lệnh thanh toán
      'vnp_TmnCode': tmnCode, // Mã đơn vị merchant
      'vnp_Locale': locale, // Ngôn ngữ
      'vnp_CurrCode': 'VND', // Đơn vị tiền tệ
      'vnp_TxnRef': txnRef, // Mã giao dịch
      'vnp_OrderInfo': orderInfo, // Mô tả đơn hàng
      'vnp_OrderType': orderType, // Loại đơn hàng
      'vnp_Amount': amountStr, // Số tiền (x100)
      'vnp_ReturnUrl': returnUrl, // URL quay lại
      'vnp_IpAddr': ipAddr, // IP khách hàng
      'vnp_CreateDate': createDate, // Thời gian tạo
      'vnp_ExpireDate': expireDateStr, // Thời gian hết hạn
    };

    // Thêm mã ngân hàng nếu có
    if (bankCode != null && bankCode.isNotEmpty) {
      params['vnp_BankCode'] = bankCode;
    }

    // BƯỚC 2: Sắp xếp các tham số theo thứ tự chữ cái (A-Z)
    final sorted = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    // BƯỚC 3: Tạo chuỗi query string, mã hóa URL mỗi key=value
    // Quy tắc: space -> '+' (không phải '%20')
    String encodedQuery = '';
    sorted.forEach((key, value) {
      final encoded = '${_encodeVNPay(key)}=${_encodeVNPay(value)}';
      if (encodedQuery.isEmpty) {
        encodedQuery = encoded;
      } else {
        encodedQuery += '&$encoded';
      }
    });
    // BƯỚC 4: Tính HMAC-SHA512 của chuỗi đã mã hóa
    final hash = _generateHash(encodedQuery);

    // BƯỚC 5: Tạo URL thanh toán cuối cùng với chữ ký
    final baseUrl = isSandbox ? sandboxPaymentUrl : productionPaymentUrl;
    return '$baseUrl?$encodedQuery&vnp_SecureHash=$hash';
  }

  /// Xác minh chữ ký phản hồi từ VNPAY
  /// ĐIỀU NÀY RẤT QUAN TRỌNG để đảm bảo phản hồi thực sự từ VNPAY
  /// [params]: Map chứa các tham số từ deeplink/IPN callback
  /// Returns: true nếu chữ ký hợp lệ, false nếu không
  bool verifyResponse(Map<String, String> params) {
    // Lấy chữ ký từ phản hồi
    final receivedHash = params['vnp_SecureHash'];
    if (receivedHash == null || receivedHash.isEmpty) {
      return false;
    }

    // Loại bỏ các tham số không cần thiết khi tính hash
    final hashParams = Map<String, String>.from(params)
      ..remove('vnp_SecureHash')
      ..remove('vnp_SecureHashType');

    // Giải mã URL encode các tham số
    final decodedParams = <String, String>{};
    hashParams.forEach((key, value) {
      decodedParams[key] = Uri.decodeComponent(value);
    });

    // Sắp xếp theo alphabet và mã hóa (như khi tạo URL)
    final sorted = Map.fromEntries(
      decodedParams.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    String encodedQuery = '';
    sorted.forEach((key, value) {
      final encoded = '${_encodeVNPay(key)}=${_encodeVNPay(value)}';
      if (encodedQuery.isEmpty) {
        encodedQuery = encoded;
      } else {
        encodedQuery += '&$encoded';
      }
    });

    // Tính hash lại và so sánh (case-insensitive)
    final calculatedHash = _generateHash(encodedQuery);
    return calculatedHash.toLowerCase() == receivedHash.toLowerCase();
  }

  /// Trích xuất tham số từ Deep Link
  Map<String, String> parseResponseUrl(String url) {
    return Uri.parse(url).queryParameters;
  }

  /// Tạo yêu cầu truy vấn giao dịch
  Map<String, dynamic> buildQueryTransactionRequest({
    required String txnRef,
    required int amount,
    DateTime? transactionDate,
  }) {
    final tranDate = transactionDate ?? DateTime.now();
    final tranDateStr = DateFormat('yyyyMMdd').format(tranDate);

    final data = <String, String>{
      'vnp_RequestId': DateTime.now().millisecondsSinceEpoch.toString(),
      'vnp_Version': '2.1.0',
      'vnp_Command': 'querydr',
      'vnp_TmnCode': tmnCode,
      'vnp_TxnRef': txnRef,
      'vnp_OrderInfo': txnRef,
      'vnp_TransactionDate': tranDateStr,
      'vnp_CreateDate': DateFormat('yyyyMMddHHmmss').format(DateTime.now()),
      'vnp_IpAddr': '127.0.0.1',
    };

    final sorted = Map.fromEntries(
      data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    String hashData = '';
    sorted.forEach((key, value) {
      if (hashData.isEmpty) {
        hashData = '$key=$value';
      } else {
        hashData += '&$key=$value';
      }
    });

    data['vnp_SecureHash'] = _generateHash(hashData);

    return data;
  }

  /// Tạo yêu cầu hoàn tiền
  Map<String, dynamic> buildRefundRequest({
    required String txnRef,
    required int amount,
    required int transactionNo,
    DateTime? transactionDate,
  }) {
    final tranDate = transactionDate ?? DateTime.now();
    final tranDateStr = DateFormat('yyyyMMdd').format(tranDate);

    final data = <String, String>{
      'vnp_RequestId': DateTime.now().millisecondsSinceEpoch.toString(),
      'vnp_Version': '2.1.0',
      'vnp_Command': 'refund',
      'vnp_TmnCode': tmnCode,
      'vnp_TxnRef': txnRef,
      'vnp_Amount': amount.toString(),
      'vnp_TransactionDate': tranDateStr,
      'vnp_CreateDate': DateFormat('yyyyMMddHHmmss').format(DateTime.now()),
      'vnp_TransactionNo': transactionNo.toString(),
      'vnp_IpAddr': '127.0.0.1',
    };

    final sorted = Map.fromEntries(
      data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    String hashData = '';
    sorted.forEach((key, value) {
      if (hashData.isEmpty) {
        hashData = '$key=$value';
      } else {
        hashData += '&$key=$value';
      }
    });

    data['vnp_SecureHash'] = _generateHash(hashData);

    return data;
  }

  /// Lấy URL truy vấn giao dịch
  String getQueryUrl() => isSandbox ? sandboxQueryUrl : productionQueryUrl;
}
