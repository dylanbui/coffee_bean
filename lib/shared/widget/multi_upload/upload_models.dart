import 'dart:io';
import 'package:flutter/foundation.dart';

enum UploadStatus { idle, uploading, success, error }

class UploadResult {
  final String url;
  final Map<String, dynamic>? extraData;
  UploadResult({required this.url, this.extraData});
}

abstract class IFileUploader {
  Future<UploadResult> upload({
    required File file,
    required Function(double progress) onProgress,
  });
}

class UploadItemTask {
  final String id;
  final File file;
  
  // ValueNotifier helps individual items to rebuild without affecting others
  final ValueNotifier<UploadStatus> status = ValueNotifier(UploadStatus.idle);
  final ValueNotifier<double> progress = ValueNotifier(0.0);
  String? remoteUrl;
  Map<String, dynamic>? extraData;
  String? errorMessage;

  UploadItemTask({required this.id, required this.file});

  void dispose() {
    status.dispose();
    progress.dispose();
  }
}

// A mock uploader for testing purposes
class MockFileUploader implements IFileUploader {
  @override
  Future<UploadResult> upload({required File file, required Function(double progress) onProgress}) async {
    // Simulate upload time
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      onProgress(i / 10);
    }
    
    return UploadResult(
      url: "https://mockserver.com/uploads/${file.path.split('/').last}",
      extraData: {"originalname": file.path.split('/').last, "filename": "mock_file.png"},
    );
  }
}
