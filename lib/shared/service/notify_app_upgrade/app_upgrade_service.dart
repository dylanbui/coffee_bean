import 'dart:io';
import 'package:db_core/db_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Sự kiện yêu cầu kiểm tra cập nhật từ UI
class CheckAppUpgradeRequestEvent extends DbBaseEvent {}

class AppUpgradeService {
  static const String _latestVersionKey = "latest_app_version";

  /// Cấu hình Remote Config ban đầu.
  /// Nên được gọi 1 lần khi khởi tạo App.
  static Future<void> setupRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: Duration.zero , // Mặc định 1h, Real-time sẽ bypass cái này
      ));
      // Khởi tạo giá trị mặc định nếu cần
      // await remoteConfig.setDefaults({_latestVersionKey: "1.0.0"});
    } catch (e) {
      debugPrint("UpgradeService: Setup Remote Config failed: $e");
    }
  }

  /// Kiểm tra xem có cần update không.
  /// force = true: Sẽ thực hiện fetch mới từ server (không dùng cache).
  /// force = false: Ưu tiên lấy từ cấu hình đã active (bao gồm cả dữ liệu từ Real-time listener).
  static Future<String?> checkUpdate({bool force = false}) async {
    final prefs = DbSharedPreferences();
    
    // Lấy version hiện tại của app
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    debugPrint("UpgradeService: --- CHECK UPDATE ---");
    debugPrint("UpgradeService: Current App Version: $currentVersion");
    
    String? latestVersion;
    final remoteConfig = FirebaseRemoteConfig.instance;

    if (force) {
      debugPrint("UpgradeService: Force fetching from server...");
      latestVersion = await _fetchFromFirebase(force: true);
    } else {
      // Thử lấy từ giá trị đang active trước
      latestVersion = remoteConfig.getString(_latestVersionKey);
      if (latestVersion.isEmpty) {
        debugPrint("UpgradeService: No active version found, fetching...");
        latestVersion = await _fetchFromFirebase(force: false);
      } else {
        debugPrint("UpgradeService: Using active version: $latestVersion");
      }
    }
    
    if (latestVersion != null && latestVersion.isNotEmpty) {
      await prefs.set(_latestVersionKey, latestVersion);
    } else {
      // Nếu lỗi mạng/không fetch được, lấy giá trị cũ từ cache local để so sánh (nếu có)
      latestVersion = prefs.get(_latestVersionKey) as String?;
      debugPrint("UpgradeService: Using local cached version: $latestVersion");
    }

    if (latestVersion != null && _isVersionGreaterThan(latestVersion, currentVersion)) {
      debugPrint("UpgradeService: Update required! $latestVersion > $currentVersion");
      return latestVersion;
    }

    debugPrint("UpgradeService: No update required.");
    return null;
  }

  static Future<void> openStore() async {
    final appId = Platform.isAndroid ? "com.tmlabs.coffee" : "123456789";
    final url = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=$appId"
        : "https://apps.apple.com/app/id$appId";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  static Future<String?> _fetchFromFirebase({required bool force}) async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      // Real-time Remote Config sẽ tự động bypass minimumFetchInterval khi có thay đổi từ server.
      // fetchAndActivate sẽ lấy dữ liệu mới nhất (nếu force hoặc hết hạn cache).
      await remoteConfig.fetchAndActivate();

      final version = remoteConfig.getString(_latestVersionKey);
      debugPrint("UpgradeService: Version from Firebase: $version");
      
      return version.isNotEmpty ? version : null;
    } catch (e) {
      debugPrint("UpgradeService: Error fetching Firebase: $e");
      return null;
    }
  }

  static bool _isVersionGreaterThan(String latest, String current) {
    if (latest == current) return false;

    int parsePart(String part) {
      final numericMatch = RegExp(r'\d+').firstMatch(part);
      return numericMatch != null ? int.parse(numericMatch.group(0)!) : 0;
    }

    List<int> latestV = latest.split('.').map(parsePart).toList();
    List<int> currentV = current.split('.').map(parsePart).toList();

    int maxLength = latestV.length > currentV.length ? latestV.length : currentV.length;
    
    for (var i = 0; i < maxLength; i++) {
      int v1 = i < latestV.length ? latestV[i] : 0;
      int v2 = i < currentV.length ? currentV[i] : 0;
      
      if (v1 > v2) return true;
      if (v1 < v2) return false;
    }

    return false;
  }
}
