/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 15/08/2022 - 14:37
 */

import 'package:db_core/architecture_ribs/note_router.dart';

/// DbNoteInteractable: Marker interface for components that can be interacted with.
abstract class DbNoteInteractable {}

/// DbNoteInteractor: Base class for RIBs business logic components.
///
/// The Interactor is responsible for processing business logic, handling events,
/// and commanding navigation through the Router.
///
/// ### Usage:
/// ```dart
/// class MyInteractor extends DbNoteInteractor<MyRouter> {
///   void onUserAction() {
///     // Handle logic, then navigate
///     router?.pushNext();
///   }
/// }
/// ```
abstract class DbNoteInteractor<T extends DbNoteRoutable> implements DbNoteInteractable {
  /// The router associated with this interactor.
  late T? router;

  DbNoteInteractor({this.router});
}

/// DbNotePresenterInteractor: An Interactor that also coordinates with a Presenter.
///
/// Used when UI formatting logic is complex enough to be separated from the business logic.
abstract class DbNotePresenterInteractor<T extends DbNoteRoutable, P extends DbNotePresentable> extends DbNoteInteractor<T> {
  /// The presenter responsible for UI-related data transformations.
  final P presenter;

  DbNotePresenterInteractor({required this.presenter, super.router});
}

/// DbNotePresentable: Interface for UI data transformation components (Presenters).
abstract class DbNotePresentable {
  /// Lifecycle method to release resources.
  void dispose();
}

/// DbNoteEmptyPresenter: A placeholder presenter for modules that don't require specific presentation logic.
abstract class DbNoteEmptyPresenter extends DbNotePresentable {
  @override
  void dispose() {
    // No-op
  }
}

/// DbNotePresenter: Base implementation of a Presenter.
///
/// It translates raw business models into view models consumable by the View.
class DbNotePresenter<InteractorType> extends DbNotePresentable {
  /// Reference to the Interactor to communicate UI events back to business logic.
  final InteractorType interactor;

  DbNotePresenter(this.interactor);

  @override
  void dispose() {
    // No-op by default
  }
}
