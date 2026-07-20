import 'package:coffee_bean/data/model/response/system/notify_message.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';

class SystemRepository extends BaseRepository {
  SystemRepository({super.client});

  /// Get unread site message count
  /// API: GET /app-api/system/notify-message/unread-count
  Future<DbResult<int>> getUnreadNotifyMessageCount() async {
    return await networkClient
        .doGet('/app-api/system/notify-message/unread-count')
        .mapResponse()
        .toValue<int>();
  }

  /// Get my site message page
  /// API: GET /app-api/system/notify-message/page
  Future<ResultPageType<NotifyMessage>> getNotifyMessagePage({
    bool? readStatus,
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    final queryParameters = {
      if (readStatus != null) 'readStatus': readStatus,
      'pageNo': pageNo,
      'pageSize': pageSize,
    };

    return await networkClient
        .doGet(
          '/app-api/system/notify-message/page',
          queryParameters: queryParameters,
        )
        .mapResponseToPage(NotifyMessage.fromJson)
        .toObject();
  }

  /// Mark site messages as read
  /// API: PUT /app-api/system/notify-message/read
  Future<DbResult<bool>> updateNotifyMessageRead(List<int> ids) async {
    return await networkClient
        .doPut(
          '/app-api/system/notify-message/read',
          queryParameters: {'ids': ids.join(',')},
        )
        .mapResponse()
        .toValue<bool>();
  }

  /// Mark all site messages as read
  /// API: PUT /app-api/system/notify-message/read-all
  Future<DbResult<bool>> updateAllNotifyMessageRead() async {
    return await networkClient
        .doPut('/app-api/system/notify-message/read-all')
        .mapResponse()
        .toValue<bool>();
  }

  /// Delete site messages
  /// API: PUT /app-api/system/notify-message/delete
  Future<DbResult<bool>> deleteNotifyMessage(List<int> ids) async {
    return await networkClient
        .doPut(
          '/app-api/system/notify-message/delete',
          queryParameters: {'ids': ids.join(',')},
        )
        .mapResponse()
        .toValue<bool>();
  }
}
