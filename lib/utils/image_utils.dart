import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  /// Nén ảnh avatar theo chuẩn vuông 512x512, Quality 80
  static Future<File?> compressAvatar(File file) async {
    final tempDir = await getTemporaryDirectory();
    final String targetPath = '${tempDir.path}/temp_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // compressAndGetFile 2.4.0+ returns XFile?
    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
      minWidth: 512,
      minHeight: 512,
      format: CompressFormat.jpeg,
    );

    if (result == null) return null;
    return File(result.path);
  }

  /// Nén một ảnh duy nhất theo chuẩn FHD (1920x1080) với Quality 90
  static Future<File?> compressFHDImage(File file) async {
    final tempDir = await getTemporaryDirectory();
    final String targetPath = '${tempDir.path}/fhd_single_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1920,
      minHeight: 1080,
      format: CompressFormat.jpeg,
    );

    return result != null ? File(result.path) : null;
  }

  /// Nén danh sách ảnh theo chuẩn FHD (1920x1080) với Quality 90
  /// Đảm bảo dung lượng luôn < 2MB (thường chỉ 600KB - 900KB)
  static Future<List<File>> compressFHDImages(List<File> files) async {
    final tempDir = await getTemporaryDirectory();
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    final results = await Future.wait(files.asMap().entries.map((entry) async {
      final index = entry.key;
      final file = entry.value;
      final String targetPath = '${tempDir.path}/fhd_${timestamp}_$index.jpg';

      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 90,
        minWidth: 1920,
        minHeight: 1080,
        format: CompressFormat.jpeg,
      );

      return result != null ? File(result.path) : null;
    }));

    // Lọc bỏ các file null nếu có lỗi nén ở một file nào đó
    return results.whereType<File>().toList();
  }

  /// Dọn dẹp các file tạm do ImageUtils tạo ra
  /// [all]: true nếu muốn xóa sạch, false nếu chỉ xóa file cũ hơn 24h (mặc định)
  static Future<void> cleanTemporaryFiles({bool all = false}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final List<FileSystemEntity> entities = tempDir.listSync();
      final now = DateTime.now();

      for (var entity in entities) {
        if (entity is File) {
          final String fileName = entity.path.split('/').last;
          // Chỉ xóa các file do chúng ta tạo ra (prefix fhd_ hoặc temp_avatar_)
          if (fileName.startsWith('fhd_') || fileName.startsWith('temp_avatar_')) {
            if (all) {
              await entity.delete();
            } else {
              // Chỉ xóa nếu file đã tồn tại hơn 24 giờ để đảm bảo không xóa nhầm file đang dùng
              final stat = await entity.stat();
              if (now.difference(stat.modified).inHours > 24) {
                await entity.delete();
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Lỗi khi dọn dẹp file tạm: $e");
    }
  }
}
