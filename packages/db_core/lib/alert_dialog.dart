/*
 * Created with IntelliJ IDEA
 * Package: commons
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 29/06/2022 - 17:10
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AppAlert {

  // region Make Singleton Class
  static final AppAlert _singleton = AppAlert._internal();
  factory AppAlert() {
    return _singleton;
  }

  late AlertStyle alertStyle;

  Widget _fadeAlertAnimation(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }


  AppAlert._internal() {
    // Reusable alert style
    alertStyle = const AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: true,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        //First to chars "55" represents transparency of color
        overlayColor: Color(0x55000000),
        alertElevation: 0,
        alertAlignment: Alignment.center);
  }
  // endregion

  void show(BuildContext context, String desc, {String? title, VoidCallback? btnOkAction, VoidCallback? btnCancelAction, AlertType? type}) {

    List<DialogButton>? buttons = [];
    if(btnOkAction != null) {
      buttons.add(_makeOk(btnOkAction: btnOkAction));
    }
    if(btnCancelAction != null) {
      buttons.add(_makeCancel(btnCancelAction: btnCancelAction));
    }

    Alert(
      context: context,
      type: type,
      title: title,
      desc: desc,
      buttons: buttons,
      style: alertStyle,
      alertAnimation: _fadeAlertAnimation,
    ).show();
  }

  void showWarning(BuildContext context, String desc, {VoidCallback? btnOkAction}) {
    show(context, desc, btnOkAction: btnOkAction, type: AlertType.warning);
  }

  void showError(BuildContext context, String desc, {VoidCallback? btnCancelAction}) {
    show(context, desc, btnCancelAction: btnCancelAction, type: AlertType.error);
  }

  void showSuccess(BuildContext context, String desc, {VoidCallback? btnOkAction}) {
    show(context, desc, btnOkAction: btnOkAction, type: AlertType.success);
  }

  void showInfo(BuildContext context, String desc, {VoidCallback? btnOkAction, VoidCallback? btnCancelAction }) {
    show(context, desc, btnOkAction: btnOkAction, btnCancelAction: btnCancelAction, type: AlertType.info);
  }

  DialogButton _makeOk({String? title, VoidCallback? btnOkAction}) {
    return DialogButton(
      child: Text(
        title ?? "OK",
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: btnOkAction,
      color: const Color.fromRGBO(0, 179, 134, 1.0),
      radius: BorderRadius.circular(5.0),
    );
  }

  DialogButton _makeCancel({String? title, VoidCallback? btnCancelAction}) {
    return DialogButton(
      child: Text(
        title ?? "Bỏ qua",
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: btnCancelAction,
      color: Colors.black26,
      radius: BorderRadius.circular(5.0),
    );
  }


}