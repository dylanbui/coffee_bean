import 'package:isar_community/isar.dart';

part 'cache_table.g.dart';

@collection
class TblCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late String content; // Lưu dưới dạng JSON String của phần 'data' trong API response

  /// MD5 Hash của toàn bộ response body phục vụ cơ chế Change Detection.
  /// Nếu hash server trả về giống hash này, UI sẽ không cần re-render.
  String? hash; 

  /// Thời điểm bản ghi được cập nhật vào database.
  late DateTime updatedAt; 

  @Index()
  String? group; // Cho phép xóa cache theo cụm (VD: 'checkout', 'profile')

  @Index()
  late DateTime expiry; // Thời điểm hết hạn (luôn lưu UTC)

  /// Logic kiểm tra xem cache còn hiệu lực hay không
  bool get isExpired => DateTime.now().toUtc().isAfter(expiry);
}
