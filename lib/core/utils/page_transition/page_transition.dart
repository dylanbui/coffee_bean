import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'enum.dart';

export 'enum.dart';

/// Page transition class
class PageTransition<T> extends PageRouteBuilder<T> {
  /// Child for transition
  final Widget child;

  /// Transition type
  final PageTransitionType type;

  /// Curve for transition
  final Curve curve;

  /// Alignment for transition
  final Alignment? alignment;

  /// Duration for transition
  final Duration duration;

  /// Reverse duration for transition
  final Duration reverseDuration;

  /// Context for theme
  final BuildContext? ctx;

  /// Inherit theme
  final bool inheritTheme;

  /// Matching builder for cupertino
  final PageTransitionsBuilder matchingBuilder;

  /// Is iOS swipe back enabled
  final bool isIos;

  /// Page transition constructor
  PageTransition({
    required this.child,
    required this.type,
    this.ctx,
    this.inheritTheme = false,
    this.curve = Curves.linear,
    this.alignment,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 300),
    this.isIos = false,
    this.matchingBuilder = const CupertinoPageTransitionsBuilder(),
    super.settings,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.opaque = true,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return inheritTheme && ctx != null
                ? InheritedTheme.captureAll(ctx, child)
                : child;
          },
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (isIos) {
      return matchingBuilder.buildTransitions(
        this,
        context,
        animation,
        secondaryAnimation,
        child,
      );
    }
    switch (type) {
      case PageTransitionType.fade:
        return FadeTransition(opacity: animation, child: child);

      case PageTransitionType.rightToLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case PageTransitionType.leftToRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case PageTransitionType.upToDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case PageTransitionType.downToUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case PageTransitionType.scale:
        return ScaleTransition(
          alignment: alignment ?? Alignment.center,
          scale: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );

      case PageTransitionType.rotate:
        return RotationTransition(
          alignment: alignment ?? Alignment.center,
          turns: animation,
          child: child,
        );

      case PageTransitionType.size:
        return Align(
          alignment: alignment ?? Alignment.center,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(parent: animation, curve: curve),
            child: child,
          ),
        );

      case PageTransitionType.rightToLeftWithFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case PageTransitionType.leftToRightWithFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case PageTransitionType.leftToRightJoined:
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            ),
          ],
        );

      case PageTransitionType.rightToLeftJoined:
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            ),
          ],
        );

      case PageTransitionType.topToBottomJoined:
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: const Offset(0.0, 0.0),
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            ),
          ],
        );

      case PageTransitionType.bottomToTopJoined:
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: const Offset(0.0, 0.0),
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            ),
          ],
        );

      case PageTransitionType.leftToRightPop:
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            ),
          ],
        );

      case PageTransitionType.rightToLeftPop:
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            ),
          ],
        );

      case PageTransitionType.topToBottomPop:
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: const Offset(0.0, 0.0),
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            ),
          ],
        );

      case PageTransitionType.bottomToTopPop:
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: const Offset(0.0, 0.0),
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            ),
          ],
        );
      case PageTransitionType.rotateSkew:
        return RotationTransition(
          alignment: alignment ?? Alignment.center,
          turns: animation,
          child: ScaleTransition(
            alignment: alignment ?? Alignment.center,
            scale: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );

      default:
        return FadeTransition(opacity: animation, child: child);
    }
  }
}
