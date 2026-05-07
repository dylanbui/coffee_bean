
import 'dart:async';

import 'package:coffee_bean/commons/architecture_ribs/note_interactor.dart';
import 'package:coffee_bean/commons/custom_app_bar.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/view_utils_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A Base Stateless Widget designed to purely consume and react to a [Cubit]'s state.
///
/// ### Usage:
/// Use this class for simple pages or UI components that only need to rebuild
/// based on the state emitted by a Cubit. 
/// Override [getBody] to draw the UI based on the current state.
/// Override [blocConsumerListener] to handle one-time actions (like showing a dialog when `state is ErrorState`).
///
/// ### ⚠️ LIMITATIONS (WHEN NOT TO USE THIS):
/// 1. **Do NOT use this if the page needs to fetch API/load data immediately upon opening.**
///    If you need an `init()` or `initState()` behavior to trigger a Cubit method, 
///    you **MUST use [BaseCubitStateFulWidget]** instead. 
///    *Why?* Relying on an initial state inside a StatelessWidget's listener to trigger an API call 
///    is an anti-pattern. The `build` method can be called multiple times by the framework, 
///    causing duplicate API calls.
/// 2. **Do NOT store mutable variables here.** StatelessWidgets must be completely immutable.
///
/// ### Sample Code:
/// ```dart
/// class MyPage extends BaseCubitStateLessWidget<MyCubit, MyState, MyInteractor> {
///   MyPage({super.key});
///
///   @override
///   Widget getBody(BuildContext context, MyState state) {
///     return ElevatedButton(
///       onPressed: () => interactor(context).goToNextPage(),
///       child: Text("Tiếp tục"),
///     );
///   }
/// }
/// ```
///
//ignore: must_be_immutable
abstract class BaseCubitStateLessWidget<C extends Cubit<S>, S, I> extends StatelessWidget with ViewUtilsMixin {

  BaseCubitStateLessWidget({super.key});

  String getTitle() => "";
  bool showAppBar = true;

  // Tao make layout
  /// Way 1: should be overridden in extended widget
  Widget? getLayout(BuildContext context) => null;

  /// Way 2
  dynamic getAppBar(BuildContext context, S state) => CustomAppBar(getTitle(), appBarActions: getAppBarAction(),);
  Widget getBody(BuildContext context, S state) => const Text("implement getBody() function");
  List<Widget> getAppBarAction() => [];

  void blocConsumerListener(BuildContext context, S currentState) { }
  bool blocConsumerBuildWhen(BuildContext context, S previousState, S state) { return true; }

  /// Quick access to the Interactor or Router via Provider.
  /// Do StatelessWidget không lưu `context` toàn cục, ta truyền `BuildContext` vào.
  /// Usage: `interactor(context).doSomething()`
  I interactor(BuildContext context) => context.read<I>();

  @override
  Widget build(BuildContext context) {
    final i = interactor(context);
    if (i is DbNoteInteractor) {
      scheduleMicrotask(() {
        i.didBecomeActive();
      });
    }

    // Muon control thang nao thi phai dung context thang do
    var layout = getLayout(context);
    if (layout != null) {
      return layout;
    }

    return BlocConsumer<C, S>(
        listener: (context, state) {
          blocConsumerListener(context, state);
        },
        buildWhen: (previousState, currentState) {
          return blocConsumerBuildWhen(context, previousState, currentState);
        },
        builder: (context, state) {
          return Scaffold(
            appBar: getAppBar(context, state),
            body: getBody(context, state),
          );
        }

    );

  }

}