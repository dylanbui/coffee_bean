/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 15/08/2022 - 14:37
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';

/// The base builder protocol that all builders should conform to.
abstract class DbNoteInteractable {}

/// Base Interactor for RIBs that only handles routing.
abstract class DbNoteInteractor<T extends DbNoteRoutable> implements DbNoteInteractable {
  late T? router;
  void didBecomeActive();
  void willResignActive();

  DbNoteInteractor({this.router});

}

/// An Interactor that also manages a Presenter.
abstract class DbNotePresenterInteractor<T extends DbNoteRoutable, P extends DbNotePresentable> extends DbNoteInteractor<T> {
  final P presenter;

  DbNotePresenterInteractor({required this.presenter, super.router});
}

/// The base protocol for all `Presenter`s.
abstract class DbNotePresentable {
  /// A lifecycle method for presenters to release resources.
  void dispose();
}

/// The special empty dependency.
abstract class DbNoteEmptyPresenter extends DbNotePresentable {
  @override
  void dispose() {
    // No-op
  }
}

/// The base class of all `Presenter`s. A `Presenter` translates business models into values the corresponding
/// `ViewController` can consume and display. It also maps UI events to business logic method, invoked to
/// its listener.
class DbNotePresenter<InteractorType> extends DbNotePresentable {
  /// The view controller of this presenter.
  final InteractorType interactor;

  /// Initializer.
  ///
  /// - parameter viewController: The `ViewController` of this `Pesenters`.
  DbNotePresenter(this.interactor);

  @override
  void dispose() {
    // No-op by default, can be overridden.
  }
}