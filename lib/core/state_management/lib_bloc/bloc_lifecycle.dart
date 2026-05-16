import 'package:coffee_bean/core/architecture_ribs/lifecycle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// BlocLifecycle: Provides lifecycle management methods for Bloc/Interactor.
/// 
/// [Event]: Event type.
/// [State]: State type.
///
/// Synchronizes the operational lifecycle of the Bloc with the Widget via the DbLifecycle interface.
abstract class BlocLifecycle<Event, State> extends Bloc<Event, State> implements DbLifecycle {
  bool _closed = false;

  BlocLifecycle(super.initialState);

  @override
  void didBecomeActive() {}

  @override
  void willResignActive() {
    if (_closed) return;
    _closed = true;
    close();
  }
}
