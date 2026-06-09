import 'package:isar_community/isar.dart';
import 'product.dart';

part 'store_point.g.dart';

@collection
class TblStorePoint {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int serverId = 0;

  @Index(type: IndexType.value, caseSensitive: false)
  String name = "";

  @Index(type: IndexType.value, caseSensitive: false)
  String searchName = "";

  List<TblImage>? images;

  @ignore
  String? get mainImage {
    if (images == null || images!.isEmpty) return null;
    return images!.firstWhere((img) => img.isPrimary, orElse: () => images!.first).url;
  }

  @Index()
  List<int>? catIds; // Danh sách các Category ID (n-n)

  double points = 0.0;
  String? description;
  bool isActive = true;
}
