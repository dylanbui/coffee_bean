import 'dart:ui';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';

/// A custom SliverAppBar for Coffee Bean app with Parallax and Stretch effects.
///
/// Usage 1: Standard Parallax (Background stays when pinned)
/// ```dart
/// CoffeeSliverAppBar(
///   title: "Profile",
///   imageUrl: "https://example.com/bg.jpg",
/// )
/// ```
///
/// Usage 2: Advanced (Blur on stretch & Fade on scroll)
/// ```dart
/// CoffeeSliverAppBar(
///   title: "Details",
///   imageUrl: "https://example.com/bg.jpg",
///   stretch: true,
///   blurOnStretch: true, // Blur image when pulling down
///   fadeOnScroll: true,  // Image fades out when scrolling up
///   maxBlurSigma: 15.0,
/// )
/// ```
class CoffeeSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final String? imageUrl;
  final double expandedHeight;
  final CoffeeAppBarStyleConfig style;
  final VoidCallback? onBackTap;
  final double parallaxRate;
  final bool stretch;
  
  /// Whether the background image should fade out when scrolling up.
  final bool fadeOnScroll;
  
  /// Whether the background image should blur when stretching down.
  final bool blurOnStretch;
  final double maxBlurSigma;

  const CoffeeSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.imageUrl,
    this.expandedHeight = 250.0,
    this.style = const CoffeeAppBarStyleConfig(),
    this.onBackTap,
    this.parallaxRate = 0.3,
    this.stretch = true,
    this.fadeOnScroll = false,
    this.blurOnStretch = true,
    this.maxBlurSigma = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      stretch: stretch,
      elevation: style.elevation,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: leading ??
          IconButton(
            icon: Icon(style.backIcon ?? Icons.arrow_back_ios, size: 20),
            color: Colors.white,
            onPressed: onBackTap ?? () => Navigator.maybePop(context),
          ),
      actions: actions,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double appBarHeight = constraints.biggest.height;
          final double statusBarHeight = MediaQuery.paddingOf(context).top;
          final double currentExpandedHeight = expandedHeight + statusBarHeight;
          final double toolbarHeight = kToolbarHeight + statusBarHeight;
          
          // Tính toán độ cuộn
          final double scrollOffset = currentExpandedHeight - appBarHeight;
          
          // 1. Hiệu ứng Parallax
          final double parallaxOffset = scrollOffset > 0 ? -scrollOffset * parallaxRate : 0.0;

          // 2. Hiệu ứng Stretch (Scale & Blur)
          final double stretchRange = appBarHeight > currentExpandedHeight ? appBarHeight - currentExpandedHeight : 0.0;
          final double scale = appBarHeight > currentExpandedHeight 
              ? appBarHeight / currentExpandedHeight 
              : 1.0;
          
          // Tính toán độ nhòe (Blur) khi Stretch
          final double blurSigma = blurOnStretch ? (stretchRange / 50.0).clamp(0.0, maxBlurSigma) : 0.0;

          // 3. Hiệu ứng Fade Out khi cuộn lên
          double opacity = 1.0;
          if (fadeOnScroll && scrollOffset > 0) {
            // Mờ dần khi tiến gần đến toolbarHeight
            opacity = (1.0 - (scrollOffset / (currentExpandedHeight - toolbarHeight))).clamp(0.0, 1.0);
          }

          // Hiển thị title khi AppBar đã thu nhỏ
          final bool showTitle = appBarHeight < (toolbarHeight + 20);

          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              // Background Layer (Image + Blur + Opacity)
              Positioned(
                top: parallaxOffset,
                left: 0,
                right: 0,
                height: currentExpandedHeight * scale,
                child: Opacity(
                  opacity: opacity,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                    child: imageUrl != null 
                      ? DbCachedImageWidget(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          borderRadius: 0,
                        )
                      : Container(color: style.backgroundColor),
                  ),
                ),
              ),
              
              // Overlay
              Opacity(
                opacity: opacity,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.25),
                ),
              ),

              // Title Header
              if (showTitle)
                Positioned(
                  top: statusBarHeight,
                  left: style.leadingWidth ?? 56.0,
                  right: actions != null ? actions!.length * 48.0 : 16.0,
                  height: kToolbarHeight,
                  child: Center(
                    child: titleWidget ?? (title != null 
                      ? Text(
                          title!, 
                          style: style.titleTextStyle?.copyWith(color: Colors.white) ?? 
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
