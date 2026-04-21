
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {

  static double roundDouble(double value) {
    double mod = 100;
    return ((value * mod).floorToDouble() / mod);
  }

  static String formatPriceInSuggest(double price) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    if (price >= 1000000000) {
      final numBillion = price / 1000000000;
      final formatStr = roundDouble(numBillion)
          .toString()
          .replaceAll(regex, '')
          .replaceAll('.', ',');
      return '$formatStr tỷ';
    } else {
      final numMillion = price / 1000000;
      return '${numMillion.toInt()} triệu';
    }
  }

  static Future<void> clearAppCache() async {
    // Clear current User Session (if need)
    // final PrefHelper prefHelper = GetIt.I.get<PrefHelper>();
    // await prefHelper.removeAccessToken();
    // await prefHelper.removeRefreshToken();
    // await prefHelper.removeUserInfo();

    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  static Future<String> versionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (kReleaseMode) {
      return packageInfo.version;
    }
    return '${packageInfo.version} (${packageInfo.buildNumber})';
  }

  static void launchUrlString(String url, {LaunchMode mode = LaunchMode.platformDefault}) async {
    final Uri url0 = Uri.parse(url);
    if (!await launchUrl(
      url0,
      mode: mode,
    )) {
      throw 'Could not launch $url0';
    }
  }

  static bool isPhoneNumber(String? phone) {
    if (phone == null) {
      return false;
    }
    // Kiem tra sdt 10 so
    // ^0: Bắt đầu bằng số 0
    // [0-9]{9}: Theo sau đúng 9 chữ số từ 0 đến 9
    // $: Kết thúc chuỗi tại đó (không cho phép thừa ký tự)
    final RegExp phoneRegExp = RegExp(r'^0[0-9]{9}$');
    return phoneRegExp.hasMatch(phone);
  }

  static bool isEmailAddress(String? email) {
    if (email == null) {
      return false;
    }
    // Regular Expressions check email address
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(email);
  }

  static bool isDecimalNumber(double? text) {
    return text != null && text != 0;
  }

  static bool isUrl(String? url) {
    if (url == null) return false;
    if (url.toString().isEmpty == true) return false;
    return url.toString().startsWith("http") ||
        url.toString().startsWith("https");
  }
}