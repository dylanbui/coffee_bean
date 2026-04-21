/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 15/08/2022 - 14:37
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';

/// The base builder protocol that all builders should conform to.
abstract class DbNoteInteractable {}

//Interactable
abstract class DbNoteInteractor<T extends DbNoteRoutable, P extends DbNotePresentable> implements DbNoteInteractable, DbNotePresentable {

  /// The dependency used for this builder to build the RIB.
  T? router;
  P? presenter;

  /// Initializer.
  ///
  /// - parameter dependency: The dependency used for this builder to build the RIB.
  // DbNoteInteractor({this.router});

}

// Dang thu nghiem Presentable

/// The base protocol for all `Presenter`s.
abstract class DbNotePresentable {}

/// The special empty dependency.
abstract class DbNoteEmptyPresenter extends DbNotePresentable {}

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
}