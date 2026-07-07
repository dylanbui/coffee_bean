import 'dart:io';
import 'package:dio/dio.dart';
import 'package:coffee_bean/shared/widget/multi_upload/upload_models.dart';

class PlatziFileUploader implements IFileUploader {
  final Dio _dio = Dio();

  @override
  Future<UploadResult> upload({
    required File file,
    required Function(double progress) onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path, 
          filename: file.path.split('/').last
        ),
      });

      final response = await _dio.post(
        'https://api.escuelajs.co/api/v1/files/upload',
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) onProgress(sent / total);
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return UploadResult(
          url: data['location'] ?? '',
          extraData: data,
        );
      } else {
        throw Exception('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
