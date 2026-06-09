import 'package:isar_community/isar.dart';

part 'comment.g.dart';

@collection
class TblComment {
  Id id = Isar.autoIncrement;

  @Index()
  int serverId = 0;

  @Index()
  int productId = 0;

  @Index()
  String type = "FOOD"; // "FOOD", "COURSE"

  int userId = 0;
  String userName = "";
  String? avatar;
  String content = "";
  List<String>? images;
  double rating = 5.0;

  DateTime createdAt = DateTime.now();
}

@collection
class TblCommentSyncMetadata {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int productId = 0;

  @Index()
  String type = "FOOD";

  DateTime lastSync = DateTime.now();
}
