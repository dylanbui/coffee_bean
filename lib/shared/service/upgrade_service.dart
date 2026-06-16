import 'dart:io';
import 'package:db_core/db_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeSimulateEvent extends DbBaseEvent {}

class UpgradeService {
  static const String _lastCheckKey = "last_upgrade_check_timestamp";
  static const String _latestVersionKey = "latest_app_version";
  static const Duration _checkInterval = Duration(hours: 24);

  // Biến flag để giả lập việc đã update xong (chỉ dùng cho demo/simulation)
  static bool _isSimulatedUpdateDone = false;

  /// Kiểm tra xem có cần update không.
  /// Trả về version mới nếu cần update, ngược lại trả về null.
  /// [force] = true sẽ bỏ qua kiểm tra _checkInterval (Dùng cho simulation)
  static Future<String?> checkUpdate({bool force = false}) async {
    // Nếu đang trong quá trình giả lập và đã bấm update rồi thì trả về null để cho dùng tiếp
    if (force && _isSimulatedUpdateDone) {
      _isSimulatedUpdateDone = false; // Reset cho lần sau
      return null;
    }

    final prefs = DbSharedPreferences();
    
    // Lấy version hiện tại của app
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    
    // Kiểm tra thời gian check gần nhất
    final lastCheckMillis = prefs.get(_lastCheckKey) as int? ?? 0;
    final lastCheck = DateTime.fromMillisecondsSinceEpoch(lastCheckMillis);
    final now = DateTime.now();

    String? latestVersion = prefs.get(_latestVersionKey) as String?;

    // Nếu đã quá thời gian checkInterval hoặc chưa có thông tin version mới, hoặc là force check
    if (force || now.difference(lastCheck) > _checkInterval || latestVersion == null) {
      // TODO: Gọi API hoặc Store để lấy version mới nhất
      // Giả lập lấy version từ API
      latestVersion = await _fetchLatestVersionFromApi();
      
      // Lưu lại thông tin (nếu không phải force simulation thì mới lưu timestamp)
      if (!force) {
        await prefs.set(_lastCheckKey, now.millisecondsSinceEpoch);
        await prefs.set(_latestVersionKey, latestVersion);
      }
    }

    if (latestVersion != null && _isVersionGreaterThan(latestVersion, currentVersion)) {
      return latestVersion;
    }

    return null;
  }

  static Future<void> openStore() async {
    // Đánh dấu đã update (giả lập) để khi quay lại app không bị hiện popup nữa
    _isSimulatedUpdateDone = true;

    // TODO: Thay thế bằng URL thực tế trên Store của bạn
    final appId = Platform.isAndroid ? "com.example.coffee_bean" : "123456789";
    final url = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=$appId"
        : "https://apps.apple.com/app/id$appId";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  static Future<String> _fetchLatestVersionFromApi() async {
    // Giả lập call API chậm 1 chút
    await Future.delayed(const Duration(seconds: 1));
    // Ở đây bạn sẽ gọi API thực tế.
    // Ví dụ trả về 1.1.0 để demo nếu hiện tại là 1.0.0
    return "1.1.0"; 
  }

  static bool _isVersionGreaterThan(String latest, String current) {
    int parsePart(String part) {
      final numericMatch = RegExp(r'\d+').firstMatch(part);
      return numericMatch != null ? int.parse(numericMatch.group(0)!) : 0;
    }

    List<int> latestV = latest.split('.').map(parsePart).toList();
    List<int> currentV = current.split('.').map(parsePart).toList();

    for (var i = 0; i < latestV.length; i++) {
      if (i >= currentV.length) return true;
      if (latestV[i] > currentV[i]) return true;
      if (latestV[i] < currentV[i]) return false;
    }
    return false;
  }
}
