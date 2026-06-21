import 'package:isar_community/isar.dart';

part 'category.g.dart';

@collection
class TblCategory {
  Id id = Isar.autoIncrement;

  @Index()
  int serverId = 0;
  
  int parentId = 0;
  int parentServerId = 0; // Compatibility

  @Index()
  String type = "FOOD"; // "FOOD", "COURSE", "RENTAL"

  @Index(caseSensitive: false)
  String name = "";

  @Index(caseSensitive: false)
  String searchName = "";

  String? picUrl;
  String? image; // Compatibility
  
  @Index()
  int? storeId; // Added for store-specific sync

  int sortOrder = 0;
  bool isActive = true;
}
