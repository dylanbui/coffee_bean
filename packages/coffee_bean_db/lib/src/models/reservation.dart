import 'package:isar_community/isar.dart';
import 'product.dart';

part 'reservation.g.dart';

@collection
class TblReservation {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int serverId = 0;

  @Index(type: IndexType.value, caseSensitive: false)
  String name = "";

  @Index(type: IndexType.value, caseSensitive: false)
  String address = "";

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

  String? phone;
  double latitude = 0.0;
  double longitude = 0.0;

  String? openingTime;
  String? closingTime;

  bool isActive = true;
}
