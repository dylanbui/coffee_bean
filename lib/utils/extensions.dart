extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  double? parseVndDouble() {
    return double.tryParse(replaceAll(",", '.'));
  }

  String displayVnd() {
    // Chuyển đổi chuỗi số sang định dạng phân cách hàng nghìn bằng dấu chấm
    // Ví dụ: "5433000" -> "5.433.000"
    if (isEmpty) return "0";
    
    // Xử lý nếu chuỗi có phần thập phân
    List<String> parts = split('.');
    String integerPart = parts[0];
    
    String result = "";
    int count = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      count++;
      result = integerPart[i] + result;
      if (count % 3 == 0 && i != 0) {
        result = ".$result";
      }
    }
    
    return result;
  }

  String trailing000() {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return replaceAll(regex, '');
  }
}

extension NumExtension on num {
  String formatCompact() {
    if (this < 1000) return toString();
    if (this < 1000000) {
      double value = this / 1000;
      String formatted = value.toStringAsFixed(1);
      if (formatted.endsWith('.0')) {
        formatted = formatted.substring(0, formatted.length - 2);
      }
      return "${formatted.replaceAll('.', ',')}K";
    }
    double value = this / 1000000;
    String formatted = value.toStringAsFixed(1);
    if (formatted.endsWith('.0')) {
      formatted = formatted.substring(0, formatted.length - 2);
    }
    return "${formatted.replaceAll('.', ',')}M";
  }

  String toVnd() {
    return "${toInt().toString().displayVnd()}đ";
  }
}
