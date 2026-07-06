import 'dart:async';

import 'package:db_core/architecture_ribs/note_interactor.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// An abstract class that merges the responsibilities of a BLoC/Cubit's state management
/// with the business logic and routing capabilities of a RIBs-style Interactor.
///
/// This class is designed to:
/// 1.  **Manage State**: Extends `Cubit<State>` to hold and emit UI states.
/// 2.  **Contain Business Logic**: Houses methods that perform tasks like API calls, data processing, etc.
/// 3.  **Handle Navigation**: Contains a `router` property to delegate navigation actions.
/// 4.  **Lifecycle-Aware**: Provides `didBecomeActive` and `willResignActive` for setup and cleanup.
///
/// ### Sample Code:
///
/// ```dart
/// // 1. Define States (e.g., in a separate file, extending BaseBlocState)
/// class MyPageInitial extends BaseBlocState {}
/// class MyPageLoadSuccess extends BaseBlocState {
///   final List<String> items;
///   MyPageLoadSuccess(this.items);
///   @override List<Object> get props => [items];
/// }
///
/// // 2. Define a Router for navigation (e.g., in a separate file)
/// class MyPageRouter extends DbNoteRouter { // Assuming DbNoteRouter is your base router
///   void goToDetails(int itemId) {
///     push(DetailPage(itemId: itemId));
///   }
/// }
///
/// // 3. Create the Interactor by extending CubitInteractor
/// class MyPageCubit extends CubitInteractor<MyPageRouter, BaseBlocState> {
///   MyPageCubit() : super(MyPageInitial(), router: MyPageRouter());
///
///   @override
///   void onDidBecomeActive() {
///     // Logic call here
///     fetchData();
/// 
///     // 4. Use collect() to manage StreamSubscriptions automatically
///     // collect(locator<DbEventBus>().on<SomeEvent>().listen((event) {
///     //   doSomething();
///     // }));
///   }
///
///   Future<void> fetchData() async {
///     // Simulate API call and emit a new state
///     await Future.delayed(const Duration(seconds: 1));
///     final data = ['Item 1', 'Item 2', 'Item 3'];
///     emit(MyPageLoadSuccess(data));
///   }
///
///   void onItemTapped(int itemId) {
///     // Use the router for navigation
///     router?.goToDetails(itemId);
///   }
/// }
/// ```


/// CubitInteractor: Central class combining Cubit (State Management) and Interactor (RIBs Business Logic).
/// 
/// [T]: DbNoteRoutable - Router responsible for navigation for this module.
/// [S]: State - Data type of the state managed and emitted by this Cubit.
///
/// Interactor is responsible for handling business logic, calling APIs, and commanding navigation
/// through the Router. It completely separates Logic from the UI.
abstract class CubitInteractor<T extends DbNoteRoutable, S> extends Cubit<S>
    implements DbNoteInteractor<T> {
  @override
  T? router;

  InteractorLifecycle _lifecycle = InteractorLifecycle.initialized;

  /// Internal list of subscriptions to be automatically cancelled when the interactor is deactivated.
  final List<StreamSubscription> _autoDisposables = [];

  CubitInteractor(super.initialState, {this.router});

  /// COORDINATOR (Orchestrator): Widget will call this method. 
  /// This method ensures onDidBecomeActive only runs once.
  void didBecomeActive() {
    if (_lifecycle == InteractorLifecycle.active) return;
    _lifecycle = InteractorLifecycle.active;
    onDidBecomeActive();
  }

  /// COORDINATOR (Orchestrator): Widget or close method will call this method.
  void willResignActive() {
    if (_lifecycle != InteractorLifecycle.active) return;
    _lifecycle = InteractorLifecycle.resigned;

    // Automatically cancel all registered subscriptions
    for (var subscription in _autoDisposables) {
      subscription.cancel();
    }
    _autoDisposables.clear();

    onWillResignActive();
  }

  /// Registers a [StreamSubscription] to be automatically cancelled when [willResignActive] is called.
  /// This helps prevent memory leaks without manually overriding [onWillResignActive].
  @protected
  void collect(StreamSubscription subscription) {
    _autoDisposables.add(subscription);
  }

  /// Lắng nghe một Stream và tự động quản lý Subscription.
  /// Đây là hàm tiện ích giúp code gọn gàng hơn thay vì gọi collect(stream.listen(...))
  @protected
  void observe<E>(Stream<E> stream, void Function(E event) onData) {
    collect(stream.listen(onData));
  }

  // --- HOOK METHODS: Subclasses will override these methods ---

  @protected
  void onDidBecomeActive() {}

  @protected
  void onWillResignActive() {}  
  
  @override
  void emit(S state) {
    if (isClosed) return;
    super.emit(state);
  }
  
  @override
  Future<void> close() {
    willResignActive(); // Final safeguard to ensure resources are released
    return super.close();
  }
}

/// CubitPresenterInteractor: Extended version of CubitInteractor supporting a Presenter.
/// 
/// [T]: DbNoteRoutable - Router responsible for navigation.
/// [P]: DbNotePresentable - Presenter responsible for data transformation (UI Logic).
/// [S]: State - State of the Cubit.
///
/// Use this class when an Interactor becomes too large (Massive Interactor). The Presenter will help
/// separate pure business logic (API calls, DB) from presentation logic (string formatting,
/// complex display logic).
/// 
/// ### Sample Code:
/// ```dart
/// // 1. Define a Presenter
/// abstract class MyPresenter extends DbNotePresentable {
///   String formatData(List<String> raw);
/// }
/// 
/// // 2. Create Interactor with Presenter
/// class MyCubit extends CubitPresenterInteractor<MyRouter, MyPresenter, MyState> {
///   MyCubit({required MyPresenter presenter, MyRouter? router}) 
///     : super(MyInitial(), presenter: presenter, router: router);
///
///   void load() {
///     final rawData = ['a', 'b'];
///     // Use presenter to handle presentation logic before emitting state
///     final displayData = presenter.formatData(rawData);
///     emit(MySuccess(displayData));
///   }
/// }
/// ```
abstract class CubitPresenterInteractor<T extends DbNoteRoutable, P extends DbNotePresentable, S>
    extends CubitInteractor<T, S> implements DbNotePresenterInteractor<T, P> {
  @override
  final P presenter;

  CubitPresenterInteractor(super.initialState, {required this.presenter, super.router});

  @override
  Future<void> close() {
    presenter.dispose();
    return super.close();
  }
}
