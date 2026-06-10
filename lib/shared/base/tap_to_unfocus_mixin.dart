import 'package:flutter/material.dart';

/// Mixin provides the ability to close the keyboard when tapping on empty areas.
/// Designed to be used with AppCubitState or any State class.
mixin TapToUnfocusMixin<T extends StatefulWidget> on State<T> {
  
  /// Override this to true in subclasses to enable the tap-to-unfocus behavior.
  bool get tapToUnfocus => false;

  /// Wraps the given [child] with a GestureDetector that handles unfocusing.
  /// This can be used to wrap the entire Scaffold or specific parts of the UI.
  Widget wrapTapToUnfocus(Widget child) {
    if (!tapToUnfocus) return child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
