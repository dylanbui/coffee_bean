import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

enum AppShareType {
  post(1, 'app-share-detail-post'),
  course(2, 'app-share-detail-course'),
  activity(3, 'app-share-detail-activity'),
  user(4, 'app-share-detail-user');

  final int value;
  final String path;

  const AppShareType(this.value, this.path);
}

class PosterHelper {
  static final GlobalKey boundaryKey = GlobalKey();

  static const String _baseUrl = "https://share.tmlabs.ai";

  /// Tạo link chia sẻ dựa trên type và id
  static String generateShareLink(AppShareType type, dynamic id) {
    return "$_baseUrl/${type.path}/$id";
  }

  /// Gửi tracking share về server (chạy ngầm)
  static Future<void> trackShare(AppShareType type, dynamic id, {String? channel}) async {
    try {
      final resourceId = int.tryParse(id.toString());
      if (resourceId == null) return;
      
      final hubRepo = locator.get<HubRepository>();
      await hubRepo.createShareRecord(
        resourceId, 
        shareType: type.value, 
        shareChannel: channel,
      );
    } catch (e) {
      debugPrint("PosterHelper trackShare error: $e");
    }
  }

  /// Chụp ảnh widget từ một GlobalKey
  static Future<Uint8List?> captureWidget(GlobalKey key) async {
    try {
      final RenderRepaintBoundary? boundary = 
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) return null;

      // pixelRatio 3.0 để đảm bảo ảnh sắc nét khi lưu
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("PosterHelper capture error: $e");
      return null;
    }
  }

  /// Lưu ảnh vào thư viện (Gallery)
  static Future<bool> saveToGallery(Uint8List bytes) async {
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) return false;
      }

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png').create();
      await file.writeAsBytes(bytes);

      await Gal.putImage(file.path);
      return true;
    } catch (e) {
      debugPrint("PosterHelper save error: $e");
      return false;
    }
  }

  /// Chia sẻ ảnh qua System Share Sheet
  static Future<void> shareImage(Uint8List bytes, {String? text}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/share_${DateTime.now().millisecondsSinceEpoch}.png').create();
      await file.writeAsBytes(bytes);

      final xFile = XFile(file.path);
      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[xFile],
          text: text,
        ),
      );
    } catch (e) {
      debugPrint("PosterHelper share error: $e");
    }
  }

  /// Chia sẻ ảnh từ URL (Download -> Compress -> Share)
  static Future<void> shareImageFromUrl(String imageUrl, {String? message}) async {
    try {
      // 1. Lấy ảnh từ Cache (hoặc download nếu chưa có)
      final File file = await DefaultCacheManager().getSingleFile(imageUrl);

      // 2. Tạo đường dẫn file tạm để chứa ảnh đã nén
      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/share_compress_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // 3. Nén ảnh (giảm chất lượng xuống 80% để nhẹ hơn nhưng vẫn rõ nét)
      final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80,
        format: CompressFormat.jpeg,
      );

      if (compressedFile != null) {
        // 4. Chia sẻ
        // Sử dụng SharePlus.instance.share() theo khuyến nghị mới của share_plus v10+
        await SharePlus.instance.share(
          ShareParams(
            files: <XFile>[compressedFile],
            text: message,
          ),
        );
      }
    } catch (e) {
      debugPrint("PosterHelper share from URL error: $e");
    }
  }
}
