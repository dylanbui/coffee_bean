import 'package:flutter/material.dart';

enum FadeSwitcherType { fade, slide, scale, rotate }

enum SlideDirection { left, right, up, down }

class FadeSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Object? stateKey;
  final FadeSwitcherType type;
  final SlideDirection slideDirection;
  final double? slideDistance; // null = toàn màn hình

  const FadeSwitcher({
    super.key,
    required this.child,
    this.stateKey,
    this.duration = const Duration(milliseconds: 400),
    this.type = FadeSwitcherType.fade,
    this.slideDirection = SlideDirection.right,
    this.slideDistance,
  });

  /// Binary constructor để chuyển giữa 2 widget
  factory FadeSwitcher.binary({
    Key? key,
    required bool showFirst,
    required Widget first,
    required Widget second,
    Duration duration = const Duration(milliseconds: 400),
    FadeSwitcherType type = FadeSwitcherType.fade,
    SlideDirection slideDirection = SlideDirection.right,
    double? slideDistance,
  }) {
    return FadeSwitcher(
      key: key,
      duration: duration,
      type: type,
      slideDirection: slideDirection,
      slideDistance: slideDistance,
      stateKey: showFirst ? 'fade_first' : 'fade_second',
      child: showFirst ? first : second,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveKey = ValueKey(stateKey ?? '${child.runtimeType}_${child.hashCode}');

    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        switch (type) {
          case FadeSwitcherType.fade:
            return FadeTransition(opacity: animation, child: child);
          case FadeSwitcherType.slide:
            final offset = _getOffset(slideDirection, context);
            return SlideTransition(
              position: Tween<Offset>(begin: offset, end: Offset.zero).animate(animation),
              child: child,
            );
          case FadeSwitcherType.scale:
            return ScaleTransition(scale: animation, child: child);
          case FadeSwitcherType.rotate:
            return RotationTransition(turns: animation, child: child);
        }
      },
      child: KeyedSubtree(key: effectiveKey, child: child),
    );
  }

  Offset _getOffset(SlideDirection direction, BuildContext context) {
    if (slideDistance == null) {
      // dịch toàn màn hình
      switch (direction) {
        case SlideDirection.left:
          return const Offset(-1.0, 0.0);
        case SlideDirection.right:
          return const Offset(1.0, 0.0);
        case SlideDirection.up:
          return const Offset(0.0, -1.0);
        case SlideDirection.down:
          return const Offset(0.0, 1.0);
      }
    } else {
      final screenSize = MediaQuery.of(context).size;
      // dịch theo pixel
      switch (direction) {
        case SlideDirection.left:
          return Offset(-slideDistance! / screenSize.width, 0);
        case SlideDirection.right:
          return Offset(slideDistance! / screenSize.width, 0);
        case SlideDirection.up:
          return Offset(0, -slideDistance! / screenSize.height);
        case SlideDirection.down:
          return Offset(0, slideDistance! / screenSize.height);
      }
    }
  }
}
