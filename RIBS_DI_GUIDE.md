# Tài liệu Kiến trúc RIBs & Dependency Injection (Coffee Bean Project)

Tài liệu này định nghĩa bộ khung (Base Code) giúp tách biệt hoàn toàn Logic, Giao diện và Quản lý phụ thuộc (Services/Repositories).

---

## 1. Tầng CORE (Cập nhật `db_core`)

Đây là những thay đổi quan trọng nhất trong các lớp cơ sở để hỗ trợ việc truyền "Giỏ đồ nghề" (Dependency).

### 1.1. `note_builder.dart`
Định nghĩa hệ sinh thái cho việc khai báo nhu cầu và lắp ráp module.

```dart
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

/// [Dependency] - Danh sách kiểm kê đồ nghề. 
/// Mỗi module sẽ định nghĩa một interface kế thừa từ đây.
abstract interface class DbNoteDependency {}

/// [Component] - Trạm trung chuyển đồ nghề. 
/// Chịu trách nhiệm lấy đồ từ Cha hoặc từ Kho tổng (Locator).
abstract class DbNoteComponent<D extends DbNoteDependency> implements DbNoteDependency {
  final D dependency; // Tham chiếu về cha
  DbNoteComponent(this.dependency);
}

/// [Builder] - Nhà máy sản xuất module.
/// Luôn yêu cầu 'dependency' ngay từ khi khởi tạo.
abstract class DbNoteBuilder<D extends DbNoteDependency, R extends DbNoteRouter> {
  final D dependency;
  DbNoteBuilder(this.dependency);

  // Lưu ý: Hàm build() có thể nhận thêm Parameters (như foodId, type)
  R build();
}

/// [Plugin Support] - Hỗ trợ nhúng module con vào module cha.
abstract interface class DbNotePluginBuildable {
  Widget buildPlugin(DbNoteRoutable? parentRouter);
}
```

### 1.2. `note_router.dart`
Cập nhật để Router trở thành "Người giữ túi đồ" cho thế hệ sau.

```dart
abstract interface class DbNoteRoutable {
  DbNoteRoutable? get parentRouter;
  set parentRouter(DbNoteRoutable? value);
  
  // Các hàm điều hướng chuẩn
  void pop();
  void navigate(DbNoteRoute toRoute);
}

abstract class DbNoteRouter implements DbNoteRoutable {
  @override
  covariant DbNoteRouter? parentRouter;

  /// Giỏ đồ nghề: Router nắm giữ để đưa cho các Builder của module con.
  final DbNoteDependency component;

  /// Helper điều hướng.
  late DbNavigator navigator;

  DbNoteRouter(this.component, {this.parentRouter}) {
    navigator = DbNavigator(DbNavigator.globalNavigatorState);
  }
  
  // ... các logic attach interactor và view ...
}
```

---

## 2. Ví dụ thực tế: Module `FoodDetail`

Dưới đây là cách vận hành thực tế của một module theo kiến trúc mới.

### 2.1. Builder & Dependency (`food_detail_builder.dart`)

```dart
/// 1. Định nghĩa nhu cầu: Tôi cần gì để chạy?
abstract interface class FoodDetailDependency extends DbNoteDependency {
  CartService get cartService;
  DatabaseService get dbService;
}

/// 2. Cài đặt trạm trung chuyển: Lấy đồ ở đâu?
class FoodDetailComponent extends DbNoteComponent<AppDependency> implements FoodDetailDependency {
  FoodDetailComponent(super.dependency);

  @override
  CartService get cartService => dependency.cartService; // Lấy từ cha (nếu có)

  @override
  DatabaseService get dbService => locator<DatabaseService>(); // Lấy từ kho tổng (Cách 3 thực dụng)
}

/// 3. Lắp ráp: Kết nối mọi thứ.
class FoodDetailBuilder extends DbNoteBuilder<FoodDetailDependency, FoodDetailRouter> {
  FoodDetailBuilder(super.dependency);

  // Nhận tham số động foodId tại hàm build
  @override
  FoodDetailRouter build(int foodId) {
    // Tạo Component riêng cho module này
    final component = FoodDetailComponent(dependency);
    
    final router = FoodDetailRouter(component);
    final interactor = FoodDetailInteractor(
      router: router,
      dependency: component, // Tiêm túi đồ cho Interactor
      foodId: foodId,
    );

    router.attach(interactor, FoodDetailPage(interactor: interactor));
    return router;
  }
}
```

### 2.2. Interactor (`food_detail_interactor.dart`)

```dart
class FoodDetailInteractor extends CubitInteractor<FoodDetailRoutable, FoodDetailState> {
  final FoodDetailDependency dependency; // Túi đồ được cấp
  final int foodId;

  FoodDetailInteractor({
    required super.router,
    required this.dependency,
    required this.foodId,
  }) : super(FoodDetailState());

  @override
  void onDidBecomeActive() {
    // Sử dụng đồ trong túi một cách tường minh
    final cart = dependency.cartService;
    final db = dependency.dbService;
    
    // Thực thi logic...
  }
}
```

### 2.3. Router (`food_detail_router.dart`)

```dart
class FoodDetailRouter extends DbNoteRouter implements FoodDetailRoutable {
  FoodDetailRouter(super.component);

  // Ép kiểu helper để truy cập túi đồ đúng loại khi cần gọi Builder con
  FoodDetailDependency get _component => component as FoodDetailDependency;

  void openComments(int id) {
    // Truyền túi đồ của mình cho Builder của con
    final builder = CommentListBuilder(_component);
    final nextRouter = builder.build(productId: id);
    
    navigator.push(nextRouter.viewController);
  }
}
```

---

## 3. Tổng kết quy tắc vận hành (Cheatsheet)

1.  **Interactor:** Luôn làm "Người tốt". Không bao giờ được gọi `locator<T>()`. Chỉ dùng dữ liệu/dịch vụ được đưa tận tay qua biến `dependency`.
2.  **Component:** Làm "Người vận chuyển". Là nơi duy nhất giải quyết mâu thuẫn: lấy đồ từ cha (`dependency.xxx`) hoặc lấy đồ từ kho (`locator<xxx>`).
3.  **Builder:** Làm "Người thợ máy". Nhận công cụ (`Dependency`) qua constructor và nhận vật liệu (`Parameters`) qua hàm `build()`.
4.  **Router:** Làm "Người điều phối". Cầm giỏ đồ nghề của mình để đưa cho các "Thợ máy con" (Child Builders).

---

## 4. Nâng cao: Giao tiếp 2 chiều (Controller Pattern cho Plugin)

Khi một Plugin (như `CommentListSmall`) cần giao tiếp phức tạp với trang Cha, chúng ta sử dụng `DbPluginController`.

### 4.1. Base Class đề xuất (Thêm vào `db_core`)

```dart
/// [DbPluginController] - Cầu nối giao tiếp 2 chiều.
/// T: Kiểu Interactor của Con (để Cha gọi Con).
/// L: Kiểu Listener (để Con báo cho Cha).
abstract class DbPluginController<T, L> {
  T? _interactor;
  L? listener;

  void attach(T interactor, {L? listener}) {
    _interactor = interactor;
    this.listener = listener;
  }

  void detach() {
    _interactor = null;
    listener = null;
  }

  T? get interactor => _interactor;
}

/// [DbPluginBuilder] - Ép buộc dùng Controller để đảm bảo giao tiếp.
abstract class DbPluginBuilder<R extends DbNoteRouter, C extends DbPluginController> {
  R build(C controller);
}
```

### 4.2. Ví dụ triển khai Plugin `CommentListSmall`

**Bước 1: Định nghĩa Controller & Listener**
```dart
abstract interface class CommentListSmallListener {
  void onNavigateToAllComments();
}

class CommentListSmallController extends DbPluginController<CommentListSmallInteractor, CommentListSmallListener> {
  void refresh() => interactor?.refreshData();
}
```

**Bước 2: Interactor của Plugin**
```dart
class CommentListSmallInteractor extends ... {
  final CommentListSmallController controller;

  CommentListSmallInteractor({required this.controller}) {
    controller.attach(this);
  }

  @override
  void dispose() {
    controller.detach();
    super.dispose();
  }

  void onViewAll() {
    controller.listener?.onNavigateToAllComments(); // Báo cho Cha
  }
}
```

### 4.3. Cách Cha sử dụng

**Trong Interactor của Cha:**
```dart
class ProductDetailInteractor extends ... implements CommentListSmallListener {
  final commentController = CommentListSmallController();

  @override
  void onNavigateToAllComments() {
    router.openFullComments();
  }

  void onRefreshNeeded() {
    commentController.refresh(); // Gọi xuống Con
  }
}
```

**Trong UI của Cha:**
```dart
Widget buildPlugin() {
  commentController.listener = interactor; // Gán interactor của cha làm listener
  return commentListSmallBuilder.build(commentController).view;
}
```

### 4.4. Đánh giá & Phản biện

*   **Ưu điểm:** Tách biệt hoàn toàn Plugin khỏi Router của Cha. Giao tiếp tường minh, dễ debug và unit test. Hỗ trợ auto-complete tốt từ IDE.
*   **Nhược điểm:** Tăng lượng code boilerplate (phải tạo thêm Controller/Listener).
*   **Lời khuyên:** Dùng cho các Widget có tính logic cao. Với Widget chỉ hiển thị tĩnh, hãy dùng `Dependency` cơ bản để tiết kiệm code.

---
*Dài hạn: Kiến trúc này giúp bạn sẵn sàng cho việc mở rộng dự án lên hàng trăm module mà không sợ bị loạn luồng dữ liệu hoặc khó khăn khi viết Unit Test.*
