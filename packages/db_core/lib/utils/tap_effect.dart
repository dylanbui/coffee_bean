import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TapEffectType { scale, ripple, none }

class TapEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double onClickScale;
  final int throttleDuration; // milliseconds
  final bool enableHaptic;
  final bool enableSound;
  final TapEffectType effectType;
  final BorderRadiusGeometry? borderRadius;
  final Duration scaleDuration;

  const TapEffect({
    super.key,
    required this.child,
    this.onTap,
    this.onClickScale = 0.95,
    this.throttleDuration = 500,
    this.enableHaptic = true,
    this.enableSound = true,
    this.effectType = TapEffectType.scale,
    this.borderRadius,
    this.scaleDuration = const Duration(milliseconds: 100),
  });

  // splashColor: Colors.black.withValues(alpha: 0.08),
  // highlightColor: Colors.black.withValues(alpha: 0.05),

  @override
  State<TapEffect> createState() => _TapEffectState();
}

class _TapEffectState extends State<TapEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.scaleDuration,
      reverseDuration: widget.scaleDuration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.onClickScale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performFeedback() {
    if (widget.enableHaptic) HapticFeedback.lightImpact();
    if (widget.enableSound) Feedback.forTap(context);
  }

  void _handleTap() {
    if (widget.onTap == null) return;
    final now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > Duration(milliseconds: widget.throttleDuration)) {
      _lastTapTime = now;
      _performFeedback();
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? _getBorderRadiusFromChild();

    if (widget.effectType == TapEffectType.ripple) {
      // Chuyển đổi BorderRadiusGeometry sang BorderRadius nếu có thể để InkWell hoạt động chính xác
      final resolvedBorderRadius = borderRadius is BorderRadius
          ? borderRadius
          : (borderRadius is BorderRadiusDirectional
              ? BorderRadius.only(
                  topLeft: borderRadius.topStart,
                  topRight: borderRadius.topEnd,
                  bottomLeft: borderRadius.bottomStart,
                  bottomRight: borderRadius.bottomEnd,
                )
              : null);

      return RepaintBoundary(
        child: Stack(
          children: [
            widget.child,
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: resolvedBorderRadius,
                  onTap: _handleTap,
                  splashColor: Colors.black.withValues(alpha: 0.08),
                  highlightColor: Colors.black.withValues(alpha: 0.05),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget result = widget.child;
    if (widget.effectType == TapEffectType.scale) {
      result = ScaleTransition(
        scale: _scaleAnimation,
        // RepaintBoundary giúp tách biệt phần render của child khi scale, giảm tải cho GPU
        child: RepaintBoundary(child: widget.child),
      );
    }

    return GestureDetector(
      onTapDown: (_) {
        if (widget.effectType == TapEffectType.scale) _controller.forward();
      },
      onTapUp: (_) async {
        if (widget.effectType == TapEffectType.scale) {
          await Future.delayed(const Duration(milliseconds: 50));
          if (mounted) {
            _controller.reverse();
            _handleTap();
          }
        } else {
          _handleTap();
        }
      },
      onTapCancel: () {
        if (widget.effectType == TapEffectType.scale) _controller.reverse();
      },
      behavior: HitTestBehavior.opaque,
      child: result,
    );
  }

  BorderRadiusGeometry? _getBorderRadiusFromChild() {
    final child = widget.child;
    if (child is ClipRRect) return child.borderRadius;
    if (child is Container) {
      final decoration = child.decoration;
      if (decoration is BoxDecoration) return decoration.borderRadius;
    }
    if (child is Card) {
      final shape = child.shape;
      if (shape is RoundedRectangleBorder) return shape.borderRadius;
    }
    if (child is Material) return child.borderRadius;
    return null;
  }
}
