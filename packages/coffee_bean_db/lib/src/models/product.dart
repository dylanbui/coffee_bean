import 'package:isar_community/isar.dart';

part 'product.g.dart';

enum ProductType {
  food,
  course,
  rental,
  activity;

  String get name => toString().split('.').last.toUpperCase();
}

@embedded
class TblImage {
  String? url;
  bool isPrimary = false;

  @override
  String toString() => 'TblImage(url: $url, isPrimary: $isPrimary)';
}

@embedded
class TblProductOption {
  int serverId = 0;
  String name = "";
  double extraPrice = 0.0; // Số tiền tuyệt đối dùng để tính toán (Order/Cart)
  int? percent;            // Lưu % nếu có (ví dụ: 30), dùng để hiển thị UI
  bool isAvailable = true;
  String? sku;

  @override
  String toString() => 'Option(name: $name, price: $extraPrice, available: $isAvailable)';
}

@embedded
class TblProductProperty {
  int serverId = 0;
  String groupName = "";
  bool isRequired = false;
  List<TblProductOption>? options;

  @override
  String toString() => 'Property(group: $groupName, options: ${options?.join(', ')})';
}

@embedded
class SelectedOption {
  int? optionServerId;
  String groupName = "";
  String optionName = "";
  double extraPrice = 0.0;

  Map<String, dynamic> toJson() {
    return {
      'option_id': optionServerId,
      'group_name': groupName,
      'option_name': optionName,
      'extra_price': extraPrice,
    };
  }
}

@collection
class TblFood {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int serverId = 0;

  @Index()
  int? storeId; // For cache by store

  @Index()
  String? sku;

  @Index()
  int catId = 0;

  @Index(type: IndexType.value, caseSensitive: false)
  String name = "";

  @Index(type: IndexType.value, caseSensitive: false)
  String searchName = "";

  String? introduction;
  String? picUrl;
  List<String>? sliderPicUrls;
  bool specType = false;
  double price = 0.0;
  double marketPrice = 0.0;
  int stock = 0;
  int salesCount = 0;
  List<int>? deliveryTypes;

  String? description;
  bool isActive = true;

  List<TblProductProperty>? properties;

  // Compatibility fields
  List<TblImage>? images;

  @ignore
  String? get mainImage {
    if (picUrl != null && picUrl!.isNotEmpty) return picUrl;
    if (images == null || images!.isEmpty) return null;
    return images!.firstWhere((img) => img.isPrimary, orElse: () => images!.first).url;
  }

  @ignore
  List<SelectedOption> get defaultSelectedOptions {
    final list = <SelectedOption>[];
    if (properties == null) return list;
    for (var prop in properties!) {
      final options = prop.options;
      if (options != null && options.isNotEmpty) {
        final opt = options.firstWhere((o) => o.isAvailable, orElse: () => options.first);
        list.add(SelectedOption()
          ..optionServerId = opt.serverId
          ..groupName = prop.groupName
          ..optionName = opt.name
          ..extraPrice = opt.extraPrice);
      }
    }
    return list;
  }

  @ignore
  Map<int, TblProductOption> get defaultOptionsMap {
    final map = <int, TblProductOption>{};
    if (properties == null) return map;
    for (var prop in properties!) {
      final options = prop.options;
      if (options != null && options.isNotEmpty) {
        final opt = options.firstWhere((o) => o.isAvailable, orElse: () => options.first);
        map[prop.serverId] = opt;
      }
    }
    return map;
  }

  @override
  String toString() => 'TblFood{name: $name, price: $price}';
}

@collection
class TblActivity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int serverId = 0;

  @Index()
  String? sku;

  @Index(type: IndexType.value, caseSensitive: false)
  String name = "";

  @Index(type: IndexType.value, caseSensitive: false)
  String searchName = "";

  String? picUrl;
  double price = 0.0;
  String? description;
  bool isActive = true;
  List<int>? catIds;

  List<TblProductProperty>? properties;

  // Compatibility fields
  List<TblImage>? images;

  @ignore
  String? get mainImage {
    if (picUrl != null && picUrl!.isNotEmpty) return picUrl;
    if (images == null || images!.isEmpty) return null;
    return images!.firstWhere((img) => img.isPrimary, orElse: () => images!.first).url;
  }
}

@collection
class TblCourse {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int serverId = 0;

  @Index()
  String? sku;

  @Index(type: IndexType.value, caseSensitive: false)
  String name = "";

  @Index(type: IndexType.value, caseSensitive: false)
  String searchName = "";

  String? picUrl;
  double price = 0.0;
  String? description;
  bool isActive = true;
  String? instructor;
  String? videoUrl;
  List<int>? catIds;

  List<TblProductProperty>? properties;

  // Compatibility fields
  List<TblImage>? images;

  @ignore
  String? get mainImage {
    if (picUrl != null && picUrl!.isNotEmpty) return picUrl;
    if (images == null || images!.isEmpty) return null;
    return images!.firstWhere((img) => img.isPrimary, orElse: () => images!.first).url;
  }
}
