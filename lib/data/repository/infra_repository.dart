import 'dart:io';
import 'package:coffee_bean/data/model/response/system/announcement.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/network/network_upload_response.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:db_core/commons_constants.dart';
import 'package:db_core/cache/cache_provider.dart';
import 'package:db_core/utils/locator.dart';

class InfraRepository extends BaseRepository {
  InfraRepository({super.client});

  /// Get agreement dictionary by type
  /// 1=NOTICE, 2=ANNOUNCEMENT, 3=AGREEMENT, 4=PRIVACY_POLICY
  /// API: GET /app-api/system/notice/get-agreement
  /// Cache for 3 hours
  Future<DbResult<Dictionary>> getAgreementDictionary(int type) async {
    final cacheKey = 'agreement_$type';
    final cacheProvider = locator<DbCacheProvider>();

    // 1. Try to get from Cache
    final Dictionary? cachedData = await cacheProvider.get<Dictionary>(cacheKey);
    if (cachedData != null) {
      return DbSuccess(cachedData);
    }

    // 2. If no cache, call API
    final result = await networkClient
        .doGet(
          '/app-api/system/notice/get-agreement',
          queryParameters: {'type': type},
        )
        .mapResponseTo<Dictionary>((json) => json)
        .toObject();

    // 3. Save to Cache if success
    if (result case DbSuccess(data: final Dictionary data)) {
      await cacheProvider.set(
        cacheKey,
        data,
        ttl: const Duration(hours: 3),
      );
    }

    return result;
  }

  /// Get announcement list by type
  /// 1=NOTICE, 2=ANNOUNCEMENT
  /// API: GET /app-api/system/notice/list
  Future<DbResult<List<Announcement>>> getAnnouncementList(int type) async {
    return await networkClient
        .doGet(
          '/app-api/system/notice/list',
          queryParameters: {'type': type},
        )
        .mapResponseTo(Announcement.fromJson)
        .toList();
  }

  /// Get announcement detail by id
  /// API: GET /app-api/system/notice/get-detail
  Future<DbResult<Announcement>> getAnnouncementDetail(int id) async {
    return await networkClient
        .doGet(
          '/app-api/system/notice/get-detail',
          queryParameters: {'id': id},
        )
        .mapResponseTo(Announcement.fromJson)
        .toObject();
  }

  /// Upload file to server
  /// API: POST /app-api/infra/file/upload
  Future<DbResult<String>> uploadFile(File file, {String directory = 'avatar'}) async {
    final uploadData = UploadData(
      fieldName: 'file',
      filePath: file.path,
      extraData: {'directory': directory},
    );

    return await networkClient
        .doUpload(
          '/app-api/infra/file/upload',
          uploadData,
        )
        .mapResponse()
        .toValue<String>();
  }
}
