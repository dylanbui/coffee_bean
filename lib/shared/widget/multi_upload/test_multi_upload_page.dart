import 'package:flutter/material.dart';
import 'package:db_core/db_core.dart';
import 'upload_models.dart';
import 'multi_upload_controller.dart';
import 'upload_item_widget.dart';
import 'platzi_file_uploader.dart';

class TestMultiUploadPage extends StatefulWidget {
  const TestMultiUploadPage({super.key});

  @override
  State<TestMultiUploadPage> createState() => _TestMultiUploadPageState();
}

class _TestMultiUploadPageState extends State<TestMultiUploadPage> {
  // Parallel limit set to 5 workers
  late final MultiUploadController _controller = MultiUploadController(
    uploader: PlatziFileUploader(),
    parallelLimit: 5,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Stress Test"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate),
            onPressed: () async {
              // Use DbAssetPicker from your project for image selection
              final List<String> paths = await DbAssetPicker.pickMultipleImages(
                context,
                maxAssets: 10,
              );
              if (paths.isNotEmpty) {
                _controller.addFiles(paths);
              }
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return Column(
            children: [
              // Statistics or Status bar
              if (_controller.tasks.isNotEmpty)
                _buildStatusBar(),
              
              // Grid View of items
              Expanded(
                child: _controller.tasks.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _controller.tasks.length,
                        itemBuilder: (context, index) {
                          final task = _controller.tasks[index];
                          return UploadItemWidget(
                            key: ValueKey(task.id),
                            task: task,
                            onRemove: () => _controller.removeTask(task),
                          );
                        },
                      ),
              ),
              
              // Bottom Action Button
              _buildActionButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusBar() {
    final int total = _controller.tasks.length;
    final int success = _controller.tasks.where((t) => t.status.value == UploadStatus.success).length;
    final int error = _controller.tasks.where((t) => t.status.value == UploadStatus.error).length;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.blue.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Total: $total", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("Success: $success", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          Text("Failed: $error", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_upload_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No images selected", style: TextStyle(color: Colors.grey)),
          const Text("Tap + to add up to 50 images", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _controller.isUploading ? Colors.orange : Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _controller.isUploading || _controller.tasks.isEmpty 
              ? null 
              : () => _controller.doUpload(),
          child: Text(
            _controller.isUploading ? "UPLOADING..." : "DO UPLOAD NOW",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
