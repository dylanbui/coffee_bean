import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ImagePickerListView extends StatelessWidget {
  final List<String> images;
  final int maxImages;
  final Function(String path) onImagePicked;
  final Function(int index) onRemoveImage;
  final ImagePicker _picker = ImagePicker();

  ImagePickerListView({
    super.key,
    required this.images,
    this.maxImages = 5,
    required this.onImagePicked,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + (images.length < maxImages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == images.length) {
            return _buildAddButton(context);
          }
          return _buildImageItem(images[index], index);
        },
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceActionSheet(context),
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add_photo_alternate_outlined, color: Colors.grey, size: 32),
      ),
    );
  }

  Future<void> _handlePickImage(BuildContext context, ImageSource source) async {
    // 1. Kiểm tra giới hạn (Double check)
    if (images.length >= maxImages) return;

    // 2. Xử lý xin quyền
    bool hasPermission = await _requestPermission(source);
    if (!hasPermission) {
      if (context.mounted) {
        _showPermissionDialog(context);
      }
      return;
    }

    // 3. Thực hiện chọn ảnh
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        onImagePicked(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi chọn ảnh: $e")),
        );
      }
    }
  }

  // Future<bool> _requestPermission(ImageSource source) async {
  //   if (source == ImageSource.camera) {
  //     if (await Permission.camera.isGranted) return true;
  //     return (await Permission.camera.request()).isGranted;
  //   } else {
  //     // ImageSource.gallery
  //     // 1. Trên iOS, NSPhotoLibraryUsageDescription đã khai báo trong Info.plist là đủ.
  //     // 2. Trên Android, image_picker sử dụng System Photo Picker (Android 11+)
  //     //    nên KHÔNG cần xin quyền READ_EXTERNAL_STORAGE hay photos nữa.
  //     //    Việc xin quyền ở đây khi không khai báo trong Manifest sẽ gây lỗi "luôn hỏi".
  //     return true;
  //   }
  // }

  Future<bool> _requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      var status = await Permission.camera.status;
      if (status.isGranted) return true;
      return (await Permission.camera.request()).isGranted;
    } else {
      // ImageSource.gallery
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;

        // Android 13 (API 33) trở lên
        if (androidInfo.version.sdkInt >= 33) {
          // Trả về true luôn để ImagePicker tự kích hoạt System Photo Picker
          // mà không cần xin quyền READ_MEDIA_IMAGES thủ công.
          return true;
        } else {
          // Android 12 trở xuống vẫn cần quyền storage
          var status = await Permission.storage.status;
          if (status.isGranted) return true;
          return (await Permission.storage.request()).isGranted;
        }
      }
      return true; // iOS xử lý qua Info.plist
    }
  }


  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cần cấp quyền"),
        content: const Text("Ứng dụng cần quyền truy cập để thực hiện chức năng này. Vui lòng cấp quyền trong cài đặt."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Cài đặt"),
          ),
        ],
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Từ thư viện'),
              onTap: () {
                Navigator.pop(context);
                _handlePickImage(context, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Chụp ảnh'),
              onTap: () {
                Navigator.pop(context);
                _handlePickImage(context, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(String path, int index) {
    if (path.isEmpty) return const SizedBox.shrink();
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(File(path), fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () => onRemoveImage(index),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
