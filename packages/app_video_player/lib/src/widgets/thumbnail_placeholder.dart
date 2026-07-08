import 'package:flutter/material.dart';

class ThumbnailPlaceholder extends StatelessWidget {
  final String? thumbnailUrl;
  final VoidCallback onPlayTap;

  const ThumbnailPlaceholder({
    super.key,
    this.thumbnailUrl,
    required this.onPlayTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlayTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Hiển thị hình nền nếu có
          if (thumbnailUrl != null) _buildImage(thumbnailUrl!) else const SizedBox.shrink(),

          // 2. Lớp phủ mờ (Scrim)
          Container(color: Colors.black.withOpacity(0.3)),

          // 3. Icon Play lớn ở trung tâm
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 64,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return Image.network(path, fit: BoxFit.cover);
    }
    return Image.asset(path, fit: BoxFit.cover);
  }
}
