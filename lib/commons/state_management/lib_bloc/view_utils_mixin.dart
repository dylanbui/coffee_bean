import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/utils/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Mixin chứa các hàm tiện ích dùng chung cho các Base View (Bloc, Cubit, Stateful, Stateless)
mixin ViewUtilsMixin {
  
  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    var snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.yellowAccent,
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Hiển thị loading sử dụng DbLoading (Flash)
  /// Nếu không truyền context, sẽ sử dụng navigator context mặc định
  void showLoading({String? text}) {
    final effectiveContext = DbNavigator.navigatorState.currentContext;
    if (effectiveContext != null) {
      DbLoading.show(effectiveContext, message: text);
    }
  }

  void hideLoading() {
    DbLoading.dismiss();
  }

  void showProgressLoading({String? text = "Đang xử lý ..."}) {
    SmartDialog.showLoading(msg: text ?? "Đang xử lý ...");
  }

  void hideProgressLoading() {
    SmartDialog.dismiss();
  }
}
