/*
 * Created with IntelliJ IDEA
 * Package:
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 26/08/2022 - 16:13
 * To change this template use File | Settings | File Templates.
 */

import 'dart:async';

import 'package:coffee_bean/core/architecture_ribs/note_interactor.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
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
/// Base class for BLoCs that do NOT have a presenter.
abstract class BlocInteractor<T extends DbNoteRoutable, Event, State> extends Bloc<Event, State>
    implements DbNoteInteractor<T> {
  @override
  T? router;

  InteractorLifecycle _lifecycle = InteractorLifecycle.initialized;

  BlocInteractor(super.initialState, {this.router}) {
    // scheduleMicrotask(() {
    //   if (!isClosed) didBecomeActive();
    // });
  }

  /// ĐIỀU PHỐI (Orchestrator): Widget sẽ gọi hàm này. 
  /// Hàm này đảm bảo onDidBecomeActive chỉ chạy 1 lần.
  @override
  void didBecomeActive() {
    if (_lifecycle == InteractorLifecycle.active) return;
    _lifecycle = InteractorLifecycle.active;
    onDidBecomeActive();
  }

  /// ĐIỀU PHỐI (Orchestrator): Widget hoặc hàm close sẽ gọi hàm này.
  @override
  void willResignActive() {
    if (_lifecycle != InteractorLifecycle.active) return;
    _lifecycle = InteractorLifecycle.resigned;
    onWillResignActive();
  }

  // --- HOOK METHODS: Lớp con sẽ override các hàm này ---

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

/// Base class for BLoCs that ARE coupled with a Presenter.
/// The presenter is non-nullable, ensuring type safety.
abstract class BlocPresenterInteractor<T extends DbNoteRoutable, P extends DbNotePresentable, Event, State>
    extends BlocInteractor<T, Event, State> implements DbNotePresenterInteractor<T, P> {
  @override
  final P presenter;

  BlocPresenterInteractor(super.initialState, {required this.presenter, super.router});

  @override
  Future<void> close() {
    presenter.dispose();
    return super.close();
  }
}
