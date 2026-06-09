import 'package:coffee_bean_db/src/app_database.dart';
import 'package:isar_community/isar.dart';
import 'base_mixin.dart';

mixin CommentServiceMixin on BaseMixin {
  Future<List<TblComment>> getCommentsWithProduct({
    required int productId,
    required String type,
    required Future<List<dynamic>> Function() remoteFetcher,
    int offset = 0,
    int limit = 10,
    Duration cacheDuration = const Duration(minutes: 5),
  }) async {
    final metadata = await isar.tblCommentSyncMetadatas.filter().productIdEqualTo(productId).and().typeEqualTo(type).findFirst();

    final bool isExpired = metadata == null || DateTime.now().difference(metadata.lastSync) > cacheDuration;

    if (isExpired) {
      await Future.delayed(const Duration(milliseconds: 800));
      final remoteData = await remoteFetcher();

      final filteredData = remoteData.where((json) => json['product_id'] == productId && (json['type'] ?? 'FOOD') == type).toList();

      await isar.writeTxn(() async {
        await isar.tblComments.filter().productIdEqualTo(productId).and().typeEqualTo(type).deleteAll();

        final newComments = filteredData.map((json) => mapToComment(json)).toList();
        await isar.tblComments.putAll(newComments);

        final newMetadata = (metadata ?? TblCommentSyncMetadata())
          ..productId = productId
          ..type = type
          ..lastSync = DateTime.now();
        await isar.tblCommentSyncMetadatas.put(newMetadata);
      });
    }

    return isar.tblComments
        .filter()
        .productIdEqualTo(productId)
        .and()
        .typeEqualTo(type)
        .sortByCreatedAtDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
  }

  TblComment mapToComment(dynamic json) {
    return TblComment()
      ..serverId = json['id']
      ..productId = json['product_id']
      ..type = json['type'] ?? 'FOOD'
      ..userId = json['user_id']
      ..userName = json['user_name'] ?? ''
      ..avatar = json['avatar']
      ..content = json['content'] ?? ''
      ..images = (json['images'] as List?)?.map((e) => e.toString()).toList()
      ..rating = (json['rating'] ?? 5.0).toDouble()
      ..createdAt = DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now();
  }
}
