
import 'package:db_core/custom_app_bar.dart';
import 'package:db_core/state_management/lib_bloc/view_utils_mixin.dart';
import 'package:db_core/state_management/lib_provider/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// https://github.com/FlorinMihalache/flutter_progress_hud

/// A base StatefulWidget for pages using the Provider pattern for state management.
///
/// ### Usage:
/// - Extend this class for pages that need a lifecycle (`initState`, `dispose`).
/// - Use `pageProvider` to call business logic methods.
/// - Use `Consumer<P>` or `context.watch<P>()` inside `getBody` to rebuild specific UI parts
///   when the provider's state changes.
///
/// ### Sample Code:
/// ```dart
/// class _MyPageState extends BaseProviderState<MyPage, MyProvider> {
///   @override
///   Widget getBody(BuildContext context) {
///     // Use Consumer to only rebuild the Text widget on changes
///     return Consumer<MyProvider>(
///       builder: (context, provider, child) => Text('Count: ${provider.count}'),
///     );
///   }
/// }
/// ```

//ignore: must_be_immutable
abstract class BaseProviderStateFulWidget extends StatefulWidget {

  bool showAppBar = true;
  BaseProviderStateFulWidget({super.key});

}

abstract class BaseProviderState<B extends BaseProviderStateFulWidget, P extends BaseProvider> extends State<B> with ViewUtilsMixin {

  /// should be overridden in extended widget
  Widget? getLayout(BuildContext context) => null;

  // void startBuild(BuildContext context) { }
  dynamic getAppBar(BuildContext context) => "";
  Widget getBody(BuildContext context) => const Text("implement getBody() function");
  List<Widget> getAppBarAction() => [];

  /// The Provider instance for this page.
  /// Use this to call methods (e.g., `pageProvider.fetchData()`).
  /// It's initialized in `build` using `context.read<P>()` for performance.
  late P pageProvider;

  @override
  void initState() {
    super.initState();
    // It's better to initialize context-dependent objects here if needed,
    // but DialogLoader is now handled by ViewUtilsMixin with SmartDialog.
  }

  @override
  Widget build(BuildContext context) {
    // CRITICAL FIX: Use `context.read<P>()` instead of `Provider.of<P>(context)`.
    // `read` gets the provider instance WITHOUT listening for changes.
    // This prevents the entire Scaffold from rebuilding on every `notifyListeners()`.
    // UI updates should be handled by `Consumer` or `context.watch` inside `getBody`.
    pageProvider = context.read<P>();

    // Muon control thang nao thi phai dung context thang do
    var layout = getLayout(context);
    if (layout != null) {
      return layout;
    }

    var appBar = getAppBar(context);
    if (appBar is String) {
      // tao 1 custom use for common theme
      appBar = CustomAppBar(appBar, appBarActions: getAppBarAction(),);
    } else if (appBar is! AppBar && appBar is! PreferredSizeWidget) {
      // If it's not a String, AppBar, or a widget that can be an app bar, don't show it.
    }
    if (widget.showAppBar == false) {
      appBar = null;
    }

    return Scaffold(
      appBar: appBar,
      body: getBody(context),
    );
  }

}