import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:flutter/material.dart';

/// Extension for [CubitState] to provide easy access to Coffee Bean styled AppBars.
extension CoffeeAppBarX on CubitState {
  
  /// Build a standard Coffee Bean AppBar with the given [title].
  /// Default style is [TmLabAppBarStyle.transparentStyle].
  PreferredSizeWidget coffeeAppBar(String title, {
    CoffeeAppBarStyleConfig? style,
    List<Widget>? actions,
    Widget? leading,
    VoidCallback? onBackTap,
  }) {
    return CoffeeAppBar(
      title: title,
      style: style ?? TmLabAppBarStyle.transparentStyle,
      actions: actions ?? getAppBarAction(),
      leading: leading,
      onBackTap: onBackTap,
    );
  }

  /// Build a Navy styled Coffee Bean AppBar.
  PreferredSizeWidget navyCoffeeAppBar(String title, {List<Widget>? actions}) {
    return coffeeAppBar(title, style: TmLabAppBarStyle.navyStyle, actions: actions);
  }

  /// Build a White styled Coffee Bean AppBar.
  PreferredSizeWidget whiteCoffeeAppBar(String title, {List<Widget>? actions}) {
    return coffeeAppBar(title, style: TmLabAppBarStyle.whiteStyle, actions: actions);
  }
}
