import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:flutter/material.dart';

/// AppCubitStateFulWidget: Base class for pages in the Coffee Bean project.
/// It bridges the core RIBs logic with the project's specific UI requirements.
abstract class AppCubitStateFulWidget<B extends CubitInteractor<DbNoteRoutable, S>, S> 
    extends CubitStateFulWidget<B, S> {
  AppCubitStateFulWidget({super.key, required super.interactor});
}

/// AppCubitState: Base state that integrates CoffeeAppBar and common behaviors.
abstract class AppCubitState<T extends AppCubitStateFulWidget<B, S>, B extends CubitInteractor<DbNoteRoutable, S>, S> 
    extends CubitState<T, B, S> {

  @override
  void initState() {
    super.initState();
    // Log the current screen name for debugging
    iLog('🚀 Pushed into Screen: ${widget.runtimeType}');
  }

  /// Provides the title for the default CoffeeAppBar.
  String? getTitle() => null;

  /// Provides a list of action widgets for the default CoffeeAppBar.
  List<Widget>? getActions() => null;
  
  /// Controls whether to unfocus the keyboard when tapping outside of input fields.
  /// Defaults to false as most pages may not require keyboard interaction.
  bool get tapToUnfocus => false;

  /// Provides a custom style configuration for the default CoffeeAppBar.
  CoffeeAppBarStyleConfig getAppBarStyle() => const CoffeeAppBarStyleConfig();

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    final title = getTitle();
    // Automatically hide AppBar if no title or actions are provided.
    if (title == null && getActions() == null) return null;

    return CoffeeAppBar(
      title: title,
      actions: getActions(),
      style: getAppBarStyle(),
      onBackTap: () {
        interactor.router?.pop();
      },
    );
  }

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    Widget content = body;

    // Wrap the body with a GestureDetector to handle unfocus logic if enabled.
    if (tapToUnfocus) {
      content = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: body,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: content,
    );
  }

  Widget getLoadingView() {
    return const Center(child: LoadingView(width: 150, height: 150));
  }

}
