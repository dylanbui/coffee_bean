import 'dart:async';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/architecture_ribs/note_viewer.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/state_management/lib_bloc/view_utils_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// CubitStateFulWidget: Base class for StatefulWidget using Cubit in RIBs architecture.
/// 
/// [B]: CubitInteractor - Component for coordinating logic (Business Logic) and routing (Routing).
/// [S]: State - State of the Cubit used to build and update the UI.
abstract class CubitStateFulWidget<B extends CubitInteractor<DbNoteRoutable, S>, S> 
    extends StatefulWidget with ViewControllable {
  final B interactor;
  CubitStateFulWidget({super.key, required this.interactor});
}

/// Base class for stateful widgets that require a specific Cubit.
abstract class CubitState<T extends CubitStateFulWidget<B, S>, B extends CubitInteractor<DbNoteRoutable, S>, S> 
    extends State<T> with ViewUtilsMixin {

  late BuildContext buildContext;

  /// The Interactor (Cubit) instance for this page.
  B get interactor => widget.interactor;

  /// Override this to provide a custom AppBar. 
  /// If it returns null, the Scaffold will not display an AppBar.
  PreferredSizeWidget? getAppBar(BuildContext context) => null;

  /// Mandatory: Implement the main content of the page.
  Widget getBody(BuildContext context);

  /// Builds the top-level structure of the page.
  /// Subclasses can override this to change the overall layout (e.g., for Dialog-style pages).
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  @override
  void initState() {
    super.initState();
    // Use microtask to ensure UI is ready
    scheduleMicrotask(() {
      try {
        if (mounted) interactor.didBecomeActive();
      } catch (e) {
        // optional: log error
      }
    });
  }

  @override
  void dispose() {
    try {
      interactor.willResignActive();
    } catch (e) {
      // optional: log error
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    final appBar = getAppBar(context);
    final body = getBody(context);

    return BlocProvider.value(
      value: interactor,
      child: buildScaffold(context, appBar, body),
    );
  }
}
