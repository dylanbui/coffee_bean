
import 'package:flutter/material.dart';

// Tim hieu thang nay, kien truc chung co the dung dc
// https://pub.dev/packages/dialog_loader

class LoadingIndicatorDialog {

  // region Make Singleton Class
  static final LoadingIndicatorDialog _singleton = LoadingIndicatorDialog._internal();
  factory LoadingIndicatorDialog() {
    return _singleton;
  }

  LoadingIndicatorDialog._internal();
  // endregion

  late BuildContext _context;
  bool isDisplayed = false;

  show(BuildContext context, {String text = 'Loading...'}) {
    if(isDisplayed) {
      return;
    }
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          isDisplayed = true;
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              backgroundColor: Colors.white,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(text),
                      )
                    ],
                  ),
                )
              ] ,
            ),
          );
        }
    );
  }

  dismiss() {
    if(isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}