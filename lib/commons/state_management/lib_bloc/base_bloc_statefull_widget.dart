
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/commons/custom_app_bar.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/view_utils_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A Base Stateful Widget designed for pages using [Bloc] (Event-State pattern).
///
/// ### Usage:
/// - Extend this class when your page needs a lifecycle (e.g., `initState` to fetch data).
/// - Use the `bloc` property to dispatch events: `bloc.add(FetchDataEvent());`.
/// - Do NOT expect the whole page to rebuild on state changes. Use `BlocBuilder`
///   inside [getBody] to rebuild specific UI parts.
///
/// ### Sample Code:
/// ```dart
/// class MyBlocPage extends BaseBlocStateFulWidget {
///   MyBlocPage({super.key});
///   @override
///   State<MyBlocPage> createState() => _MyBlocPageState();
/// }
///
/// class _MyBlocPageState extends BaseBlocViewState<MyBlocPage, MyBloc, MyInteractor> {
///   @override
///   void initState() {
///     super.initState();
///     blocProvider.add(FetchInitialDataEvent());
///   }
///
///   @override
///   Widget getBody(BuildContext context) {
///     return ElevatedButton(
///       onPressed: () => interactor.goToDetails(), 
///       child: const Text("Chi tiết"),
///     );
///   }
/// }
/// ```
//ignore: must_be_immutable
abstract class BaseBlocStateFulWidget extends StatefulWidget with ViewControllable {

  /// The Interactor or Navigation object used to handle business logic.
  // dynamic nav;
  /// The Router object used in RIBs architecture.
  // DbNoteRouter? router;
  bool showAppBar = true;

  BaseBlocStateFulWidget({super.key});

}

/// Base View State class for BLoC UI handling.
/// [B] is the StatefulWidget type.
/// [BLOC] is the specific Bloc type (must extend Bloc to accept events).
/// [I] is the Interactor or Router type injected via Provider.
abstract class BaseBlocViewState<B extends BaseBlocStateFulWidget, BLOC extends Bloc<BaseBlocEvent, BaseBlocState>, I> extends State<B> with ViewUtilsMixin {

  /// should be overridden in extended widget
  Widget? getLayout(BuildContext context) => null;

  // void startBuild(BuildContext context) { }
  dynamic getAppBar(BuildContext context) => "";
  Widget getBody(BuildContext context) => const Text("implement getBody() function");
  List<Widget> getAppBarAction() => [];


  late BuildContext buildContext;

  /// The Bloc instance for this page. Used to add events (not for listening to state).
  late BLOC blocProvider;

  /// Quick access to the Interactor or Router via Provider.
  /// Usage: `interactor.doSomething()`
  I get interactor {
    return context.read<I>();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    
    // Use context.read() instead of Provider.of() to prevent the entire Scaffold 
    // from rebuilding every time the Bloc emits a new state.
    blocProvider = context.read<BLOC>();

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
