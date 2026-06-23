import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
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
}
