import 'package:flutter/material.dart';
import 'package:coffee_bean/shared/widget/multi_upload/upload_models.dart';

class UploadItemWidget extends StatelessWidget {
  final UploadItemTask task;
  final VoidCallback onRemove;

  const UploadItemWidget({
    super.key,
    required this.task,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Thumbnail Image
          Image.file(task.file, fit: BoxFit.cover),

          // 2. Status Overlay
          ValueListenableBuilder<UploadStatus>(
            valueListenable: task.status,
            builder: (context, status, _) {
              if (status == UploadStatus.idle) return const SizedBox.shrink();

              return Container(
                color: Colors.black45,
                child: Center(
                  child: _buildStatusIndicator(status),
                ),
              );
            },
          ),

          // 3. Remove Button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          // 4. Error Message (Optional simple indicator)
          ValueListenableBuilder<UploadStatus>(
            valueListenable: task.status,
            builder: (context, status, _) {
              if (status == UploadStatus.error && task.errorMessage != null) {
                return Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    color: Colors.red.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: const Text(
                      'Failed',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(UploadStatus status) {
    switch (status) {
      case UploadStatus.uploading:
        return ValueListenableBuilder<double>(
          valueListenable: task.progress,
          builder: (context, progress, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            );
          },
        );
      case UploadStatus.success:
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 32,
        );
      case UploadStatus.error:
        return const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 32,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
