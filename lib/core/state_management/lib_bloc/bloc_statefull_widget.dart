import 'dart:async';

import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/core/custom_app_bar.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/bloc_interactor.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/view_utils_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BlocStatefulWidget: Base class for StatefulWidget using Bloc (Event-State) in RIBs architecture.
///
/// [B]: BlocInteractor - Component for coordinating logic (Business Logic) and routing (Routing).
/// [E]: Event - Event type.
/// [S]: State - State used to build the interface.
///
/// ### Usage:
/// - Extend this class for your Page widget.
/// - It requires an [interactor] which acts as the Bloc and Business Logic handler.
///
/// ### Sample Code:
/// ```dart
/// class MyPage extends BlocStatefulWidget<MyInteractor, MyEvent, MyState> {
///   MyPage({super.key, required super.interactor});
///
///   @override
///   State<MyPage> createState() => _MyPageState();
/// }
/// ```
//ignore: must_be_immutable
abstract class BlocStatefulWidget<B extends BlocInteractor<DbNoteRoutable, E, S>, E, S>
    extends StatefulWidget with ViewControllable {
  bool showAppBar = true;
  final B interactor;

  BlocStatefulWidget({super.key, required this.interactor});
}

/// BlocState: Base State class for [BlocStatefulWidget].
///
/// [T]: The type of the Widget (must extend BlocStatefulWidget).
/// [B]: The type of the Interactor.
/// [E]: The type of the Event.
/// [S]: The type of the State.
///
/// ### Usage:
/// - Extend this class for your Page's State.
/// - Override [getBody] to build your UI.
/// - Use `interactor.add(MyEvent())` to dispatch events.
/// - Use `BlocBuilder<B, S>` inside [getBody] for state-specific UI updates.
///
/// ### Sample Code:
/// ```dart
/// class _MyPageState extends BlocState<MyPage, MyInteractor, MyEvent, MyState> {
///   @override
///   String getAppBar(BuildContext context) => "My Title";
///
///   @override
///   Widget getBody(BuildContext context) {
///     return BlocBuilder<MyInteractor, MyState>(
///       builder: (context, state) {
///         return Text("Current state: $state");
///       },
///     );
///   }
/// }
/// ```
abstract class BlocState<T extends BlocStatefulWidget<B, E, S>, B extends BlocInteractor<DbNoteRoutable, E, S>, E, S>
    extends State<T> with ViewUtilsMixin {
  
  B get interactor => widget.interactor;

  dynamic getAppBar(BuildContext context) => "";
  Widget getBody(BuildContext context) => const Text("implement getBody() function");
  List<Widget> getAppBarAction() => [];

  late BuildContext buildContext;

  @override
  void initState() {
    super.initState();
    // RIBs Lifecycle: notify interactor that it has become active
    scheduleMicrotask(() {
      try {
        if (mounted) interactor.didBecomeActive();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    // RIBs Lifecycle: notify interactor that it will resign active
    try {
      interactor.willResignActive();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    var appBar = getAppBar(context);
    if (appBar is String) {
      // Default custom app bar for common theme
      appBar = CustomAppBar(appBar, appBarActions: getAppBarAction());
    }

    if (widget.showAppBar == false) {
      appBar = null;
    }

    // Automatically provide the interactor (Bloc) to the subtree
    return BlocProvider.value(
      value: interactor,
      child: Scaffold(
        appBar: appBar is PreferredSizeWidget ? appBar : null,
        body: getBody(context),
      ),
    );
  }
}
