import 'dart:async';

import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/architecture_ribs/note_viewer.dart';
import 'package:db_core/custom_app_bar.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/state_management/lib_bloc/view_utils_mixin.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

/// CubitStateFulWidget: Base class for StatefulWidget using Cubit in RIBs architecture.
/// 
/// [B]: CubitInteractor - Component for coordinating logic (Business Logic) and routing (Routing).
/// [S]: State - State of the Cubit used to build and update the UI.
///
/// This class combines the power of Flutter's StatefulWidget with Cubit to manage state
/// and the lifecycle of the Interactor (RIBs). Ensures didBecomeActive is called when mounted
/// and willResignActive is called when disposed.
//ignore: must_be_immutable
abstract class CubitStateFulWidget<B extends CubitInteractor<DbNoteRoutable, S>, S> extends StatefulWidget with ViewControllable {
  bool showAppBar = true;
  final B interactor;
  CubitStateFulWidget({super.key, required this.interactor});
}

/// Base class for stateful widgets that require a specific Cubit.
abstract class CubitState<T extends CubitStateFulWidget<B, S>, B extends CubitInteractor<DbNoteRoutable, S>, S> extends State<T>
    with ViewUtilsMixin {

  dynamic getAppBar(BuildContext context) => "";
  Widget getBody(BuildContext context) => const Text("implement getBody() function");
  List<Widget> getAppBarAction() => [];

  late BuildContext buildContext;

  /// The Interactor (Cubit) instance for this page.
  B get interactor => widget.interactor;

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

    var appBar = getAppBar(context);
    if (appBar is String) {
      // Default custom app bar for common theme
      appBar = CustomAppBar(appBar, appBarActions: getAppBarAction());
    }

    if (widget.showAppBar == false) {
      appBar = null;
    }

    return BlocProvider.value(
      value: interactor,
      child: Scaffold(
          appBar: appBar is PreferredSizeWidget ? appBar : null,
          body: getBody(context)
      ),
    );
  }
}
