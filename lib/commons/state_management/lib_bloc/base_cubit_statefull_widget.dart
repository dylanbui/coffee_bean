
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/custom_app_bar.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/view_utils_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// https://github.com/FlorinMihalache/flutter_progress_hud

//ignore: must_be_immutable
abstract class BaseCubitStateFulWidget extends StatefulWidget {

  DbNoteRouter? router;
  bool showAppBar = true;

  BaseCubitStateFulWidget({super.key, this.router});
}

// abstract class BaseBlocState<B extends BaseBlocStateFulWidget, P extends BaseProvider> extends State<B> {
// abstract class BaseCubitStateLessWidget<P extends Cubit<S>, S> extends StatelessWidget {

/// Base class for stateful widgets that require a specific Cubit.
/// [B] is the StatefulWidget type.
/// [C] is the specific Cubit type.
/// [I] is the Interactor or Router type injected via Provider.
///
/// ### Sample Code:
/// ```dart
/// class _MyPageState extends BaseCubitState<MyPage, MyCubit, MyInteractor> {
///   @override
///   void initState() {
///     super.initState();
///     interactor.fetchInitialData();
///   }
///
///   @override
///   Widget getBody(BuildContext context) {
///     return IconButton(
///       onPressed: () => interactor.goBack(), 
///       icon: const Icon(Icons.arrow_back),
///     );
///   }
/// }
/// ```
abstract class BaseCubitState<B extends BaseCubitStateFulWidget, C extends Cubit<dynamic>, I> extends State<B> with ViewUtilsMixin {

  /// should be overridden in extended widget
  Widget? getLayout(BuildContext context) => null;

  // void startBuild(BuildContext context) { }
  dynamic getAppBar(BuildContext context) => "";
  Widget getBody(BuildContext context) => const Text("implement getBody() function");
  List<Widget> getAppBarAction() => [];


  late BuildContext buildContext;

  /// The Cubit instance for this page. Used to call methods (not for listening to state).
  late C interactor;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    
    // Use context.read() instead of Provider.of() to prevent the entire Scaffold 
    // from rebuilding every time the Cubit emits a new state.
    interactor = context.read<C>();

    // Muon control thang nao thi phai dung context thang do
    var layout = getLayout(context);
    if (layout != null) {
      return layout;
    }

    var appBar = getAppBar(context);
    if (appBar is String) {
      // tao 1 custom use for common theme
      appBar = CustomAppBar(appBar, appBarActions: getAppBarAction(),);
    }

    // if (appBar is! AppBar) {
    //   throw Exception("Need to AppBar Widget or String !");
    // }

    if (widget.showAppBar == false) {
      appBar = null;
    }

    return Scaffold(
      appBar: appBar,
      body: getBody(context),
    );
  }
}
