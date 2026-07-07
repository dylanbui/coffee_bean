import 'package:coffee_bean/data/model/response/hub/activity_info.dart';
import 'package:coffee_bean/data/model/response/hub/activity_info_detail.dart';
import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/network/network_response.dart';

class ActivityRepository extends BaseRepository {
  ActivityRepository({super.client});

  Future<DbResult<List<DictionaryData>>> getActivityCategories() async {
    return await networkClient
        .doGet('/app-api/system/dict-data/type', queryParameters: {'type': 'hub_activity_type'})
        .mapResponseTo(DictionaryData.fromJson)
        .toList();
  }

  Future<ResultPageType<ActivityInfo>> getActivityPage({
    String? keyword,
    int? activityType,
    int pageNo = 1,
    int pageSize = 100,
  }) async {
    return await networkClient
        .doGet(
          '/app-api/hub/activity-info/page',
          queryParameters: {
            if (keyword != null && keyword.isNotEmpty) 'name': keyword,
            if (activityType != null) 'activityType': activityType,
            'pageNo': pageNo,
            'pageSize': pageSize,
          },
        )
        .mapResponseToPage(ActivityInfo.fromJson)
        .toObject();
  }

  Future<DbResult<ActivityInfoDetail>> getActivityById(int activityId) async {
    return await networkClient
        .doGet('/app-api/hub/activity-info/get', queryParameters: {'id': activityId})
        .mapResponseTo(ActivityInfoDetail.fromJson)
        .toObject();
  }

}
