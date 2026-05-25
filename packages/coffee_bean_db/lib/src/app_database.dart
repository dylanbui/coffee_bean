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

  String? get mainImage {
    if (images == null || images!.isEmpty) return null;
    return images!.firstWhere((img) => img.isPrimary, orElse: () => images!.first).url;
  }

  double price = 0.0;
  String? description;
  bool isActive = true;

  List<TblProductProperty>? properties;
  
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
  int catId = 0;

  @Index(type: IndexType.value, caseSensitive: false)
  String name = "";

  @Index(type: IndexType.value, caseSensitive: false)
  String searchName = "";

  List<TblImage>? images;

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
