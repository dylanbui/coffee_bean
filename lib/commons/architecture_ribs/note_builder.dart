/*
 * Created with IntelliJ IDEA
 * Package: commons.architecture_ribs
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 11:08
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:flutter/cupertino.dart';


/// The base dependency protocol.
///
/// Subclasses should define a set of properties that are required by the module from the DI graph. A dependency is
/// typically provided and satisfied by its immediate parent module.
abstract interface class DbNoteDependency {}

/// The special empty dependency.
abstract interface class DbNoteEmptyDependency extends DbNoteDependency {}

/// The base builder protocol that all builders should conform to.
abstract interface class DbNoteBuildable {
  ViewController build();
}


/// Utility that instantiates a RIB and sets up its internal wirings.
abstract class DbNoteBuilder<T extends DbNoteDependency> implements DbNoteBuildable {
  /// The dependency used for this builder to build the RIB.
  final T? dependency;

  // Sử dụng private variable để lưu giữ trang đã build[cite: 10]
  ViewController? _cachedPage;


  /// Initializer.
  ///
  /// - parameter dependency: The dependency used for this builder to build the RIB.
  DbNoteBuilder({this.dependency});

  @override
  ViewController build() {
    // Nếu đã build rồi thì trả về cache, bỏ qua tất cả logic khởi tạo
    if (_cachedPage != null) {
      return _cachedPage!;
    }
    // 3. Yêu cầu các Builder con phải implement hàm này thay vì hàm build()
    _cachedPage = buildFactory();
    return _cachedPage!;
  }

  /// Đây là hàm mà các Sub-class (như AppBuilder) sẽ triển khai logic khởi tạo.
  /// Nó đảm bảo chỉ chạy 1 lần duy nhất cho mỗi đối tượng Builder[cite: 7].
  @protected
  ViewController buildFactory();
}

///////////////////////////////


// abstract class DbNoteBuilder {
//
//   // Dung buildContext khong co y nghia o day, moi context co the nghi no la 1 note trong cay
//   // BuildContext buildContext;
//   late Widget rootPage;
//
//   DbNoteBuilder();
//
//   void start(BuildContext fromContext);
//   void startSameRootPage(BuildContext fromContext) {}
//
// }