
import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

// --- LISTENER ---
// Defines the "contract" that the parent module must implement to receive notifications
// when this splash module completes.
abstract interface class SplashPageListener {
  void onSplashPageCompleted();
}

// --- ROUTE ---
// A Route object to communicate the "completion" event from the Interactor to the Builder/Router.
class SplashPageCompleteRoute implements DbNoteRoute {}

class SplashPageRouter extends DbNoteRouter {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is SplashPageCompleteRoute) {
      // When the completion route is received, notify the parent module's listener.
      // listener.onSplashPageCompleted();
    }
  }
}

// --- BUILDER ---
// Responsible for initializing the Interactor, Page, and connecting them.
class SplashPageBuilder implements DbNoteBuilder<SplashPageRouter> {
  SplashPageListener? listener;

  SplashPageBuilder({required this.listener});

  // @override
  // ViewController buildFactory() {
  //   // The Interactor (Cubit) is created here. It receives a reference to the router (which is 'this').
  //   final interactor = SplashPageInteractor(router: this);
  //   final page = SplashPagePage();
  //   // BlocProvider "injects" the Cubit into the widget tree, making it accessible to the Page.
  //   return BlocProvider<SplashPageInteractor>.value(value: interactor, child: page);
  // }

  @override
  SplashPageRouter build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  SplashPageRouter buildWithListener(SplashPageListener callback) {
    listener = callback;
    return build();
  }
}
