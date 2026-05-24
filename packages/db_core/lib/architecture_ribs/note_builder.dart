/*
 * Created with IntelliJ IDEA
 * Package: commons.architecture_ribs
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 11:08
 */

import 'package:db_core/architecture_ribs/note_router.dart';

/// DbNoteDependency: Interface for defining the required dependencies of a module.
///
/// Subclasses should define properties required by the module from the Dependency Injection (DI) graph.
abstract interface class DbNoteDependency {}

/// DbNoteEmptyDependency: A specialized interface for modules that have no external dependencies.
abstract interface class DbNoteEmptyDependency extends DbNoteDependency {}

/// DbNoteBuildable: The base interface for all module builders.
abstract interface class DbNoteBuildable {}

/// DbNoteBuilder: The base class responsible for instantiating a RIB and setting up its internal wiring.
///
/// It coordinates the creation of the Router, Interactor, and Page.
///
/// ### Usage:
/// ```dart
/// class MyBuilder extends DbNoteBuilder<MyRouter> {
///   @override
///   MyRouter build() {
///     final router = MyRouter();
///     final interactor = MyInteractor(router);
///     final page = MyPage(interactor: interactor);
///     router.attach(interactor, page);
///     return router;
///   }
/// }
/// ```
abstract class DbNoteBuilder<T extends DbNoteRouter> extends DbNoteBuildable {
  /// Builds and returns the [DbNoteRouter] for the module.
  T build();
}
