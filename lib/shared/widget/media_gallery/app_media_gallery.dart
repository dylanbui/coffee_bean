import 'package:app_video_player/app_video_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class AppMediaGallery extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;
  final String? heroTagPrefix;

  const AppMediaGallery({
    super.key,
    required this.urls,
    this.initialIndex = 0,
    this.heroTagPrefix,
  });

  /// Utility to show the gallery
  static void show(BuildContext context,
      {required List<String> urls, int initialIndex = 0, String? heroTagPrefix}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AppMediaGallery(urls: urls, initialIndex: initialIndex, heroTagPrefix: heroTagPrefix),
      ),
    );
  }

  @override
  State<AppMediaGallery> createState() => _AppMediaGalleryState();
}

class _AppMediaGalleryState extends State<AppMediaGallery> {
  late ExtendedPageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = ExtendedPageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isVideo(String url) {
    final path = url.split('?').first.toLowerCase();
    return path.endsWith('.mp4') || path.endsWith('.mov') || path.endsWith('.m4v') || path.endsWith('.m3u8');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Gallery Content
          ExtendedImageGesturePageView.builder(
            controller: _pageController,
            itemCount: widget.urls.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final url = widget.urls[index];
              if (_isVideo(url)) {
                return _VideoGalleryItem(url: url);
              }
              return _ImageGalleryItem(
                url: url,
                index: index,
                heroTagPrefix: widget.heroTagPrefix,
              );
            },
          ),

          // 2. Header: Close Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 3. Footer: Indicator
          if (widget.urls.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.black54, borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    "${_currentIndex + 1} / ${widget.urls.length}",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ImageGalleryItem extends StatelessWidget {
  final String url;
  final int index;
  final String? heroTagPrefix;

  const _ImageGalleryItem({required this.url, required this.index, this.heroTagPrefix});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      fit: BoxFit.contain,
      mode: ExtendedImageMode.gesture,
      heroBuilderForSlidingPage: heroTagPrefix != null
          ? (Widget image) => Hero(tag: '${heroTagPrefix}_$index', child: image)
          : null,
      initGestureConfigHandler: (state) => GestureConfig(
        minScale: 0.9,
        maxScale: 3.0,
        inPageView: true,
      ),
    );
  }
}

class _VideoGalleryItem extends StatelessWidget {
  final String url;
  const _VideoGalleryItem({required this.url});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppVideoPlayer(
        url: url,
        enableSeekOverlay: true,
      ),
    );
  }
}
