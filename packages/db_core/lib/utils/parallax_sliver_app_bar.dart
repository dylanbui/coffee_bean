import 'dart:ui';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';

/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Description: A custom SliverAppBar with Parallax and Stretch effects.
 * 
 * Usage 1: Parallax mode with Multiple Images
 * ```dart
 * ParallaxSliverAppBar(
 *   title: "Profile",
 *   imageUrls: ["https://example.com/bg1.jpg", "https://example.com/bg2.jpg"],
 *   mode: ParallaxAppBarMode.parallax,
 * )
 * ```
 * 
 * Usage 2: Solid background on collapse
 * ```dart
 * ParallaxSliverAppBar(
 *   title: "Settings",
 *   imageUrl: "assets/images/bg.png",
 *   mode: ParallaxAppBarMode.solidOnScroll,
 *   solidBackgroundColor: Colors.blue,
 * )
 * ```
 */

enum ParallaxAppBarMode {
  parallax,       // Background with parallax + stretch
  fadeOnScroll,   // Background fades out as you scroll up
  solidOnScroll,  // Shows a solid color background when collapsed
}

class ParallaxSliverAppBarStyleConfig {
  final Color backgroundColor;
  final double elevation;
  final TextStyle? titleTextStyle;
  final double? leadingWidth;
  final IconData? backIcon;

  const ParallaxSliverAppBarStyleConfig({
    this.backgroundColor = Colors.black,
    this.elevation = 0,
    this.titleTextStyle,
    this.leadingWidth,
    this.backIcon = Icons.arrow_back_ios,
  });
}

class ParallaxSliverAppBar extends StatefulWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final List<String>? imageUrls;
  final String? imageUrl;
  final double expandedHeight;
  final ParallaxSliverAppBarStyleConfig style;
  final VoidCallback? onBackTap;
  final double parallaxRate;
  final bool stretch;
  final ParallaxAppBarMode mode;

  // Blur on stretch
  final bool blurOnStretch;
  final double maxBlurSigma;

  // Solid mode
  final Color? solidBackgroundColor;
  final Widget? collapsedWidget;

  const ParallaxSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.imageUrls,
    this.imageUrl,
    this.expandedHeight = 250.0,
    this.style = const ParallaxSliverAppBarStyleConfig(),
    this.onBackTap,
    this.parallaxRate = 0.5,
    this.stretch = true,
    this.mode = ParallaxAppBarMode.parallax,
    this.blurOnStretch = true,
    this.maxBlurSigma = 8.0,
    this.solidBackgroundColor,
    this.collapsedWidget,
  });

  @override
  State<ParallaxSliverAppBar> createState() => _ParallaxSliverAppBarState();
}

class _ParallaxSliverAppBarState extends State<ParallaxSliverAppBar> {
  late PageController _pageController;
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
    // Combine image sources
    final List<String> allImages = [
      if (widget.imageUrl != null) widget.imageUrl!,
      if (widget.imageUrls != null) ...widget.imageUrls!,
    ];

    return SliverAppBar(
      expandedHeight: widget.expandedHeight,
      pinned: true,
      stretch: widget.stretch,
      elevation: widget.style.elevation,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leadingWidth: widget.style.leadingWidth,
      leading: widget.leading ??
          IconButton(
            icon: Icon(widget.style.backIcon ?? Icons.arrow_back_ios, size: 20),
            color: Colors.white,
            onPressed: widget.onBackTap ?? () => Navigator.maybePop(context),
          ),
      actions: widget.actions,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double appBarHeight = constraints.biggest.height;
          final double statusBarHeight = MediaQuery.paddingOf(context).top;
          final double currentExpandedHeight = widget.expandedHeight + statusBarHeight;
          final double toolbarHeight = kToolbarHeight + statusBarHeight;

          final double scrollOffset = (currentExpandedHeight - appBarHeight).clamp(0.0, currentExpandedHeight);
          final double parallaxOffset = scrollOffset > 0 ? -scrollOffset * widget.parallaxRate : 0.0;

          // Stretch logic
          final double scale = appBarHeight > currentExpandedHeight ? appBarHeight / currentExpandedHeight : 1.0;
          final double stretchRange = appBarHeight > currentExpandedHeight ? appBarHeight - currentExpandedHeight : 0.0;
          final double blurSigma = widget.blurOnStretch ? (stretchRange / 50.0).clamp(0.0, widget.maxBlurSigma) : 0.0;

          // Fade logic (for fadeOnScroll mode)
          double backgroundOpacity = 1.0;
          if (widget.mode == ParallaxAppBarMode.fadeOnScroll) {
            backgroundOpacity = (1.0 - (scrollOffset / (currentExpandedHeight - toolbarHeight))).clamp(0.0, 1.0);
          }

          // Solid mode alpha (for solidOnScroll mode)
          double solidAlpha = 0.0;
          if (widget.mode == ParallaxAppBarMode.solidOnScroll) {
            final double totalRange = currentExpandedHeight - toolbarHeight;
            const double fadeRange = 100.0;
            final double startAt = totalRange > fadeRange ? totalRange - fadeRange : 0.0;
            if (scrollOffset > startAt) {
              solidAlpha = ((scrollOffset - startAt) / (totalRange - startAt)).clamp(0.0, 1.0);
            }
          }

          // Opacity for dots and secondary UI elements
          final double uiOpacity = (1.0 - (scrollOffset / (currentExpandedHeight - toolbarHeight - 40))).clamp(0.0, 1.0);
          final bool showTitle = appBarHeight < (toolbarHeight + 20);

          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              // 1. Background Slider
              Positioned(
                top: parallaxOffset,
                left: 0,
                right: 0,
                height: currentExpandedHeight * scale,
                child: Opacity(
                  opacity: backgroundOpacity,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                    child: allImages.isNotEmpty
                        ? PageView.builder(
                      controller: _pageController,
                      itemCount: allImages.length,
                      onPageChanged: (index) => setState(() => _currentPage = index),
                      itemBuilder: (context, index) {
                        final String path = allImages[index];
                        final bool isNetwork = path.startsWith('http');

                        if (isNetwork) {
                          return DbCachedImageWidget(
                            imageUrl: path,
                            fit: BoxFit.cover,
                            borderRadius: 0,
                          );
                        }

                        return Image.asset(
                          path,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                        : Container(color: widget.style.backgroundColor),
                  ),
                ),
              ),

              // 2. Dark Overlay
              if (widget.mode != ParallaxAppBarMode.solidOnScroll)
                IgnorePointer(
                  child: Opacity(
                    opacity: backgroundOpacity,
                    child: Container(color: Colors.black.withValues(alpha: 0.25)),
                  ),
                ),

              // 3. Dot Indicators
              if (allImages.length > 1 && uiOpacity > 0)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: uiOpacity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(allImages.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: _currentPage == index ? 0.9 : 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

              // 4. Solid mode layer
              if (widget.mode == ParallaxAppBarMode.solidOnScroll)
                Opacity(
                  opacity: solidAlpha,
                  child: Container(
                    color: (widget.solidBackgroundColor ?? widget.style.backgroundColor),
                    child: SafeArea(
                      child: widget.collapsedWidget ??
                          Container(
                            padding: EdgeInsets.only(
                              left: widget.style.leadingWidth ?? 56.0,
                              right: widget.actions != null ? widget.actions!.length * 48.0 : 16.0,
                            ),
                            alignment: Alignment.centerLeft,
                            child: widget.titleWidget ??
                                (widget.title != null
                                    ? Text(
                                  widget.title!,
                                  style: widget.style.titleTextStyle ??
                                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                )
                                    : const SizedBox()),
                          ),
                    ),
                  ),
                ),

              // 5. Title for parallax mode
              if (showTitle && widget.mode == ParallaxAppBarMode.parallax)
                Positioned(
                  top: statusBarHeight,
                  left: widget.style.leadingWidth ?? 56.0,
                  right: widget.actions != null ? widget.actions!.length * 48.0 : 16.0,
                  height: kToolbarHeight,
                  child: Center(
                    child: widget.titleWidget ??
                        (widget.title != null
                            ? Text(
                          widget.title!,
                          style: widget.style.titleTextStyle?.copyWith(color: Colors.white) ??
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        )
                            : const SizedBox()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
