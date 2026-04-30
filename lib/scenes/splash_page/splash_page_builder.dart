import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/splash_page/splash_page_interactor.dart';
import 'package:coffee_bean/scenes/splash_page/splash_page_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- LISTENER ---
// Defines the "contract" that the parent module must implement to receive notifications
// when this splash module completes.
abstract interface class SplashPageListener {
  void onSplashPageCompleted();
}

// --- ROUTE ---
// A Route object to communicate the "completion" event from the Interactor to the Builder/Router.
class SplashPageCompleteRoute implements DbNoteRoute {}

// --- BUILDER ---
// Responsible for initializing the Interactor, Page, and connecting them.
class SplashPageBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable {
  final SplashPageListener listener;

  SplashPageBuilder({required this.listener});

  @override
  Widget build() {
    // The Interactor (Cubit) is created here. It receives a reference to the router (which is 'this').
    final interactor = SplashPageInteractor(router: this);
    final page = SplashPagePage();

    // BlocProvider "injects" the Cubit into the widget tree, making it accessible to the Page.
    rootPage = BlocProvider<SplashPageInteractor>.value(value: interactor, child: page);
    return rootPage;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is SplashPageCompleteRoute) {
      // When the completion route is received, notify the parent module's listener.
      listener.onSplashPageCompleted();
    }
  }
}
