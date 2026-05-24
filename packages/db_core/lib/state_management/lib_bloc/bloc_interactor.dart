/*
 * Created with IntelliJ IDEA
 * Package:
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 26/08/2022 - 16:13
 * To change this template use File | Settings | File Templates.
 */

import 'dart:async';

import 'package:db_core/architecture_ribs/note_interactor.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/state_management/lib_bloc/bloc_lifecycle.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// An abstract class that merges the responsibilities of a BLoC's event-driven state management
/// with the business logic and routing capabilities of a RIBs-style Interactor.
///
/// This class is designed to:
/// 1.  **Manage State via Events**: Extends `Bloc<Event, State>` to map events to states.
/// 2.  **Contain Business Logic**: Houses the implementation for handling events.
/// 3.  **Handle Navigation**: Contains a `router` property to delegate navigation actions.
/// 4.  **Lifecycle-Aware**: Provides `didBecomeActive` and `willResignActive` for setup and cleanup.
///
/// ### Sample Code:
///
/// ```dart
/// // 1. Define Events & States (extending BaseBlocEvent and BaseBlocState)
/// class FetchDataEvent extends BaseBlocEvent {}
/// class ItemTappedEvent extends BaseBlocEvent {
///   final int itemId;
///   ItemTappedEvent(this.itemId);
///   @override List<Object> get props => [itemId];
/// }
///
/// class MyPageInitial extends BaseBlocState {}
/// class MyPageLoadSuccess extends BaseBlocState {
///   final List<String> items;
///   MyPageLoadSuccess(this.items);
///   @override List<Object> get props => [items];
/// }
///
/// // 2. Define a Router for navigation
/// class MyPageRouter extends DbNoteRouter { // Assuming DbNoteRouter is your base router
///   void goToDetails(int itemId) {
///     push(DetailPage(itemId: itemId));
///   }
/// }
///
/// // 3. Create the Interactor by extending BlocInteractor
/// class MyPageBloc extends BlocInteractor<MyPageRouter, BaseBlocEvent, BaseBlocState> {
///   MyPageBloc() : super(MyPageInitial(), router: MyPageRouter()) {
///     on<FetchDataEvent>(_onFetchData);
///     on<ItemTappedEvent>(_onItemTapped);
///   }
///
///   @override
///   void onDidBecomeActive() {
///     // Logic call here
///     add(FetchDataEvent());
///   }
///
///   Future<void> _onFetchData(FetchDataEvent event, Emitter<BaseBlocState> emit) async {
///     // Simulate API call and emit a new state
///     await Future.delayed(const Duration(seconds: 1));
///     final data = ['Item 1', 'Item 2', 'Item 3'];
///     emit(MyPageLoadSuccess(data));
///   }
///
///   void _onItemTapped(ItemTappedEvent event, Emitter<BaseBlocState> emit) {
///     // Use the router for navigation. No state change needed for this event.
///     router?.goToDetails(event.itemId);
///   }
/// }
/// ```
/// BlocInteractor: Central class combining BLoC (Event-driven State Management) and Interactor (RIBs Business Logic).
/// 
/// [T]: DbNoteRoutable - Router responsible for navigation.
/// [Event]: Data type of events that this BLoC receives.
/// [State]: Data type of the state managed and emitted by this BLoC.
///
/// Inherits the Event-driven mechanism of BLoC to manage complex business logic 
/// and asynchronous data streams.
abstract class BlocInteractor<T extends DbNoteRoutable, Event, State> extends BlocLifecycle<Event, State>
    implements DbNoteInteractor<T> {
  @override
  T? router;

  InteractorLifecycle _lifecycle = InteractorLifecycle.initialized;

  BlocInteractor(super.initialState, {this.router}) {
    // scheduleMicrotask(() {
    //   if (!isClosed) didBecomeActive();
    // });
  }

  /// COORDINATOR (Orchestrator): Widget will call this method.
  /// This method ensures onDidBecomeActive only runs once.
  @override
  void didBecomeActive() {
    if (_lifecycle == InteractorLifecycle.active) return;
    _lifecycle = InteractorLifecycle.active;
    onDidBecomeActive();
  }

  /// COORDINATOR (Orchestrator): Widget or close method will call this method.
  @override
  void willResignActive() {
    if (_lifecycle != InteractorLifecycle.active) return;
    _lifecycle = InteractorLifecycle.resigned;
    onWillResignActive();
  }

  // --- HOOK METHODS: Subclasses will override these methods ---

  @protected
  void onDidBecomeActive() {}

  @protected
  void onWillResignActive() {}

  @override
  Future<void> close() {
    willResignActive();
    return super.close();
  }
}

/// BlocPresenterInteractor: Extended version of BlocInteractor supporting a Presenter.
/// 
/// [T]: DbNoteRoutable - Router responsible for navigation.
/// [P]: DbNotePresentable - Presenter responsible for data transformation (UI Logic).
/// [Event]: Event type.
/// [State]: Cubit state.
///
/// Use this class when presentation logic becomes complex and needs to be separated from 
/// pure event handling logic.
abstract class BlocPresenterInteractor<T extends DbNoteRoutable, P extends DbNotePresentable, Event, State>
    extends BlocInteractor<T, Event, State>
    implements DbNotePresenterInteractor<T, P> {
  @override
  final P presenter;

  BlocPresenterInteractor(super.initialState, {required this.presenter, super.router});

  @override
  Future<void> close() {
    presenter.dispose();
    return super.close();
  }
}
