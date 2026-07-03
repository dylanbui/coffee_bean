import 'package:coffee_bean/data/model/response/hub/course_info.dart';
import 'package:coffee_bean/data/model/response/hub/course_info_detail.dart';
import 'package:coffee_bean/data/model/response/hub/instructor_info.dart';
import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';

class CourseRepository extends BaseRepository {
  CourseRepository({super.client});

  Future<DbResult<List<DictionaryData>>> getCourseCategories() async {
    return await networkClient
        .doGet(
          '/app-api/system/dict-data/type',
          queryParameters: {'type': 'hub_course_type'},
        )
        .mapResponseTo(DictionaryData.fromJson)
        .toList();
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
    return await networkClient
        .doGet(
          '/app-api/hub/course-info/get',
          queryParameters: {'id': courseId},
        )
        .mapResponseTo(CourseInfo.fromJson)
        .toObject();
  }

  Future<DbResult<CourseInfoDetail>> getCourseDetailById(int courseId) async {
    return await networkClient
        .doGet(
          '/app-api/hub/course-info/get',
          queryParameters: {'id': courseId},
        )
        .mapResponseTo(CourseInfoDetail.fromJson)
        .toObject();
  }

  Future<DbResult<InstructorInfo>> getInstructorById(int instructorId) async {
    return await networkClient
        .doGet(
          '/app-api/hub/course-instructor/get',
          queryParameters: {'id': instructorId},
        )
        .mapResponseTo(InstructorInfo.fromJson)
        .toObject();
  }
}
