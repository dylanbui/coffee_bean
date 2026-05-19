import 'package:flutter/material.dart';

class FadeSwitcher extends StatelessWidget {
  final bool showFirst;
  final Widget first;
  final Widget second;
  final Duration duration;

  const FadeSwitcher({
    super.key,
    required this.showFirst,
    required this.first,
    required this.second,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: showFirst
          ? KeyedSubtree(key: const ValueKey('fade_first'), child: first)
          : KeyedSubtree(key: const ValueKey('fade_second'), child: second),
    );
  }
}
