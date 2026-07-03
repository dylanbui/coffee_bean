import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

enum ImageSliderIndicatorType { dots, fraction, all, none }

/// A reusable image slider widget that supports dots and fraction indicators.
/// It uses DbCachedImageWidget internally for optimized loading and caching.
class ImageSliderWidget extends StatefulWidget {
  final List<String> images;
  final double height;
  final ImageSliderIndicatorType indicatorType;
  final BoxFit fit;
  final double borderRadius;
  final Color? backgroundColor;
  final ValueChanged<int>? onPageChanged;

  const ImageSliderWidget({
    super.key,
    required this.images,
    this.height = 300,
    this.indicatorType = ImageSliderIndicatorType.fraction,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.backgroundColor,
    this.onPageChanged,
  });

  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        width: double.infinity,
        color: widget.backgroundColor ?? Colors.transparent,
        child: DbCachedImageWidget(
          imageUrl: null,
          width: double.infinity,
          height: widget.height,
          fit: widget.fit,
          borderRadius: widget.borderRadius,
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              widget.onPageChanged?.call(index);
            },
            itemBuilder: (context, index) {
              return DbCachedImageWidget(
                imageUrl: widget.images[index],
                width: double.infinity,
                height: widget.height,
                fit: widget.fit,
                borderRadius: widget.borderRadius,
              );
            },
          ),
          if (widget.images.length > 1) _buildIndicator(),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    final type = widget.indicatorType;
    if (type == ImageSliderIndicatorType.none) return const SizedBox.shrink();

    return Stack(
      children: [
        if (type == ImageSliderIndicatorType.dots || type == ImageSliderIndicatorType.all)
          _buildDotsIndicator(),
        if (type == ImageSliderIndicatorType.fraction || type == ImageSliderIndicatorType.all)
          _buildFractionIndicator(),
      ],
    );
  }

  Widget _buildDotsIndicator() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.images.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _currentPage == index ? 24 : 8,
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white.withValues(alpha: _currentPage == index ? 1.0 : 0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFractionIndicator() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "${_currentPage + 1}/${widget.images.length}",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
