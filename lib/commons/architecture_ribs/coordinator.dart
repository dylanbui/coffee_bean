import 'dart:async';

import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';


/// The [DbCoordinator] is a base class for managing navigation flows and their lifecycles.
/// It implements the Coordinator pattern to decouple routing logic from UI components,
/// ensuring the Single Responsibility Principle.
///
/// ### Key Features:
/// 1. **Lifecycle Management:** Wraps an entire multi-screen flow into a single [Future].
/// 2. **Auto-Cleanup:** Automatically pops all screens related to the flow when it finishes.
/// 3. **Reusability:** Coordinators can be called from anywhere without tying to specific UI contexts.
///
/// ### Usage Example:
/// ```dart
/// // 1. Define the Coordinator
/// class CheckoutCoordinator extends DbCoordinator<bool> {
///   @override
///   String get coordinatorName => 'CheckoutFlow';
///
///   @override
///   Future<bool?> start() {
///     // executeFlow automatically pushes the first screen and sets the routeName.
///     return executeFlow(const CartView());
///   }
///
///   void goToPayment() {
///     push(const PaymentView());
///   }
///
///   void completeCheckout() {
///     // Finishes the flow, returns true, and automatically pops all views in this flow.
///     finish(true);
///   }
/// }
/// ```
abstract class DbCoordinator<T> extends DbNoteBuilder with DbNavigator implements DbNoteRoutable {

  Completer<T?>? _completer;

  /// The unique identifier for this coordinator flow.
  /// This MUST be used as the `routeName` when pushing the FIRST screen of the flow.
  String get coordinatorName;

  /// Starts the flow.
  /// Subclasses must implement this to push the first screen.
  /// Return [executeFlow] to allow the caller to await the flow's completion.
  Future<T?> start();

  /// Helper method to initialize the flow's lifecycle future.
  /// Call this inside [start].
  /// Example: return executeFlow(MyFirstPage());
  Future<T?> executeFlow(
    Widget initialScreen, {
    BuildContext? fromContext,
    PageTransitionType transitionType = PageTransitionType.rightToLeft,
  }) {
    _completer = Completer<T?>();
    // Base class takes control of the first push and strictly enforces the coordinatorName
    push(initialScreen, fromContext: fromContext, routeName: coordinatorName, transitionType: transitionType);
    return _completer!.future;
  }

  /// Finishes the flow and returns the result to the caller.
  /// Automatically pops all screens related to this flow using [coordinatorName].
  /// Set [autoPop] to false if you want to keep the UI explicitly.
  void finish([T? result, bool autoPop = true]) {
    if (_completer != null && !_completer!.isCompleted) {
      if (autoPop) {
        // Automatically clear all screens in this flow before completing the future
        popUntilBefore(coordinatorName);
      }
      _completer!.complete(result);
    }
  }

  /// Cancels the flow gracefully and returns null.
  void cancel() {
    finish(null);
  }  

}