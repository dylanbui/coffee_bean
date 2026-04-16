import 'dart:ui';

class AppColor {
  static final grayText = HexColor('5f5f5f');
  static final secondaryText = HexColor('363636');
  static final gray4A = HexColor('4A4A4A');
  static final gray44 = HexColor('444444');
  static final gray89 = HexColor('898989');
  static final grayD5 = HexColor('D5D5D5');
  static final grayD8 = HexColor('D8D8D8');
  static final grayD7 = HexColor('D7D7D7');
  static final gray7D = HexColor('7D7D7D');
  static final grayF0 = HexColor('F0F0F0');
  static final grayF4 = HexColor('F4F4F4');
  static final grayF5 = HexColor('F5F5F5');
  static final grayF9 = HexColor('F9F9F9');
  static final grayE4 = HexColor('E4E4E4');
  static final grayCC = HexColor('CCCCCC');
  static final grayBorderDE = HexColor('DEE1E2');
  static final grayC6 = HexColor('C6C6C8');
  static final gray55 = HexColor('555555');
  static final gray400 = HexColor('CED4DA');
  static final gray400_ibuy = HexColor('6A6D74');
  static final gray500 = HexColor('ADB5BD');
  static final gray600 = HexColor('6C757D');
  static final propzyBlue = HexColor('155AA9');
  static final propzyBlue_100 = HexColor('E8EFF6');
  static final orangeDark = HexColor('f17423');
  static final red = HexColor('FF3B30');
  static final white = HexColor('FFFFFF');
  static final black = HexColor('000000');
  static final blackDefault = HexColor('242933');
  static final black_40p = HexColor('66000000');
  static final black_55p = HexColor('8C000000');
  static final black_65p = HexColor('A6000000');
  static final black_80p = HexColor('CC000000');
  static final rippleDark = HexColor('80B0B0B0');
  static final rippleLight = HexColor('80FFFFFF');
  static final blueLink = HexColor('0072EF');
  static final systemBlue = HexColor('007AFF');
  static final dividerGray = HexColor('DCDCDC');
  static final greenBackground = HexColor('E9F0E6');
  static final greenTextBadge = HexColor('46842F');
  static final propzyOrange = HexColor('EF7733');
  static final propzyBlue100 = HexColor('E8EFF6');
  static final green_iBuy = HexColor('248A3D');
  static final green_bg_time = HexColor('EDF9F4');
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
