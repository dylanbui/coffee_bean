import 'package:isar_community/isar.dart';

part 'cache_table.g.dart';

@collection
class TblCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late String content; // Lưu dưới dạng JSON String

  @Index()
  String? group;

  @Index()
  late DateTime expiry; // Luôn lưu giờ UTC

  bool get isExpired => DateTime.now().toUtc().isAfter(expiry);
}
