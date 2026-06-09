import 'package:coffee_bean_db/src/app_database.dart';
import 'package:isar_community/isar.dart';

mixin BaseMixin {
  late Isar isar;

  Map<int, List<TblProductProperty>> assembleProperties(List<dynamic> json) {
    final map = <int, List<TblProductProperty>>{};
    for (var p in json) {
      final prop = TblProductProperty()
        ..serverId = p['id']
        ..groupName = p['group_name'] ?? ''
        ..isRequired = p['is_required'] ?? false
        ..options = (p['options'] as List? ?? [])
            .map(
              (o) => TblProductOption()
                ..serverId = o['id']
                ..name = o['name'] ?? ''
                ..extraPrice = (o['extra_price'] ?? 0).toDouble()
                ..percent = o['percent']
                ..isAvailable = o['is_available'] ?? true
                ..sku = o['sku'],
            )
            .toList();
      map.putIfAbsent(p['product_id'], () => []).add(prop);
    }
    return map;
  }

  List<TblImage>? mapImages(dynamic json) {
    if (json['images'] != null && json['images'] is List) {
      return (json['images'] as List)
          .map((img) => TblImage()
            ..url = img['url']
            ..isPrimary = img['is_primary'] ?? false)
          .toList();
    }
    if (json['image'] != null && json['image'] is String) {
      return [TblImage()..url = json['image']..isPrimary = true];
    }
    return null;
  }

  String toNoSign(String str) {
    if (str.isEmpty) return "";
    var result = str.toLowerCase();
    result = result.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    result = result.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    result = result.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    result = result.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    result = result.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    result = result.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    result = result.replaceAll(RegExp(r'[đ]'), 'd');
    return result;
  }
}
