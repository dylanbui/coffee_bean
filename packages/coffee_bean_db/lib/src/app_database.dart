import 'package:isar_community/isar.dart';

part 'app_database.g.dart';

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

@collection
class TblFood {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int serverId = 0;

  @Index()
  String? sku;

  @Index()
  int catId = 0;

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

  double price = 0.0;
  String? description;
  bool isActive = true;

  List<TblProductProperty>? properties;
  
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
  String toString() {
    return 'TblFood{name: $name, images: ${images?.length ?? 0}, properties: ${properties?.length ?? 0}\n'
           '  Properties: ${properties?.map((p) => p.toString()).join('\n    ')}\n'
           '}';
  }
  
}

@collection
class TblCourse {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int serverId = 0;

  @Index()
  String? sku;

  @Index()
  List<int>? catIds; // Danh sách các Category ID (n-n)

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

  double price = 0.0;
  String? description;
  bool isActive = true;

  String? instructor;
  String? videoUrl;

  List<TblProductProperty>? properties;

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
  String toString() {
    return 'TblCourse{name: $name, images: ${images?.length ?? 0}, properties: ${properties?.length ?? 0}\n'
           '  Properties: ${properties?.map((p) => p.toString()).join('\n    ')}\n'
           '}';
  }
}

@collection
class TblCartItem {
  Id id = Isar.autoIncrement;

  @Index()
  int serverId = 0;

  @Index()
  String type = "FOOD";

  String? sku;
  String name = "";
  String? image;
  double finalPrice = 0.0;
  int quantity = 0;

  List<SelectedOption>? selectedOptions;

  DateTime addedAt = DateTime.now();

  @ignore
  double get totalPrice => finalPrice * quantity;

  // Chuyển đổi sang định dạng JSON để gửi lên Server khi tạo Order
  Map<String, dynamic> toJsonRequest() {
    return {
      'product_id': serverId,
      'product_type': type,
      'quantity': quantity,
      'price': finalPrice,
      'sku': sku,
      'options': selectedOptions?.map((o) => o.toJson()).toList(),
    };
  }
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
class TblStore {
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

  String? phone;
  double latitude = 0.0;
  double longitude = 0.0;

  String? openingTime;
  String? closingTime;

  bool isActive = true;
}

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
