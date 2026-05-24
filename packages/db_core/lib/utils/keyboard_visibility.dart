/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 10:17
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';

/*
Usage:
DbKeyboardVisibility(
  onChanged: (info) {
    print('visible: ${info.isVisible}');
    print('height: ${info.height}');
  },
  child: YourScreen(),
);
*/

class DbKeyboardInfo {
    final bool isVisible;
    final double height;

    const DbKeyboardInfo({
        required this.isVisible,
        required this.height,
    });
}

class DbKeyboardVisibility extends StatefulWidget {
    final Widget child;
    final ValueChanged<DbKeyboardInfo> onChanged;

    const DbKeyboardVisibility({
        super.key,
        required this.child,
        required this.onChanged,
    });

    @override
    State<DbKeyboardVisibility> createState() => _DbKeyboardVisibilityState();
}

class _DbKeyboardVisibilityState extends State<DbKeyboardVisibility>
    with WidgetsBindingObserver {
    DbKeyboardInfo _last = const DbKeyboardInfo(isVisible: false, height: 0);

    @override
    void initState() {
        super.initState();
        WidgetsBinding.instance.addObserver(this);
    }

    @override
    void dispose() {
        WidgetsBinding.instance.removeObserver(this);
        super.dispose();
    }

    @override
    void didChangeMetrics() {
        final view = View.of(context);
        final bottom = view.viewInsets.bottom;

        // Android keyboard: ~250–350 px
        // iOS keyboard: ~300+ px
        // Navigation bar: ~20–50 px
        // final isKeyboard = bottom > 100;
        // Kiem soat man hinh tablet
        final screenHeight = MediaQuery.of(context).size.height;
        final isKeyboard = bottom > screenHeight * 0.1;

        final newState = DbKeyboardInfo(
            isVisible: isKeyboard,
            height: isKeyboard ? bottom : 0,
        );

        if (newState.isVisible != _last.isVisible ||
            newState.height != _last.height) {
            _last = newState;
            widget.onChanged(newState);
        }
    }

    @override
    Widget build(BuildContext context) {
        return widget.child;
    }
}