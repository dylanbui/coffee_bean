import 'package:isar_community/isar.dart';

part 'category.g.dart';

@collection
class TblCategory {
  Id id = Isar.autoIncrement;

  @Index()
  int serverId = 0;
  int parentServerId = 0;

  @Index()
  String type = "FOOD"; // "FOOD", "COURSE", "RENTAL"

  @Index(caseSensitive: false)
  String name = "";

  @Index(caseSensitive: false)
  String searchName = "";

  String? image;
  int sortOrder = 0;
  bool isActive = true;
}
