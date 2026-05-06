import 'dart:async';

import 'package:coffee_bean/commons/architecture_ribs/note_interactor.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
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
/// Base class for Cubits that do NOT have a presenter.
abstract class CubitInteractor<T extends DbNoteRoutable, State> extends Cubit<State>
    implements DbNoteInteractor<T> {
  @override
  T? router;

  CubitInteractor(super.initialState, {this.router}) {
    // scheduleMicrotask(() {
    //   if (!isClosed) didBecomeActive();
    // });

    // Timer.run pushes the execution to the end of the current event queue.
    // This ensures:
    // 1. The constructor finishes, and the object is fully initialized.
    // 2. Flutter has enough time to mount BlocProvider and for UI to subscribe.
    // 3. 'router' is guaranteed to be available before didBecomeActive runs.
    // Timer.run(() {
    //   if (!isClosed) didBecomeActive();
    // });

  }

  @override
  void emit(State state) {
    if (isClosed) return;
    super.emit(state);
  }

  @override
  void didBecomeActive() {}

  @override
  void willResignActive() {}

  @override
  Future<void> close() {
    willResignActive();
    return super.close();
  }
}

/// Base class for Cubits that ARE coupled with a Presenter.
/// The presenter is non-nullable, ensuring type safety.
abstract class CubitPresenterInteractor<T extends DbNoteRoutable, P extends DbNotePresentable, State>
    extends CubitInteractor<T, State> implements DbNotePresenterInteractor<T, P> {
  @override
  final P presenter;

  CubitPresenterInteractor(super.initialState, {required this.presenter, super.router});

  @override
  Future<void> close() {
    presenter.dispose();
    return super.close();
  }
}
