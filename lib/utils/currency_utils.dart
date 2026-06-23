import 'package:intl/intl.dart';

// https://getemoji.com/
// https://github.com/lipis/flag-icons/tree/main/flags/4x3

enum Currency {
  vnd(symbol: 'đ', divisor: 100, decimalDigits: 0, symbolAtEnd: true, locale: 'vi_VN', emoji: '🇻🇳'),
  usd(symbol: '\$', divisor: 100, decimalDigits: 2, symbolAtEnd: false, locale: 'en_US', emoji: '🇺🇸'),
  cny(symbol: '¥', divisor: 100, decimalDigits: 2, symbolAtEnd: false, locale: 'zh_CN', emoji: '🇨🇳');

  final String symbol;
  final int divisor; // Tỉ lệ quy đổi từ đơn vị nhỏ nhất của API
  final int decimalDigits; // Số chữ số thập phân hiển thị
  final bool symbolAtEnd; // Vị trí đặt ký hiệu (trước hay sau)
  final String locale; // Locale để format số (dấu chấm/phẩy)
  final String emoji; // Emoji lá cờ đại diện cho quốc gia của đồng tiền

  const Currency({
    required this.symbol,
    required this.divisor,
    required this.decimalDigits,
    required this.symbolAtEnd,
    required this.locale,
    required this.emoji,
  });

  // Cache formatter để tối ưu hiệu năng
  static final Map<String, NumberFormat> _formatters = {};

  NumberFormat get _formatter {
    final cacheKey = "$locale-$decimalDigits";
    if (!_formatters.containsKey(cacheKey)) {
      _formatters[cacheKey] = NumberFormat.currency(
        locale: locale,
        symbol: '',
        decimalDigits: decimalDigits,
      );
    }
    return _formatters[cacheKey]!;
  }

  /// Logic định dạng số tiền dựa trên cấu hình của chính loại tiền đó
  String format(num rawPrice) {
    final double amount = rawPrice / divisor;
    String formattedNumber = _formatter.format(amount).trim();

    if (symbolAtEnd) {
      return '$formattedNumber $symbol';
    } else {
      return '$symbol$formattedNumber';
    }
  }
}
