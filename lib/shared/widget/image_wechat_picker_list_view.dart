/*
Usage:
ImageWechatPickerListView(
  images: state.images,
  maxImages: 5,
  onImagesPicked: (paths) {
    interactor.onImagesPicked(paths);
  },
  onRemoveImage: (index) {
    interactor.removeImage(index);
  },
)
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ImageWechatPickerListView extends StatelessWidget {
  final List<String> images;
  final int maxImages;
  final Function(List<String> paths) onImagesPicked;
  final Function(int index) onRemoveImage;

  const ImageWechatPickerListView({
    super.key,
    required this.images,
    this.maxImages = 5,
    required this.onImagesPicked,
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
      onTap: () => _handlePickAssets(context),
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

  Future<void> _handlePickAssets(BuildContext context) async {
    final int remainCount = maxImages - images.length;
    if (remainCount <= 0) return;

    // 1. Kiểm tra quyền trước khi mở Picker
    bool hasPermission = await _requestGalleryPermission();
    if (!hasPermission) {
      if (context.mounted) _showPermissionDialog(context);
      return;
    }

    // 2. Mở WeChat Asset Picker
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: remainCount,
        requestType: RequestType.image,
        specialItemPosition: SpecialItemPosition.prepend,
        specialItemBuilder: (
          BuildContext context,
          AssetPathEntity? path,
          int length,
        ) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              // Kiểm tra quyền camera khi nhấn vào icon camera
              if (await Permission.camera.request().isGranted) {
                if (context.mounted) {
                  final AssetEntity? result = await CameraPicker.pickFromCamera(context);
                  if (result != null) {
                    Navigator.of(context).pop([result]);
                  }
                }
              }
            },
            child: const Center(
              child: Icon(Icons.camera_alt, size: 28, color: Colors.grey),
            ),
          );
        },
      ),
    );

    if (result != null && result.isNotEmpty) {
      final List<String> paths = [];
      for (final AssetEntity entity in result) {
        final File? file = await entity.file;
        if (file != null) {
          paths.add(file.path);
        }
      }
      onImagesPicked(paths);
    }
  }

  Future<bool> _requestGalleryPermission() async {
    if (Platform.isIOS) return true;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        if (await Permission.photos.isGranted || await Permission.photos.isLimited) return true;
        return (await Permission.photos.request()).isGranted;
      } else {
        if (await Permission.storage.isGranted) return true;
        return (await Permission.storage.request()).isGranted;
      }
    }
    return true;
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cần cấp quyền"),
        content: const Text("Vui lòng cấp quyền truy cập ảnh trong cài đặt để tiếp tục."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
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

  // Note: To handle camera click in the specialItemBuilder, 
  // you usually need a custom delegate or handle it in the itemBuilder of the picker.
  // The simple way to have a camera button that actually works inside the picker 
  // is using the built-in CameraPicker integration if supported or custom delegate.
  // For simplicity here, we'll use the standard pickAssets. 
  // If you want the camera button INSIDE to work, we need more advanced config.

  Widget _buildImageItem(String path, int index) {
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
