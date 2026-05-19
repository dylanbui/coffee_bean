/*
 * Created with IntelliJ IDEA
 * Package: commons.architecture_ribs
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 11:10
 */

import 'package:coffee_bean/core/architecture_ribs/navigator.dart';
import 'package:coffee_bean/core/architecture_ribs/note_interactor.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:flutter/material.dart';

/// DbNoteRoute: Base interface for route identifiers used in inter-module navigation.
abstract interface class DbNoteRoute {}

/// DbNoteRoutable: Interface defining the standard routing operations for a RIB.
abstract interface class DbNoteRoutable {
  /// Called when the router becomes active.
  void didBecomeActiveRouter();

  /// Called when the router is about to become inactive.
  void willResignActiveRouter();

  /// Standard pop operation.
  void pop();

  /// Standard push operation.
  void push();

  /// Performs complex navigation logic based on a specific [toRoute].
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters});
}

/// DbNoteRouter: Base class for managing the navigation and RIB tree hierarchy.
///
/// It holds references to the Interactor and View, and uses a [DbNavigator] to perform
/// actual UI transitions.
///
/// ### Usage:
/// ```dart
/// class MyRouter extends DbNoteRouter {
///   void pushNext() {
///     final nextBuilder = NextBuilder();
///     final nextRouter = nextBuilder.build();
///     nextRouter.parentRouter = this;
///     navigator.push(nextRouter.viewController);
///   }
/// }
/// ```
abstract class DbNoteRouter implements DbNoteRoutable {
  /// Parent router in the RIB tree hierarchy.
  DbNoteRouter? parentRouter;

  /// Helper for performing navigation transitions.
  late DbNavigator navigator;
  
  GlobalKey<NavigatorState>? navigatorState;

  DbNoteRouter({this.parentRouter, this.navigatorState}) {
    navigator = DbNavigator(navigatorState ??= DbNavigator.globalNavigatorState);
  }

  DbNoteInteractor? _interactor;
  ViewController? _viewController;

  /// Connects the interactor and the view to this router.
  void attach(DbNoteInteractor interactor, ViewController view) {
    if (_interactor != null || _viewController != null) {
      throw StateError("Router is already attached");
    }
    _interactor = interactor;
    _viewController = view;
  }

  /// Connects an interactor to a headless router (no view).
  void attachInteractor(DbNoteInteractor interactor) {
    if (_interactor != null) {
      throw StateError("Interactor is already attached");
    }
    _interactor = interactor;
  }

  /// Returns the associated Interactor instance.
  DbNoteInteractor get interactor {
    if (_interactor == null) throw StateError("Interactor is not attached");
    return _interactor!;
  }

  /// Returns the associated View (Widget) instance.
  ViewController get viewController {
    if (_viewController == null) throw StateError("View is not attached");
    return _viewController!;
  }

  @override
  void willResignActiveRouter() {}

  @override
  void didBecomeActiveRouter() {}

  @override
  void pop() {
    navigator.pop();
  }

  @override
  void push() {}

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Default implementation (no-op)
  }

  void displayRouterName() {
    // For debugging purposes
  }
}
