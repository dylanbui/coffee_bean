import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/shared/base/keyboard_unfocus_mixin.dart';
import 'package:coffee_bean/shared/base/tap_to_unfocus_mixin.dart';

/// AppCubitStateFulWidget: Base class for pages in the Coffee Bean project.
/// It bridges the core RIBs logic with the project's specific UI requirements.
abstract class AppCubitStateFulWidget<B extends CubitInteractor<DbNoteRoutable, S>, S> 
    extends CubitStateFulWidget<B, S> {
  AppCubitStateFulWidget({super.key, required super.interactor});
}

/// AppCubitState: Base state that integrates CoffeeAppBar and common behaviors.
abstract class AppCubitState<T extends AppCubitStateFulWidget<B, S>, B extends CubitInteractor<DbNoteRoutable, S>, S> 
    extends CubitState<T, B, S> with WidgetsBindingObserver, KeyboardUnfocusMixin, TapToUnfocusMixin {

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
  @override
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
    return wrapTapToUnfocus(
      Scaffold(
        appBar: appBar,
        body: body,
      ),
    );
  }

  Widget getLoadingView() {
    return const Center(child: LoadingView(width: 150, height: 150));
  }

  Widget getEmptyItemView({String caption = "Không tìm thấy nội dung liên quan"}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(AppAssets.images.imgNoneItem, size: 120),
          const SizedBox(height: 16),
          Text(caption,style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
          ),
        ],
      ),
    );
  }

}
