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

class CourseRepository extends BaseRepository {
  DbCacheProvider get _cache => locator<DbCacheProvider>();

  CourseRepository({super.client});

  Future<DbResult<List<DictionaryData>>> getCourseCategories() async {
    const cacheKey = 'course_categories';

    final cachedData = await _cache.get<List<DictionaryData>>(cacheKey,
      fromJson: (json) => (json as List).map((e) => DictionaryData.fromJson(e as Dictionary)).toList(),
    );
    if (cachedData != null) return DbSuccess(cachedData);

    final result = await networkClient
        .doGet('/app-api/system/dict-data/type', queryParameters: {'type': 'hub_course_type'})
        .mapResponseTo(DictionaryData.fromJson)
        .toList();

    if (result case DbSuccess(data: final list)) {
      await _cache.set(cacheKey, list, ttl: const Duration(hours: 1));
    }

    return result;
  }

  Future<ResultPageType<CourseInfo>> getCoursePage({
    String? keyword,
    int? courseType,
    int pageNo = 1,
    int pageSize = 100, // Load more as possible since UI doesn't have load more yet
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

    final cached = await _cache.get<CourseInfo>(cacheKey, fromJson: (json) => CourseInfo.fromJson(json as Dictionary));
    if (cached != null) return DbSuccess(cached);

    final result = await networkClient
        .doGet('/app-api/hub/course-info/get', queryParameters: {'id': courseId})
        .mapResponseTo(CourseInfo.fromJson)
        .toObject();

    if (result case DbSuccess(data: final data)) {
      await _cache.set(cacheKey, data, ttl: const Duration(hours: 1));
    }
    return result;
  }

  Future<DbResult<CourseInfoDetail>> getCourseDetailById(int courseId) async {
    final cacheKey = 'course_detail_id_$courseId';

    final cached = await _cache.get<CourseInfoDetail>(
      cacheKey,
      fromJson: (json) => CourseInfoDetail.fromJson(json as Dictionary),
    );
    if (cached != null) return DbSuccess(cached);

    final result = await networkClient
        .doGet('/app-api/hub/course-info/get', queryParameters: {'id': courseId})
        .mapResponseTo(CourseInfoDetail.fromJson)
        .toObject();

    if (result case DbSuccess(data: final data)) {
      await _cache.set(cacheKey, data, ttl: const Duration(hours: 1));
    }
    return result;
  }

  Future<DbResult<InstructorInfo>> getInstructorById(int instructorId) async {
    final cacheKey = 'instructor_id_$instructorId';

    final cached = await _cache.get<InstructorInfo>(
      cacheKey,
      fromJson: (json) => InstructorInfo.fromJson(json as Dictionary),
    );
    if (cached != null) return DbSuccess(cached);

    final result = await networkClient
        .doGet('/app-api/hub/course-instructor/get', queryParameters: {'id': instructorId})
        .mapResponseTo(InstructorInfo.fromJson)
        .toObject();

    if (result case DbSuccess(data: final data)) {
      await _cache.set(cacheKey, data, ttl: const Duration(hours: 1));
    }
    return result;
  }
}
