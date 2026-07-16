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
import 'package:db_core/db_core.dart';

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

    // Sử dụng DbAssetPicker để xử lý toàn bộ logic: Quyền, Gallery, Camera, Localization
    final List<String> newPaths = await DbAssetPicker.pickMultipleImages(
      context,
      maxAssets: remainCount,
    );

    if (newPaths.isNotEmpty) {
      onImagesPicked(newPaths);
    }
  }

  Widget _buildImageItem(String path, int index) {
    Widget image;
    if (path.startsWith('http') || path.startsWith('https')) {
      image = DbCachedImageWidget(imageUrl: path, fit: BoxFit.cover);
    } else {
      image = Image.file(File(path), fit: BoxFit.cover);
    }

    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image,
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
