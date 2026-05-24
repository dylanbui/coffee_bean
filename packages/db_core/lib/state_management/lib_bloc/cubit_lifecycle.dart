// lib/core/lifecycle_cubit.dart
import 'package:db_core/architecture_ribs/lifecycle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// CubitLifecycle: Provides lifecycle management methods for Cubit/Interactor.
/// 
/// [State]: Data type of the state of the Cubit.
///
/// Inherits from DbLifecycle to synchronize the operational lifecycle of the Interactor with the displayed Widget.
abstract class CubitLifecycle<State> extends Cubit<State> implements DbLifecycle {

  bool _closed = false;

  CubitLifecycle(super.initialState);

  @override
  void didBecomeActive() {

  }

  @override
  void willResignActive() {
    if (_closed) return;
    _closed = true;
    close();
  }
  
}
