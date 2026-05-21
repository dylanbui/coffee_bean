import 'package:intl/intl.dart';
import 'package:coffee_bean/utils/extensions.dart';


class NumberToVietnamese {
  static final _zeroLeftPadding = ["", "00", "0"];
  static final _digits = ["không", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín"];
  static final _digits22 = ["", "mốt", "hai", "ba", "tư", "lăm", "sáu", "bảy", "tám", "chín"];
  static final _multipleThousand = ["", "nghìn", "triệu", "tỷ", "nghìn tỷ", "triệu tỷ", "tỷ tỷ"];

  static String _readTriple(String triple, bool showZeroHundred) {
    final a = triple.codeUnitAt(0) - '0'.codeUnitAt(0);
    final b = triple.codeUnitAt(1) - '0'.codeUnitAt(0);
    final c = triple.codeUnitAt(2) - '0'.codeUnitAt(0);
    if (a == 0 && b == 0 && c == 0) return "";
    if (a == 0 && showZeroHundred) return "không trăm " + _readPair(b, c);
    if (a == 0 && b == 0) return _digits[c];
    if (a == 0 && b != 0) return _readPair(b, c);
    return "${_digits[a]} trăm ${_readPair(b, c)}";
  }

  static String _readPair(int b, int c) {
    if (b == 0) {
      return c == 0 ? "" : " lẻ " + _digits[c];
    } else if (b == 1) {
      return "mười ${c == 0 ? "" : (c == 5 ? "lăm" : _digits[c])}";
    } else {
      return "${_digits[b]} mươi ${_digits22[c]}";
    }
  }

  static List<String> chunk(String list, int chunkSize) {
    List<String> chunks = [];
    int len = list.length;
    for (var i = 0; i < len; i += chunkSize) {
      int size = i + chunkSize;
      chunks.add(list.substring(i, size > len ? len : size));
    }
    return chunks;
  }

  static String? getOrNull(List<String> list, int index) {
    if (index < 0 || index >= list.length) return null;
    return list[index];
  }

  static String convert(int n) {
    if (n == 0) return "Không";
    if (n < 0) return "Âm ${convert(-n).toLowerCase()}";
    final s = n.toString();
    final groups = chunk("${_zeroLeftPadding[s.length % 3]}$s", 3);
    final showZeroHundred = groups.reversed.takeWhile((e) => e == '000').length < groups.length - 1;

    int index = -1;
    final rawResult = groups.fold("", (acc, e) {
      ++index;
      final readTriple = _readTriple(e, showZeroHundred && index > 0);
      final multipleThousand =
          readTriple.isNotEmpty ? getOrNull(_multipleThousand, groups.length - 1 - index) : "";
      return "$acc $readTriple $multipleThousand";
    });

    final result = rawResult.replaceAll(RegExp(r'\s+'), " ").toLowerCase().trim();
    return result.capitalize();
  }

  static String toPrice(double price) {
    var format = NumberFormat("###.##", "en_US");

    if (price >= 1000000000) {
      final billion = price / 1000000000;
      final res = format.format(billion).replaceAll(".", ",");
      return '$res tỷ';
    } else {
      final million = price / 1000000;
      final res = format.format(million).replaceAll(".", ",");
      return '$res triệu';
    }
  }

  static String? formatNumber(double? price, String? subfix) {
    if (price == null) {
      return null;
    }
    var format = NumberFormat("#,###", "vi_VN");
    return "${format.format(price).replaceAll(",", ".")} ${subfix ?? ""}";
  }
}
