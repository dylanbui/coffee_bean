/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 15/08/2022 - 11:02
 */

import 'package:flutter/material.dart';

/// ViewController: A type alias representing the UI component (Widget) of a RIB.
typedef ViewController = Widget;

/// DbNoteViewer: An interface representing the abstract view of a module.
///
/// It can contain methods for the Router or Interactor to invoke directly on the View,
/// such as `showLoading` or `showError`.
abstract interface class DbNoteViewer {}

/// ViewControllable: A mixin that adapts a Flutter Widget to the [DbNoteViewer] interface.
///
/// It provides a standardized way for a [Router] to access the Widget instance.
///
/// ### Usage:
/// ```dart
/// class MyPage extends StatelessWidget with ViewControllable {
///   @override
///   Widget build(BuildContext context) => Container();
/// }
/// ```
mixin ViewControllable on Widget implements DbNoteViewer {
  /// Returns the Widget instance itself.
  ViewController get viewController => this;
}
