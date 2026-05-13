import 'package:coffee_bean/core/architecture_ribs/navigator.dart';
import 'package:coffee_bean/core/utils/loading_dialog.dart';
import 'package:coffee_bean/core/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Mixin chứa các hàm tiện ích dùng chung cho các Base View (Bloc, Cubit, Stateful, Stateless)
mixin ViewUtilsMixin {
  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void showToast(String message) {
    DbToast.show(message, gravity: DbToastGravity.bottom, duration: const Duration(seconds: 2));
  }

  void showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    var snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.black87)),
      backgroundColor: Colors.yellowAccent,
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Hiển thị loading sử dụng DbLoading (Flash)
  /// Nếu không truyền context, sẽ sử dụng navigator context mặc định
  void showLoading({String text = "Loading ..."}) {
    final effectiveContext = DbNavigator.navigatorState.currentContext;
    if (effectiveContext != null) {
      DbLoading.show(effectiveContext, message: text);
    }
  }

  void hideLoading() {
    DbLoading.dismiss();
  }

  void showPageLoading({String text = "Loading ..."}) {
    final effectiveContext = DbNavigator.navigatorState.currentContext;
    if (effectiveContext != null) {
      DbPageLoading.show(context: effectiveContext);
    }
  }

  void hidePageLoading() {
    DbPageLoading.dismiss();
  }

  void showProgressLoading({String? text = "Đang xử lý ..."}) {
    final effectiveContext = DbNavigator.navigatorState.currentContext;
    if (effectiveContext != null) {
      DbLoading.show(effectiveContext, message: text);
    }
  }

  void hideProgressLoading() {
    DbLoading.dismiss();
  }
}
