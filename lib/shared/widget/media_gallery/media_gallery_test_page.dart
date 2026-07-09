import 'package:coffee_bean/shared/widget/image_slider_widget.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:flutter/material.dart';

class MediaGalleryTestPage extends StatelessWidget {
  const MediaGalleryTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> mediaUrls = [
      'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800', // Image
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', // Video
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800', // Image
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', // Video
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Gallery Test'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Image Slider with Video Support',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            context.imageSlider(
              images: mediaUrls,
              height: 250,
              borderRadius: 12,
              indicatorType: ImageSliderIndicatorType.all,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Hướng dẫn test:\n1. Vuốt slider để thấy sự khác biệt giữa Ảnh và Video.\n2. Tap vào một "Ảnh" để mở Media Gallery.\n3. Trong Media Gallery, vuốt để xem video phát trực tiếp.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
