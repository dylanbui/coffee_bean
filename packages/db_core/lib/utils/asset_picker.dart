import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';


class DbAssetPicker {
  final RequestType requestType; // image, video, hoặc all
  final int maxAssets;
  final bool enableCamera;
  final List<AssetEntity>? selectedAssets;
  final FutureOr<void> Function(List<AssetEntity> assets) onPicked;

  const DbAssetPicker({
    this.requestType = RequestType.image,
    this.maxAssets = 1,
    this.enableCamera = false,
    this.selectedAssets,
    required this.onPicked,
  });

  Future<void> showPickAssets(BuildContext context) async {
    try {
      // 1. Xin quyền cụ thể bằng PhotoManager thay vì dùng AssetPicker.permissionCheck()
      // Việc này giúp tránh xin quyền READ_MEDIA_AUDIO (thứ đang thiếu trong Manifest của bạn)
      final PermissionState ps = await PhotoManager.requestPermissionExtend(
        requestOption: const PermissionRequestOption(
          androidPermission: AndroidPermission(
            type: RequestType.image, // Tập trung vào image để khớp với Manifest
            mediaLocation: false,
          ),
        ),
      );

      if (ps == PermissionState.denied || ps == PermissionState.restricted) {
        if (context.mounted) _showPermissionDialog(context);
        return;
      }

      if (!context.mounted) return;

      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          requestType: requestType,
          maxAssets: maxAssets,
          selectedAssets: selectedAssets ?? [],
          textDelegate: const VietnameseAssetPickerTextDelegate(),
          specialItemPosition: enableCamera ? SpecialItemPosition.prepend : SpecialItemPosition.none,
          specialItemBuilder: enableCamera
              ? (BuildContext context, AssetPathEntity? path, int length) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                // 1. Kiểm tra quyền camera giống hệt logic bạn đã làm thành công
                var status = await Permission.camera.status;
                bool hasPermission = status.isGranted;
                if (!hasPermission) {
                  hasPermission = (await Permission.camera.request()).isGranted;
                }

                if (hasPermission) {
                  if (context.mounted) {
                    final AssetEntity? cameraResult = await CameraPicker.pickFromCamera(
                      context,
                      pickerConfig: const CameraPickerConfig(
                        textDelegate: VietnameseCameraPickerTextDelegate(),
                      ),
                    );
                    if (cameraResult != null && context.mounted) {
                      Navigator.of(context).pop([cameraResult]);
                    }
                  }
                } else {
                  if (context.mounted) _showPermissionDialog(context);
                }
              },
              child: const Center(
                child: Icon(Icons.camera_alt, size: 28, color: Colors.grey),
              ),
            );
          }
              : null,
        ),
      );

      if (result != null && result.isNotEmpty) {
        await onPicked(result);
      }
    } catch (e) {
      debugPrint("AssetPicker Error: $e");
      // Nếu vẫn gặp lỗi Denied (thường do mismatch giữa SDK và Manifest) 
      // thì hiện dialog hướng dẫn người dùng
      if (e.toString().contains("PermissionState.denied") && context.mounted) {
        _showPermissionDialog(context);
      }
    }
  }

  /// Helper static method to pick a single image and return a File.
  static Future<File?> pickSingleImage(
    BuildContext context, {
    bool enableCamera = true,
    bool crop = false,
  }) async {
    File? selectedFile;

    final picker = DbAssetPicker(
      maxAssets: 1,
      enableCamera: enableCamera,
      onPicked: (assets) async {
        if (assets.isNotEmpty) {
          selectedFile = await assets.first.file;
        }
      },
    );

    await picker.showPickAssets(context);

    if (selectedFile != null && crop) {
      if (!context.mounted) return selectedFile;
      selectedFile = await _cropImage(context, selectedFile!);
    }

    return selectedFile;
  }

  /// Helper static method to pick multiple images and return paths.
  static Future<List<String>> pickMultipleImages(
    BuildContext context, {
    int maxAssets = 9,
    List<AssetEntity>? selectedAssets,
  }) async {
    final List<String> paths = [];

    final picker = DbAssetPicker(
      maxAssets: maxAssets,
      selectedAssets: selectedAssets,
      enableCamera: true,
      onPicked: (assets) async {
        for (final asset in assets) {
          final file = await asset.file;
          if (file != null) {
            paths.add(file.path);
          }
        }
      },
    );

    await picker.showPickAssets(context);

    return paths;
  }

  static Future<File?> _cropImage(BuildContext context, File imageFile) async {
    if (!context.mounted) return imageFile;

    final Color primaryColor = Theme.of(context).primaryColor;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cắt ảnh',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
        ),
        IOSUiSettings(
          title: 'Cắt ảnh',
          cancelButtonTitle: 'Hủy',
          doneButtonTitle: 'Xong',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return imageFile;
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cần cấp quyền"),
        content: const Text("Vui lòng cấp quyền truy cập ảnh/video trong cài đặt để tiếp tục."),
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
}
