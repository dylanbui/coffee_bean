import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TapEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double onClickScale;
  final int throttleDuration; // milliseconds
  final bool enableHaptic;
  final bool enableSound;

  const TapEffect({
    super.key,
    required this.child,
    this.onTap,
    this.onClickScale = 0.95,
    this.throttleDuration = 500, // 0.5s execute immediately and block subsequent taps
    this.enableHaptic = true,
    this.enableSound = true,
  });

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
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
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

  void _handleTap() {
    if (widget.onTap == null) return;

    final now = DateTime.now();
    // Throttle Logic: Execute immediately if it's the first tap or enough time has passed
    if (_lastTapTime == null || now.difference(_lastTapTime!) > Duration(milliseconds: widget.throttleDuration)) {
      _lastTapTime = now;

      if (widget.enableHaptic) {
        HapticFeedback.lightImpact();
      }

      if (widget.enableSound) {
        Feedback.forTap(context);
      }

      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Animation triggers immediately on touch down
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) async {
        // Small delay to ensure the user sees the "lún" effect
        await Future.delayed(const Duration(milliseconds: 50));
        if (mounted) {
          _controller.reverse();
          _handleTap();
        }
      },
      onTapCancel: () => _controller.reverse(),
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
