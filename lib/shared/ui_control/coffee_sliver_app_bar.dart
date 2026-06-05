import 'dart:ui';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';

/// A custom SliverAppBar for Coffee Bean app with Parallax and Stretch effects.
///
/// Usage 1: Standard Parallax (Background stays when pinned)
/// ```dart
/// Parallax + Stretch
// CoffeeSliverAppBar(
// title: "Profile",
// imageUrl: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&q=80&w=1000",
// mode: CoffeeAppBarMode.parallax,
// parallaxRate: 0.3,
// blurOnStretch: true,
// maxBlurSigma: 8.0,
// )
/// ```
///
/// Usage 2: Advanced (Blur on stretch & Fade on scroll)
/// FadeOnScroll + Stretch
/// ```dart
// CoffeeSliverAppBar(
// title: "Details",
// imageUrl: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&q=80&w=1000",
// mode: CoffeeAppBarMode.fadeOnScroll,
// blurOnStretch: true,
// maxBlurSigma: 10.0,
// )
/// ```
/// Usage 3: Advanced (Blur on stretch & Fade on scroll)
/// SolidOnScroll + Stretch
/// ```dart
// CoffeeSliverAppBar(
// mode: CoffeeAppBarMode.solidOnScroll,
// imageUrl: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&q=80&w=1000",
// solidBackgroundColor: Colors.blueGrey,
// collapsedWidget: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// const Text("My AppBar", style: TextStyle(color: Colors.white, fontSize: 16)),
// IconButton(
// icon: const Icon(Icons.search, color: Colors.white),
// onPressed: () {},
// ),
// ],
// ),
// )
/// ```

enum CoffeeAppBarMode {
  parallax,       // ảnh nền parallax + stretch
  fadeOnScroll,   // ảnh mờ dần và biến mất khi scroll lên
  solidOnScroll,  // khi collapse hiện AppBar nền màu + widget tùy ý
}

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

  final CoffeeAppBarMode mode;

  // Blur khi stretch
  final bool blurOnStretch;
  final double maxBlurSigma;

  // Solid mode
  final Color? solidBackgroundColor;
  final Widget? collapsedWidget;

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
    this.parallaxRate = 0.5,
    this.stretch = true,
    this.mode = CoffeeAppBarMode.parallax,
    this.blurOnStretch = true,
    this.maxBlurSigma = 8.0,
    this.solidBackgroundColor,
    this.collapsedWidget,
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

          final double scrollOffset = currentExpandedHeight - appBarHeight;
          final double parallaxOffset = scrollOffset > 0 ? -scrollOffset * parallaxRate : 0.0;

          // Stretch logic
          final double stretchRange = appBarHeight > currentExpandedHeight ? appBarHeight - currentExpandedHeight : 0.0;
          final double scale = appBarHeight > currentExpandedHeight
              ? appBarHeight / currentExpandedHeight
              : 1.0;
          final double blurSigma = blurOnStretch ? (stretchRange / 50.0).clamp(0.0, maxBlurSigma) : 0.0;

          // Fade logic
          double opacity = 1.0;
          if (mode == CoffeeAppBarMode.fadeOnScroll && scrollOffset > 0) {
            opacity = (1.0 - (scrollOffset / (currentExpandedHeight - toolbarHeight))).clamp(0.0, 1.0);
          }

          // Solid mode alpha (fade in nền màu + widget)
          double solidAlpha = 0.0;
          if (mode == CoffeeAppBarMode.solidOnScroll && scrollOffset > 0) {
            final double totalRange = currentExpandedHeight - toolbarHeight;
            // Bắt đầu fade trong khoảng 100 pixel cuối cùng trước khi collapse hoàn toàn để tạo hiệu ứng mượt mà
            const double fadeRange = 100.0;
            final double startAt = totalRange > fadeRange ? totalRange - fadeRange : 0.0;
            if (scrollOffset > startAt) {
              solidAlpha = ((scrollOffset - startAt) / (totalRange - startAt)).clamp(0.0, 1.0);
            }
          }

          final bool showTitle = appBarHeight < (toolbarHeight + 20);

          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              // Background luôn có stretch + parallax
              Positioned(
                top: parallaxOffset,
                left: 0,
                right: 0,
                height: currentExpandedHeight * scale,
                child: Opacity(
                  opacity: mode == CoffeeAppBarMode.fadeOnScroll ? opacity : 1.0,
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

              // Overlay cho parallax/fade
              if (mode != CoffeeAppBarMode.solidOnScroll)
                Opacity(
                  opacity: mode == CoffeeAppBarMode.fadeOnScroll ? opacity : 1.0,
                  child: Container(color: Colors.black.withValues(alpha: 0.25)),
                ),

              // Solid mode: AppBar nền màu + widget fade in
              if (mode == CoffeeAppBarMode.solidOnScroll)
                Opacity(
                  opacity: solidAlpha,
                  child: Container(
                    color: (solidBackgroundColor ?? style.backgroundColor),
                    child: SafeArea(
                      child: collapsedWidget ??
                          Center(
                            child: titleWidget ??
                                (title != null
                                    ? Text(
                                  title!,
                                  style: style.titleTextStyle ??
                                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                )
                                    : const SizedBox()),
                          ),
                    ),
                  ),
                ),

              // Title cho parallax mode
              if (showTitle && mode == CoffeeAppBarMode.parallax)
                Positioned(
                  top: statusBarHeight,
                  left: style.leadingWidth ?? 56.0,
                  right: actions != null ? actions!.length * 48.0 : 16.0,
                  height: kToolbarHeight,
                  child: Center(
                    child: titleWidget ??
                        (title != null
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
