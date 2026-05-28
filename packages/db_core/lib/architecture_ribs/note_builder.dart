/*
 * Created with IntelliJ IDEA
 * Package: commons.architecture_ribs
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 11:08
 */



import 'package:db_core/architecture_ribs/note_dependency.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

/// DbNoteBuildable: The base interface for all module builders.
abstract interface class DbNoteBuildable {
  DbNoteDependency get dependency;
}

/// [Builder] - Nhà máy sản xuất module.
/// Luôn yêu cầu 'dependency' ngay từ khi khởi tạo.
abstract class DbNoteWithDependencyBuilder<D extends DbNoteDependency> implements DbNoteBuildable {
  @override
  final D dependency;

  DbNoteWithDependencyBuilder(this.dependency);
}

/// Concrete implementation cho DbNoteEmptyDependency.
class _DbNoteEmptyDependency implements DbNoteEmptyDependency {
  const _DbNoteEmptyDependency();
}

/// NoteEmptyBuilder: Builder đơn giản khi không có dependency.
/// <R extends DbNoteRoutable> cho moi nguoi nho la Builder => tao Router
abstract class DbNoteBuilder<R extends DbNoteRoutable> extends DbNoteWithDependencyBuilder<DbNoteEmptyDependency> {
  DbNoteBuilder() : super(const _DbNoteEmptyDependency());

  R build() {
    throw Exception();
  }
}



/// [DbNoteSimpleRouterBuilder] - Gộp Router và Builder làm một cho các module đơn giản.
/// Giảm Boilerplate: Giảm số lượng file và class trong các module đơn giản.
abstract class DbNoteSimpleRouterBuilder extends DbNoteRouter implements DbNoteBuildable {

  // Mặc định dùng EmptyDependency cho các module đơn giản
  DbNoteSimpleRouterBuilder() : super();

  // Khong lam gi ca
  @override
  DbNoteDependency get dependency => _DbNoteEmptyDependency();

  /// Phương thức build tự trả về chính mình (Router)
  DbNoteSimpleRouterBuilder build();
}



/// Giao thức builder cơ bản.
// abstract class NoteBuildable<R extends NoteRoutable> {
//   R build();
// }

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
// abstract class DbNoteBuilder<T extends DbNoteRouter> extends DbNoteBuildable {
//   /// Builds and returns the [DbNoteRouter] for the module.
//   T build();
// }
