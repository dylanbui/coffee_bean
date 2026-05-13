
import 'dart:async';

import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/commons_constants.dart';
import 'package:flutter/foundation.dart';

/// A base class for simple state management using ChangeNotifier, combined with RIBs-style routing.
///
/// Use this for pages with simple logic where a full BLoC/Cubit might be overkill.
/// It provides basic state flags like `isLoading`, `isProcessing`, and `error`.
///
/// ### State Management:
/// - `isLoading`: Typically for initial page loads.
/// - `isProcessing`: For actions like submitting a form.
/// - `error`: To hold and display error information.
///
/// Call `notifyListeners()` after changing state to update the UI.
///
/// ### Sample Code:
/// ```dart
/// class LoginProvider extends BaseProvider<LoginRouter> {
///   LoginProvider() : super(LoginRouter());
///
///   Future<void> login(String email, String password) async {
///     isProcessing = true; // Show loading indicator on button
///     error = null; // Clear previous errors
///
///     final success = await _authApi.login(email, password);
///
///     if (success) {
///       router.goToHomePage();
///     } else {
///       error = BaseError(message: "Invalid credentials");
///     }
///     isProcessing = false; // Hide loading indicator
///   }
/// }
/// ```
abstract class BaseProvider<R extends DbNoteRoutable> extends ChangeNotifier {

  late R router;
  bool _isDisposed = false;

  BaseError? _error;
  BaseError? get error => _error;
  set error(BaseError? value) {
    _error = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;
  set isProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  BaseProvider(this.router) {
    scheduleMicrotask(() {
      if (!_isDisposed) didBecomeActive();
    });
  }

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  void didBecomeActive() {}

  void willResignActive() {}

  @override
  void dispose() {
    _isDisposed = true;
    willResignActive();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_isDisposed) return;
    super.notifyListeners();
  }
}
