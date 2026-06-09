import 'package:coffee_bean_db/src/app_database.dart';
import 'package:isar_community/isar.dart';
import 'base_mixin.dart';

mixin ReservationServiceMixin on BaseMixin {
  Future<List<TblReservation>> getAllReservations() =>
      isar.tblReservations.filter().isActiveEqualTo(true).findAll();

  Future<List<TblReservation>> searchReservations({String? query, int? catId}) async {
    QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition> queryBuilder =
        isar.tblReservations.filter().isActiveEqualTo(true);

    if (query != null && query.isNotEmpty) {
      final searchTerms = toNoSign(query);
      queryBuilder = queryBuilder.searchNameContains(searchTerms, caseSensitive: false);
    }

    if (catId != null) {
      queryBuilder = queryBuilder.catIdsElementEqualTo(catId);
    }

    return queryBuilder.findAll();
  }

  Future<void> syncReservationData(List<dynamic> reservationJson) async {
    await isar.writeTxn(() async {
      final items = reservationJson.map((json) => mapToReservation(json)).toList();
      await isar.tblReservations.clear();
      await isar.tblReservations.putAll(items);
    });
  }

  TblReservation mapToReservation(dynamic json) {
    final name = json['name'] ?? '';
    final address = json['address'] ?? '';
    return TblReservation()
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
      ..catIds = (json['category_ids'] as List?)?.map((e) => e as int).toList()
      ..isActive = json['is_active'] ?? true;
  }
}
