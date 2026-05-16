import 'dart:async';

import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/custom_app_bar.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/bloc_interactor.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/view_utils_mixin.dart';
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

/// BlocStatefulWidget: Base class for StatefulWidget using Bloc (Event-State) in RIBs architecture.
/// 
/// [B]: BlocInteractor - Component for coordinating logic (Business Logic) and routing (Routing).
/// [E]: Event - Event type.
/// [S]: State - State used to build the interface.
///
/// Suitable for screens with complex logic and many user interaction events.
//ignore: must_be_immutable
abstract class BlocStatefulWidget<B extends BlocInteractor<DbNoteRoutable, E, S>, E, S> extends StatefulWidget {
  const BlocStatefulWidget({super.key, required this.interactor});

  final B interactor;

  @override
  State<BlocStatefulWidget<B, E, S>> createState() => _BlocState<B, E, S>();
}

class _BlocState<B extends BlocInteractor<DbNoteRoutable, E, S>, E, S> extends State<BlocStatefulWidget<B, E, S>>
    with ViewUtilsMixin {
  B get interactor => widget.interactor;

  String getTitle() => "";
  List<Widget> getAppBarAction() => [];
  dynamic getAppBar(BuildContext context, S state) => CustomAppBar(getTitle(), appBarActions: getAppBarAction());

  Widget getBody(BuildContext context, S state) => const Text("implement getBody() function");

  late BuildContext buildContext;

  /// override để build UI theo state
  Widget buildWithState(BuildContext context, S state) {
    return Scaffold(appBar: getAppBar(context, state), body: getBody(context, state));
  }

  /// override để xử lý side-effect
  void onStateChanged(BuildContext context, S state) {}

  @override
  void initState() {
    super.initState();
    try {
      scheduleMicrotask(() {
        if (mounted) interactor.didBecomeActive();
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    try {
      interactor.willResignActive();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return BlocProvider.value(
      value: interactor,
      child: BlocConsumer<B, S>(
        listener: (context, state) => onStateChanged(context, state),
        builder: (context, state) => buildWithState(context, state),
      ),
    );
  }
}

/*

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

  late I interactor;

  @override
  void initState() {
    super.initState();
    interactor = context.read<I>();
    if (interactor is DbNoteInteractor) {
      scheduleMicrotask(() {
        if (mounted) (interactor as DbNoteInteractor).didBecomeActive();
      });
    }
  }

  @override
  void dispose() {
    if (interactor is DbNoteInteractor) {
      (interactor as DbNoteInteractor).willResignActive();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    
    // Use context.read() instead of Provider.of() to prevent the entire Scaffold 
    // from rebuilding every time the Bloc emits a new state.
    blocProvider = context.read<BLOC>();
    // interactor = context.read<I>(); // Neu can thiet thi update tai day, nhung tot nhat nen o initState

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


 */
