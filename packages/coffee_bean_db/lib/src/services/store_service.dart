import 'package:coffee_bean_db/src/app_database.dart';
import 'package:isar_community/isar.dart';
import 'package:coffee_bean_db/src/services/base_mixin.dart';

mixin StoreServiceMixin on BaseMixin {
  Future<List<TblStore>> getAllStores() => isar.tblStores.filter().isActiveEqualTo(true).findAll();

  Future<List<TblStore>> searchStores(String query) async {
    final searchTerms = toNoSign(query);
    return isar.tblStores
        .filter()
        .isActiveEqualTo(true)
        .and()
        .searchNameContains(searchTerms, caseSensitive: false)
        .findAll();
  }

  Future<void> syncStoreData(List<dynamic> storesJson) async {
    await isar.writeTxn(() async {
      final stores = storesJson.map((json) => mapToStore(json)).toList();
      await isar.tblStores.clear();
      await isar.tblStores.putAll(stores);
    });
  }

  TblStore mapToStore(dynamic json) {
    final name = json['name'] ?? '';
    final address = json['address'] ?? '';
    return TblStore()
      ..serverId = json['server_id'] ?? json['id']
      ..name = name
      ..address = address
      ..searchName = toNoSign("$name $address")
      ..phone = json['phone']
      ..latitude = (json['latitude'] ?? 0.0).toDouble()
      ..longitude = (json['longitude'] ?? 0.0).toDouble()
      ..openingTime = json['opening_time']
      ..closingTime = json['closing_time']
      ..images = mapImages(json)
      ..isActive = json['is_active'] ?? true;
  }
}
