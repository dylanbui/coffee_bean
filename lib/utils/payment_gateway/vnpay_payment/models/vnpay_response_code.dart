/// VNPAY Response Code Model
/// Reference: https://sandbox.vnpayment.vn/apis/docs/bang-ma-loi/
class VNPayResponseCode {
  final String code;
  final String message;
  final String description;
  final bool isSuccess;

  const VNPayResponseCode({
    required this.code,
    required this.message,
    required this.description,
    required this.isSuccess,
  });

  @override
  String toString() => '$code: $message';

  /// Get response code details by code
  static VNPayResponseCode getByCode(String code) {
    return _paymentResponseCodes[code] ??
        VNPayResponseCode(
          code: code,
          message: 'Unknown Error',
          description:
              'Các lỗi khác (lỗi còn lại, không có trong danh sách mã lỗi đã liệt kê)',
          isSuccess: false,
        );
  }

  // Payment Response Codes (Thanh toán)
  static const responseCode00 = VNPayResponseCode(
    code: '00',
    message: 'Giao dịch thành công',
    description: 'Giao dịch thanh toán thành công',
    isSuccess: true,
  );

  static const responseCode07 = VNPayResponseCode(
    code: '07',
    message: 'Trừ tiền thành công nhưng giao dịch bị nghi ngờ',
    description:
        'Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).',
    isSuccess: true,
  );

  static const responseCode09 = VNPayResponseCode(
    code: '09',
    message: 'Thẻ/Tài khoản chưa đăng ký dịch vụ InternetBanking',
    description:
        'Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng.',
    isSuccess: false,
  );

  static const responseCode10 = VNPayResponseCode(
    code: '10',
    message: 'Xác thực thông tin thẻ/tài khoản sai quá 3 lần',
    description:
        'Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần',
    isSuccess: false,
  );

  static const responseCode11 = VNPayResponseCode(
    code: '11',
    message: 'Hết hạn chờ thanh toán',
    description:
        'Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch.',
    isSuccess: false,
  );

  static const responseCode12 = VNPayResponseCode(
    code: '12',
    message: 'Thẻ/Tài khoản đã bị khóa',
    description:
        'Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.',
    isSuccess: false,
  );

  static const responseCode13 = VNPayResponseCode(
    code: '13',
    message: 'Nhập sai mật khẩu xác thực giao dịch (OTP)',
    description:
        'Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP). Xin quý khách vui lòng thực hiện lại giao dịch.',
    isSuccess: false,
  );

  static const responseCode24 = VNPayResponseCode(
    code: '24',
    message: 'Khách hàng hủy giao dịch',
    description: 'Giao dịch không thành công do: Khách hàng hủy giao dịch',
    isSuccess: false,
  );

  static const responseCode51 = VNPayResponseCode(
    code: '51',
    message: 'Tài khoản không đủ số dư',
    description:
        'Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.',
    isSuccess: false,
  );

  static const responseCode65 = VNPayResponseCode(
    code: '65',
    message: 'Vượt quá hạn mức giao dịch trong ngày',
    description:
        'Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.',
    isSuccess: false,
  );

  static const responseCode75 = VNPayResponseCode(
    code: '75',
    message: 'Ngân hàng thanh toán đang bảo trì',
    description:
        'Giao dịch không thành công do: Ngân hàng thanh toán đang bảo trì.',
    isSuccess: false,
  );

  static const responseCode79 = VNPayResponseCode(
    code: '79',
    message: 'Nhập sai mật khẩu thanh toán quá số lần quy định',
    description:
        'Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định. Xin quý khách vui lòng thực hiện lại giao dịch',
    isSuccess: false,
  );

  static const responseCode99 = VNPayResponseCode(
    code: '99',
    message: 'Các lỗi khác',
    description:
        'Các lỗi khác (lỗi còn lại, không có trong danh sách mã lỗi đã liệt kê)',
    isSuccess: false,
  );

  // Query Transaction Response Codes
  static const queryCode02 = VNPayResponseCode(
    code: '02',
    message: 'Merchant không hợp lệ',
    description: 'Merchant không hợp lệ (kiểm tra lại vnp_TmnCode)',
    isSuccess: false,
  );

  static const queryCode03 = VNPayResponseCode(
    code: '03',
    message: 'Dữ liệu gửi sang không đúng định dạng',
    description: 'Dữ liệu gửi sang không đúng định dạng',
    isSuccess: false,
  );

  static const queryCode91 = VNPayResponseCode(
    code: '91',
    message: 'Không tìm thấy giao dịch yêu cầu',
    description: 'Không tìm thấy giao dịch yêu cầu',
    isSuccess: false,
  );

  static const queryCode94 = VNPayResponseCode(
    code: '94',
    message: 'Yêu cầu bị trùng lặp',
    description:
        'Yêu cầu bị trùng lặp trong thời gian giới hạn của API (Giới hạn trong 5 phút)',
    isSuccess: false,
  );

  static const queryCode97 = VNPayResponseCode(
    code: '97',
    message: 'Chữ ký không hợp lệ',
    description: 'Chữ ký không hợp lệ',
    isSuccess: false,
  );

  // Refund Response Codes
  static const refundCode02 = VNPayResponseCode(
    code: '02',
    message: 'Tổng số tiền hoàn trả lớn hơn số tiền gốc',
    description: 'Tổng số tiền hoàn trả lớn hơn số tiền gốc',
    isSuccess: false,
  );

  static const refundCode04 = VNPayResponseCode(
    code: '04',
    message: 'Không cho phép hoàn trả toàn phần sau khi hoàn trả một phần',
    description: 'Không cho phép hoàn trả toàn phần sau khi hoàn trả một phần',
    isSuccess: false,
  );

  static const refundCode13 = VNPayResponseCode(
    code: '13',
    message: 'Chỉ cho phép hoàn trả một phần',
    description: 'Chỉ cho phép hoàn trả một phần',
    isSuccess: false,
  );

  static const refundCode93 = VNPayResponseCode(
    code: '93',
    message: 'Số tiền hoàn trả không hợp lệ',
    description:
        'Số tiền hoàn trả không hợp lệ. Số tiền hoàn trả phải nhỏ hơn hoặc bằng số tiền thanh toán.',
    isSuccess: false,
  );

  static const refundCode95 = VNPayResponseCode(
    code: '95',
    message: 'Giao dịch này không thành công bên VNPAY',
    description:
        'Giao dịch này không thành công bên VNPAY. VNPAY từ chối xử lý yêu cầu.',
    isSuccess: false,
  );

  static const refundCode98 = VNPayResponseCode(
    code: '98',
    message: 'Timeout Exception',
    description: 'Timeout Exception',
    isSuccess: false,
  );

  // All response codes map
  static final _paymentResponseCodes = {
    '00': responseCode00,
    '07': responseCode07,
    '09': responseCode09,
    '10': responseCode10,
    '11': responseCode11,
    '12': responseCode12,
    '13': responseCode13,
    '24': responseCode24,
    '51': responseCode51,
    '65': responseCode65,
    '75': responseCode75,
    '79': responseCode79,
    '99': responseCode99,
    '02': queryCode02,
    '03': queryCode03,
    '91': queryCode91,
    '94': queryCode94,
    '97': queryCode97,
  };
}
