import 'package:flutter/material.dart';
import 'package:coffee_bean/utils/app_assets.dart';
import 'package:coffee_bean/widget/checkbox_custom.dart';
// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:coffee_bean/widget/loading_view.dart';

class WidgetUtils {
  static CheckboxFilter checkboxFilterAll({bool isSelected = false}) {
    return CheckboxFilter(
      value: isSelected,
      assetName: AppAssets.images.filterCheckAll,
      selectedAssetName: AppAssets.images.filterCheckAllSelected,
    );
  }

  static CheckboxFilter checkboxFilter({bool isSelected = false}) {
    return CheckboxFilter(
      value: isSelected,
    );
  }

  static Future<void> showMyDialog({
    required BuildContext context,
    String? title,
    required String message,
    String? textActionCancel,
    Function? actionCancel,
    String? textActionOk,
    Function? actionOk,
  }) async {
    List<Widget> listAction = <Widget>[];
    if (actionOk != null && textActionOk != null) {
      listAction.add(TextButton(
        child: Text(textActionCancel ?? "Cancel"),
        onPressed: () {
          actionCancel?.call();
          Navigator.of(context, rootNavigator: true).pop();
        },
      ));

      listAction.add(TextButton(
        child: Text(textActionOk.toString()),
        onPressed: () {
          actionOk.call();
          Navigator.of(context, rootNavigator: true).pop();
        },
      ));
    } else {
      listAction.add(TextButton(
        child: Text(textActionCancel ?? "Ok"),
        onPressed: () {
          actionCancel?.call();
          Navigator.of(context, rootNavigator: true).pop();
        },
      ));
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title.toString()) : null,
          content: Text(message),
          actions: listAction,
        );
      },
    );
  }

  static void showLoading() {
    // SmartDialog.show(
    //   backType: SmartBackType.normal,
    //   clickMaskDismiss: false,
    //   builder: (context) {
    //     return LoadingView(
    //       width: 200,
    //       height: 200,
    //     );
    //   },
    // );
  }

  static void hideLoading() {
    // SmartDialog.dismiss();
  }




}
