import 'package:db_core/architecture_ribs/note_viewer.dart';
import 'package:flutter/material.dart';

/// DbNoteNavOptions: An interface defining configuration options for navigation transitions.
/// 
/// Implementations of this interface can hold metadata such as route names, 
/// transition types, or specific BuildContexts required for the navigation to execute.
abstract interface class DbNoteNavOptions {
  /// The identifier for the route being pushed. 
  /// Essential for stack manipulation like 'popUntil'.
  String? get routeName;

  /// An optional BuildContext to perform navigation from a specific point in the widget tree.
  BuildContext? get fromContext;
}

/// DbNoteNavigatable: An interface defining the contract for navigation operations.
/// 
/// This abstraction allows Routers to perform UI transitions without being 
/// tightly coupled to a specific navigation framework or the Flutter Navigator API directly.
abstract interface class DbNoteNavigatable {
  /// Pushes a new [viewController] onto the navigation stack.
  /// [options] can be provided to customize the transition or name the route.
  void push(ViewController viewController, {covariant DbNoteNavOptions? options});

  /// Replaces the current top-most route with a new [viewController].
  void pushReplacement(ViewController viewController, {covariant DbNoteNavOptions? options});

  /// Clears the entire navigation stack and sets the [viewController] as the new root.
  void pushSameRootPage(ViewController viewController, {covariant DbNoteNavOptions? options});

  /// Returns true if the navigator can currently pop a route off the stack.
  bool canPop({covariant DbNoteNavOptions? options});

  /// Pops the top-most route off the navigation stack.
  void pop({covariant DbNoteNavOptions? options});

  /// Pops all routes until the route immediately BEFORE the [targetRouteName].
  /// 
  /// This is specifically used to clean up entire business flows, returning to 
  /// the screen that existed before the flow started.
  void popUntilBefore(String targetRouteName, {covariant DbNoteNavOptions? options});
}
