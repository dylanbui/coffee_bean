import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';

/// A custom SliverAppBar for Coffee Bean app with Parallax and Stretch effects.
///
/// Usage:
/// ```dart
/// CustomScrollView(
///   physics: const BouncingScrollPhysics(),
///   slivers: [
///     CoffeeSliverAppBar(
///       title: "Exchange Points",
///       imageUrl: "https://example.com/image.jpg",
///       onBackTap: () => Navigator.pop(context),
///       actions: [IconButton(icon: Icon(Icons.share), onPressed: () {})],
///     ),
///     SliverList(...)
///   ],
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
          
          // Tính toán độ cuộn
          final double scrollOffset = currentExpandedHeight - appBarHeight;
          
          // 1. Hiệu ứng Parallax
          final double parallaxOffset = scrollOffset > 0 ? -scrollOffset * parallaxRate : 0.0;

          // 2. Hiệu ứng Stretch
          final double scale = appBarHeight > currentExpandedHeight 
              ? appBarHeight / currentExpandedHeight 
              : 1.0;

          // Hiển thị title khi AppBar đã thu nhỏ
          final bool showTitle = appBarHeight < (statusBarHeight + kToolbarHeight + 20);

          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              // 1. Background Image (Always visible as background)
              Positioned(
                top: parallaxOffset,
                left: 0,
                right: 0,
                height: currentExpandedHeight * scale,
                child: imageUrl != null 
                  ? DbCachedImageWidget(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      borderRadius: 0,
                    )
                  : Container(color: style.backgroundColor),
              ),
              
              // 2. Overlay
              Container(
                color: Colors.black.withValues(alpha: 0.25),
              ),

              // 3. Title (Manual implementation for persistence)
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
