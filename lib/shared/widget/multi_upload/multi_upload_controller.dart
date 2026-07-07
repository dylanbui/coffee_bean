import 'dart:collection';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'upload_models.dart';

class MultiUploadController extends ChangeNotifier {
  final IFileUploader uploader;
  final int parallelLimit;
  
  final List<UploadItemTask> _tasks = [];
  final Queue<UploadItemTask> _waitingQueue = Queue();
  
  int _activeWorkers = 0;

  MultiUploadController({required this.uploader, this.parallelLimit = 5});

  List<UploadItemTask> get tasks => _tasks;
  bool get isUploading => _activeWorkers > 0;

  void addFiles(List<String> paths) {
    for (var path in paths) {
      final task = UploadItemTask(
        id: DateTime.now().microsecondsSinceEpoch.toString() + path,
        file: File(path),
      );
      _tasks.add(task);
      _waitingQueue.add(task);
    }
    notifyListeners();
    
    // Auto-start workers if we are already in an uploading state
    if (isUploading) {
      _startWorkersIfNeeded();
    }
  }

  void removeTask(UploadItemTask task) {
    task.dispose();
    _tasks.remove(task);
    _waitingQueue.remove(task); // Remove from queue if it hasn't started
    notifyListeners();
  }

  Future<void> doUpload() async {
    // Add all idle or error tasks to queue if not already there
    for (var task in _tasks) {
      if ((task.status.value == UploadStatus.idle || task.status.value == UploadStatus.error) &&
          !_waitingQueue.contains(task)) {
        _waitingQueue.add(task);
      }
    }
    _startWorkersIfNeeded();
  }

  void _startWorkersIfNeeded() {
    while (_activeWorkers < parallelLimit && _waitingQueue.isNotEmpty) {
      _activeWorkers++;
      _runWorker();
    }
    notifyListeners();
  }

  Future<void> _runWorker() async {
    while (_waitingQueue.isNotEmpty) {
      final task = _waitingQueue.removeFirst();
      await _processTask(task);
    }
    _activeWorkers--;
    notifyListeners();
  }

  Future<void> _processTask(UploadItemTask task) async {
    task.status.value = UploadStatus.uploading;
    task.progress.value = 0.0;
    task.errorMessage = null;

    try {
      final result = await uploader.upload(
        file: task.file,
        onProgress: (p) => task.progress.value = p,
      );
      task.remoteUrl = result.url;
      task.extraData = result.extraData;
      task.status.value = UploadStatus.success;

      // LOGCAT OUTPUT
      debugPrint('✅ [MultiUpload] SUCCESS:');
      debugPrint('   - File: ${task.file.path.split('/').last}');
      debugPrint('   - Link: ${result.url}');
      if (result.extraData != null) debugPrint('   - Metadata: ${result.extraData}');

    } catch (e) {
      task.errorMessage = e.toString();
      task.status.value = UploadStatus.error;
      debugPrint('❌ [MultiUpload] FAILED: ${task.file.path.split('/').last}');
      debugPrint('   - Error: $e');
    }
  }

  @override
  void dispose() {
    for (var task in _tasks) {
      task.dispose();
    }
    super.dispose();
  }
}
