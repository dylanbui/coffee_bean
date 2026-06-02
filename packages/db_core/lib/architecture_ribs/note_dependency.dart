/*
 * Created with IntelliJ IDEA
 * Package: commons.architecture_ribs
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 11:08
 */

/// DbNoteDependency: Interface for defining the required dependencies of a module.
///
/// Subclasses should define properties required by the module from the Dependency Injection (DI) graph.
/// [Dependency] - Danh sách kiểm kê đồ nghề.
/// Mỗi module sẽ định nghĩa một interface kế thừa từ đây.
abstract interface class DbNoteDependency {}

/// DbNoteEmptyDependency: A specialized interface for modules that have no external dependencies.
abstract interface class DbNoteEmptyDependency extends DbNoteDependency {}

/// [Component] - Trạm trung chuyển đồ nghề.
/// Chịu trách nhiệm lấy đồ từ Cha hoặc từ Kho tổng (Locator).
abstract class DbNoteComponent<D extends DbNoteDependency> implements DbNoteDependency {
  final D dependency; // Tham chiếu về cha
  DbNoteComponent(this.dependency);
}

/*
Mo ta cach su dung DbNoteDependency, no thay the cho locator, truyen cac class duoc su dung toan cuc cho cac note con
// 1. Khai báo nhu cầu
abstract interface class FoodDetailDependency {
  CartService get cartService;
  DatabaseService get dbService;
}

// 2. Builder nhận nhu cầu
class FoodDetailBuilder extends DbNoteBuilder {
  final FoodDetailDependency dependency;
  FoodDetailBuilder(this.dependency);

  @override
  build() {
    // 3. Tiêm vào Interactor
    final interactor = FoodDetailInteractor(
      cartService: dependency.cartService,
      dbService: dependency.dbService,
    );
  }
}



 */