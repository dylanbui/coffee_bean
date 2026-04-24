
import 'dart:async';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:flutter/cupertino.dart';

import 'package:coffee_bean/commons/commons_constants.dart';

abstract class MyBaseProvider with ChangeNotifier {

  // var _isStart = true;
  //
  // void isStart(bool start) {
  //   if (start == true) {
  //     _isStart = true;
  //     isLoading = true;
  //     _error = null;
  //   } else {
  //     _isStart = false;
  //   }
  //
  //   notifyListeners();
  // }

  final noInternetConnectionEvent = false;
  final connectTimeoutEvent = false;

  // Xu ly loi xay ra
  BaseError? _error;
  BaseError? get error => _error;
  set error(BaseError? err) {
    _error = err;
    notifyListeners();
  }

  // Cho bat dau load
  var _isLoading = true;
  bool isLoading(bool? loading) {
    if (loading != null) {
      _isLoading = loading;
      notifyListeners();
    }
    return _isLoading;
  }

  // Cho khi post, update du lieu
  var _isProcessedLoading = false;
  bool isProcessedLoading(bool? processed) {
    if (processed != null) {
      _isProcessedLoading = processed;
      notifyListeners();
    }
    return _isProcessedLoading;
  }


}


abstract class BaseProvider<R extends DbNoteRoutable> with ChangeNotifier {

  late R router;
  bool _isDisposed = false;

  BaseProvider(this.router) {
    scheduleMicrotask(() {
      if (!_isDisposed) didBecomeActive();
    });
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
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  var _isStart = true;

  void isStart(bool start) {
    if (start == true) {
      _isStart = true;
      isLoading = true;
      _error = null;
    } else {
      _isStart = false;
    }

    notifyListeners();
  }


  var isLoading = false;
  var errorMessage = "";
  BaseError? _error;

  final noInternetConnectionEvent = false;
  final connectTimeoutEvent = false;

  // void onLoadFail(Exception exception) {
  //   isLoading = false;
  //   showErrorWithString(exception.toString());
  //
  //   notifyListeners();
  // }

  void showErrorWithString(String message) {
    errorMessage = message;

    // notifyListeners();
  }

  void showError(BaseError error) {
    _error = error;

    // notifyListeners();
  }

  void showLoading() {
    isLoading = true;

    // notifyListeners();
  }

  void hideLoading() {
    isLoading = false;

    // notifyListeners();
  }
}
