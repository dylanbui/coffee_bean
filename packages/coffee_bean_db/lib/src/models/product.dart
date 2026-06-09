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
class TblActivity {
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

  List<TblProductProperty>? properties;
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
