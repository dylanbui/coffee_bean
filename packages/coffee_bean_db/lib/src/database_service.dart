import 'package:coffee_bean_db/src/app_database.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:coffee_bean_db/src/services/base_mixin.dart';
import 'package:coffee_bean_db/src/services/product_service.dart';
import 'package:coffee_bean_db/src/services/store_service.dart';
import 'package:coffee_bean_db/src/services/comment_service.dart';
import 'package:coffee_bean_db/src/services/cart_service.dart';
import 'package:coffee_bean_db/src/services/reservation_service.dart';

export 'models/product.dart' show ProductType;

class DatabaseService with 
    BaseMixin, 
    ProductServiceMixin, 
    StoreServiceMixin, 
    CommentServiceMixin, 
    CartServiceMixin, 
    ReservationServiceMixin {
  
  // --- INITIALIZATION ---
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      TblCacheSchema,
      TblCategorySchema,
      TblFoodSchema,
      TblCourseSchema,
      TblActivitySchema,
      TblCartItemSchema,
      TblStoreSchema,
      TblCommentSchema,
      TblCommentSyncMetadataSchema,
      TblReservationSchema,
      TblStorePointSchema,
    ], directory: dir.path);
  }

  // --- STORE OPERATIONS ---

  /// Xóa sạch dữ liệu khi đổi Store
  Future<void> clearAllDataForNewStore() async {
    await isar.writeTxn(() async {
      await isar.tblCaches.clear();
      await isar.tblCategorys.clear();
      await isar.tblFoods.clear();
      await isar.tblCourses.clear();
      await isar.tblActivitys.clear();
      await isar.tblCartItems.clear();
      await isar.tblStores.clear();
      await isar.tblComments.clear();
      await isar.tblCommentSyncMetadatas.clear();
      await isar.tblReservations.clear();
      await isar.tblStorePoints.clear();
    });
  }
}
