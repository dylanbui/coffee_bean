import 'package:coffee_bean/data/model/response/hub/course_info.dart';
import 'package:coffee_bean/data/model/response/hub/course_info_detail.dart';
import 'package:coffee_bean/data/model/response/hub/instructor_info.dart';
import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:db_core/cache/cache_provider.dart';
import 'package:db_core/commons_constants.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/utils/locator.dart';

class CourseRepository extends BaseRepository with SmartFetchMixin {
  @override
  DbCacheProvider get cache => locator<DbCacheProvider>();

  CourseRepository({super.client});

  /// [Hàm mẫu dùng Smart Cache]
  /// Tự động xử lý Cache -> Network -> MD5 Check -> Emit
  Stream<dynamic> watchCourseCategories() {
    return smartFetchList<DictionaryData>(
      cacheKey: 'course_categories',
      // Truyền thẳng request từ NetworkClient (không cần parse ở đây)
      request: networkClient.doGet('/app-api/system/dict-data/type', queryParameters: {'type': 'hub_course_type'}),
      // Chỉ cần truyền hàm mapping JSON -> Model
      mapper: DictionaryData.fromJson,
    );
  }

  // --- CÁC HÀM CŨ (GIỮ NGUYÊN HOẶC CHUYỂN DẦN SANG SMART FETCH) ---

  Future<DbResult<List<DictionaryData>>> getCourseCategories() async {
    return await networkClient
        .doGet('/app-api/system/dict-data/type', queryParameters: {'type': 'hub_course_type'})
        .mapResponseTo(DictionaryData.fromJson)
        .toList();
  }

  Future<ResultPageType<CourseInfo>> getCoursePage({
    String? keyword,
    int? courseType,
    int pageNo = 1,
    int pageSize = 100,
  }) async {
    return await networkClient
        .doGet(
          '/app-api/hub/course-info/page',
          queryParameters: {
            if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
            if (courseType != null) 'courseType': courseType,
            'pageNo': pageNo,
            'pageSize': pageSize,
          },
        )
        .mapResponseToPage(CourseInfo.fromJson)
        .toObject();
  }

  Future<DbResult<CourseInfo>> getCourseById(int courseId) async {
    final cacheKey = 'course_id_$courseId';
    final cached = await cache.get<CourseInfo>(cacheKey, fromJson: (json) => CourseInfo.fromJson(json as Dictionary));
    if (cached != null) return DbSuccess(cached);

    final result = await networkClient
        .doGet('/app-api/hub/course-info/get', queryParameters: {'id': courseId})
        .mapResponseTo(CourseInfo.fromJson)
        .toObject();

    if (result case DbSuccess(data: final data)) {
      await cache.set(cacheKey, data, ttl: const Duration(hours: 1));
    }
    return result;
  }

  Future<DbResult<CourseInfoDetail>> getCourseDetailById(int courseId) async {
    final cacheKey = 'course_detail_id_$courseId';
    final cached = await cache.get<CourseInfoDetail>(cacheKey, fromJson: (json) => CourseInfoDetail.fromJson(json as Dictionary));
    if (cached != null) return DbSuccess(cached);

    final result = await networkClient
        .doGet('/app-api/hub/course-info/get', queryParameters: {'id': courseId})
        .mapResponseTo(CourseInfoDetail.fromJson)
        .toObject();

    if (result case DbSuccess(data: final data)) {
      await cache.set(cacheKey, data, ttl: const Duration(hours: 1));
    }
    return result;
  }

  Future<DbResult<InstructorInfo>> getInstructorById(int instructorId) async {
    final cacheKey = 'instructor_id_$instructorId';
    final cached = await cache.get<InstructorInfo>(cacheKey, fromJson: (json) => InstructorInfo.fromJson(json as Dictionary));
    if (cached != null) return DbSuccess(cached);

    final result = await networkClient
        .doGet('/app-api/hub/course-instructor/get', queryParameters: {'id': instructorId})
        .mapResponseTo(InstructorInfo.fromJson)
        .toObject();

    if (result case DbSuccess(data: final data)) {
      await cache.set(cacheKey, data, ttl: const Duration(hours: 1));
    }
    return result;
  }
}
