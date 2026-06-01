import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Configuration class for [CoffeeAppBar] styling.
/// Groups visual properties to maintain a clean constructor in the widget.
class CoffeeAppBarStyleConfig {
  /// Background color of the AppBar.
  final Color backgroundColor;

  /// Default color for icons and text if not explicitly styled.
  final Color foregroundColor;

  /// Shadow depth of the AppBar.
  final double elevation;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// Custom text style for the title.
  final TextStyle? titleTextStyle;

  /// Custom height for the toolbar part of the AppBar.
  final double? toolbarHeight;

  /// Custom width for the leading widget.
  final double? leadingWidth;

  /// Custom icon for the back button.
  final IconData? backIcon;

  const CoffeeAppBarStyleConfig({
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.elevation = 0,
    this.centerTitle = true,
    this.titleTextStyle,
    this.toolbarHeight,
    this.leadingWidth,
    this.backIcon = Icons.arrow_back_ios_new,
  });

  CoffeeAppBarStyleConfig copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    bool? centerTitle,
    TextStyle? titleTextStyle,
    double? toolbarHeight,
    double? leadingWidth,
    IconData? backIcon,
  }) {
    return CoffeeAppBarStyleConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      elevation: elevation ?? this.elevation,
      centerTitle: centerTitle ?? this.centerTitle,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      toolbarHeight: toolbarHeight ?? this.toolbarHeight,
      leadingWidth: leadingWidth ?? this.leadingWidth,
      backIcon: backIcon ?? this.backIcon,
    );
  }
}

/// A custom AppBar widget designed for the Coffee Bean app.
/// It supports styled configurations, transparent backgrounds, and custom leading/trailing widgets.
class CoffeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The text to display in the app bar's title.
  final String? title;

  /// A widget to display instead of the [title] text.
  final Widget? titleWidget;

  /// A list of widgets to display in a row after the [title].
  final List<Widget>? actions;

  /// A widget to display before the [title]. Usually an [IconButton] or [BackButtons].
  final Widget? leading;

  /// Whether to hide the default back button.
  final bool hideBackButton;

  /// A widget that appears across the bottom of the app bar.
  /// Typically a [TabBar] or a search bar.
  final PreferredSizeWidget? bottom;

  /// Overrides the default system UI overlay style (status bar icons/color).
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// The visual configuration for the app bar.
  final CoffeeAppBarStyleConfig style;

  /// Custom callback when the default back button is pressed.
  final VoidCallback? onBackTap;

  const CoffeeAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.hideBackButton = false,
    this.bottom,
    this.systemOverlayStyle,
    this.style = const CoffeeAppBarStyleConfig(),
    this.onBackTap,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight((style.toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final isTransparent = style.backgroundColor == Colors.transparent;

    return AppBar(
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style:
                      style.titleTextStyle ??
                      TextStyle(color: style.foregroundColor, fontWeight: FontWeight.bold, fontSize: 18),
                )
              : null),
      centerTitle: style.centerTitle,
      backgroundColor: style.backgroundColor,
      elevation: style.elevation,
      leadingWidth: style.leadingWidth,
      leading: hideBackButton
          ? (leading != null ? leading : null)
          : (leading ??
                IconButton(
                  icon: Icon(style.backIcon, size: 20),
                  color: style.foregroundColor,
                  onPressed: onBackTap ?? () => Navigator.maybePop(context),
                )),
      automaticallyImplyLeading: !hideBackButton,
      actions: actions,
      bottom: bottom,
      systemOverlayStyle:
          systemOverlayStyle ??
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: (style.backgroundColor == Colors.white || isTransparent)
                ? Brightness.dark
                : Brightness.light,
            statusBarBrightness: (style.backgroundColor == Colors.white || isTransparent)
                ? Brightness.light
                : Brightness.dark,
          ),
    );
  }
}
