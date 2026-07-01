import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class AutoModuleAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final localePath = '$path/${locale.languageCode}/'; // Đảm bảo có dấu gạch chéo cuối
    
    // 1. Sử dụng AssetManifest API chính thức của Flutter
    final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    
    // 2. Lấy danh sách các asset và lọc theo đường dẫn ngôn ngữ
    final jsonFiles = manifest.listAssets()
        .where((key) => key.startsWith(localePath) && key.endsWith('.json'))
        .toList();

    Map<String, dynamic> mergedMap = {};

    // 3. Load và gộp tất cả JSON
    for (var filePath in jsonFiles) {
      final String content = await rootBundle.loadString(filePath);
      final Map<String, dynamic> data = json.decode(content);
      mergedMap.addAll(data);
    }

    return mergedMap;
  }
}
