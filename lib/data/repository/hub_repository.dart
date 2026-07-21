import 'package:coffee_bean/data/model/request/hub/create_post_request.dart';
import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/model/response/hub/post_detail.dart';
import 'package:coffee_bean/data/model/response/hub/post_status.dart';
import 'package:coffee_bean/data/model/response/hub/hub_comment.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:coffee_bean/data/model/response/hub/topic_detail.dart';
import 'package:coffee_bean/data/model/response/hub/expert_info.dart';
import 'package:coffee_bean/data/model/response/hub/user_stat.dart';
import 'package:coffee_bean/data/model/response/hub/course_info.dart';
import 'package:coffee_bean/data/model/response/hub/follower_user.dart';
import 'package:coffee_bean/data/model/response/hub/expert_apply.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:db_core/db_core.dart';

enum FavoriteType {
  venue(1),
  course(2),
  activity(3),
  post(4);

  final int value;
  const FavoriteType(this.value);
}

class HubRepository extends BaseRepository {
  HubRepository({super.client});

  /// Submit expert application
  Future<DbResult<int>> submitExpertApply(Dictionary params) async {
    return await networkClient
        .doPost('/app-api/hub/expert-apply/create', params: params)
        .mapResponse()
        .toValue<int>();
  }

  /// Get my expert application status
  Future<DbResult<ExpertApply?>> getMyExpertApply() async {
    return await networkClient
        .doGet('/app-api/hub/expert-apply/get')
        .mapResponseTo(ExpertApply.fromJson)
        .toObject();
  }

  /// Get follower list
  Future<DbResult<PageResult<FollowUser>>> getFollowerList({required int userId, int pageNo = 1, int pageSize = 20}) async {
    return await networkClient
        .doGet('/app-api/hub/follow/follower-list', queryParameters: {'userId': userId, 'pageNo': pageNo, 'pageSize': pageSize})
        .mapResponseToPage(FollowUser.fromJson)
        .toObject();
  }

  /// Get followee list (following list)
  Future<DbResult<PageResult<FollowUser>>> getFolloweeList({required int userId, int pageNo = 1, int pageSize = 20}) async {
    return await networkClient
        .doGet('/app-api/hub/follow/followee-list', queryParameters: {'userId': userId, 'pageNo': pageNo, 'pageSize': pageSize})
        .mapResponseToPage(FollowUser.fromJson)
        .toObject();
  }

  /// Get expert info
  Future<DbResult<ExpertInfo>> getExpertInfo(int? userId) async {
    return await networkClient
        .doGet('/app-api/hub/expert/get', queryParameters: userId != null ? {'userId': userId} : null)
        .mapResponseTo(ExpertInfo.fromJson)
        .toObject();
  }

  /// Get user stats
  Future<DbResult<UserStat>> getUserStat(int? userId) async {
    return await networkClient
        .doGet('/app-api/hub/user-stat/get', queryParameters: userId != null ? {'userId': userId} : null)
        .mapResponseTo(UserStat.fromJson)
        .toObject();
  }

  /// Get user's post list
  Future<DbResult<List<Post>>> getUserPosts(int? userId) async {
    return await networkClient
        .doGet('/app-api/hub/post/user-list', queryParameters: userId != null ? {'userId': userId} : null)
        .mapResponseTo(Post.fromJson)
        .toList();
  }

  /// Get user's course list
  Future<DbResult<List<CourseInfo>>> getUserCourses(int? instructorId) async {
    return await networkClient
        .doGet('/app-api/hub/course-info/user-list', queryParameters: instructorId != null ? {'instructorId': instructorId} : null)
        .mapResponseTo(CourseInfo.fromJson)
        .toList();
  }

  /// Get hot topics (top 10)
  Future<DbResult<List<HotTopic>>> getHotTopics() async {
    return await networkClient
        .doGet('/app-api/hub/topic/index-hot-topic')
        .mapResponseTo(HotTopic.fromJson)
        .toList();
  }

  /// Get index topic list with hotness sort
  Future<DbResult<List<HotTopic>>> getChooseTopicList() async {
    return await networkClient
        .doGet('/app-api/hub/topic/index-choose-topic')
        .mapResponseTo(HotTopic.fromJson)
        .toList();
  }

  /// Get topic detail
  Future<DbResult<TopicDetail>> getTopicDetail(int id) async {
    return await networkClient
        .doGet('/app-api/hub/topic/get', queryParameters: {'id': id})
        .mapResponseTo(TopicDetail.fromJson)
        .toObject();
  }

  /// Save my followed topic tags
  Future<DbResult<bool>> saveTopicTags(List<String> tags) async {
    return await networkClient
        .doPost('/app-api/hub/expert/save-topic-tags', params: tags)
        .mapResponse()
        .toValue<bool>();
  }

  /// Get my followed topic tags
  Future<DbResult<List<String>>> getMyTopicTags() async {
    final result = await networkClient
        .doGet('/app-api/hub/expert/my-topic-tags')
        .mapResponse()
        .toObject();

    if (result case DbSuccess(data: final Dictionary data)) {
      final tags = data['topicTags'] as List?;
      return DbSuccess(tags?.map((e) => e.toString()).toList() ?? []);
    }
    return DbFailure(NetworkError(500, 'Parse error'));
  }

  /// Get index post list by scene: RECOMMEND / FOLLOWING / TRENDING
  Future<DbResult<List<Post>>> getPostIndexList(String scene) async {
    return await networkClient
        .doGet('/app-api/hub/post/index-list', queryParameters: {'scene': scene})
        .mapResponseTo(Post.fromJson)
        .toList();
  }

  /// Get paginated post list
  Future<DbResult<PageResult<Post>>> getPostPage({
    String? keyword,
    String? topicName,
    String scene = "LATEST",
    int pageNo = 1,
    int pageSize = 100,
  }) async {
    final params = {
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      if (topicName != null && topicName.isNotEmpty) 'topicName': topicName,
      'scene': scene,
      'pageNo': pageNo,
      'pageSize': pageSize,
    };
    return await networkClient
        .doGet('/app-api/hub/post/page', queryParameters: params)
        .mapResponseToPage(Post.fromJson)
        .toObject();
  }

  /// Get post detail
  Future<DbResult<PostDetail>> getPostDetail(int id) async {
    return await networkClient
        .doGet('/app-api/hub/post/get', queryParameters: {'id': id})
        .mapResponseTo(PostDetail.fromJson)
        .toObject();
  }

  /// Check like/favorite/follow status by resource ID
  Future<DbResult<PostStatus>> checkPostStatus(int resourceId) async {
    return await networkClient
        .doGet('/app-api/hub/check-status/query', queryParameters: {'resourceId': resourceId})
        .mapResponseTo(PostStatus.fromJson)
        .toObject();
  }

  /// Toggle like: 1-post
  Future<DbResult<bool>> toggleLike(int resourceId, {int likeType = 1}) async {
    return await networkClient
        .doPost('/app-api/hub/like/toggle', queryParameters: {'resourceId': resourceId, 'likeType': likeType})
        .mapResponse()
        .toValue<bool>();
  }

  /// Toggle follow
  Future<DbResult<bool>> toggleFollow(int followUserId) async {
    return await networkClient
        .doPost('/app-api/hub/follow/toggle', queryParameters: {'followUserId': followUserId})
        .mapResponse()
        .toValue<bool>();
  }

  /// Toggle favorite: 1-venue 2-course 3-activity 4-post
  Future<DbResult<bool>> toggleFavorite(int targetId, {FavoriteType type = FavoriteType.venue}) async {
    return await networkClient
        .doPost('/app-api/hub/common-favorite/toggle', queryParameters: {'targetId': targetId, 'type': type.value})
        .mapResponse()
        .toValue<bool>();
  }

  /// Delete my post
  Future<DbResult<bool>> deletePost(int id) async {
    return await networkClient
        .doDelete('/app-api/hub/post/delete', queryParameters: {'id': id})
        .mapResponse()
        .toValue<bool>();
  }

  /// Create post
  Future<DbResult<int>> createPost(CreatePostRequest request) async {
    return await networkClient
        .doPost('/app-api/hub/post/create', params: request.toJson())
        .mapResponse()
        .toValue<int>();
  }

  /// Create share record: 1-post
  Future<DbResult<int>> createShareRecord(int resourceId, {int shareType = 1, String? shareChannel}) async {
    final params = {
      'resourceId': resourceId,
      'shareType': shareType,
      if (shareChannel != null) 'shareChannel': shareChannel,
    };
    return await networkClient
        .doPost('/app-api/hub/common-share/create', queryParameters: params)
        .mapResponse()
        .toValue<int>();
  }

  /// Get hub comment page by resource
  Future<DbResult<PageResult<HubComment>>> getCommentPage({
    required int resourceId,
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    return await networkClient
        .doGet('/app-api/hub/comment/page', queryParameters: {
          'resourceId': resourceId,
          'pageNo': pageNo,
          'pageSize': pageSize,
        })
        .mapResponseToPage(HubComment.fromJson)
        .toObject();
  }

  /// Create hub comment
  Future<DbResult<int>> createComment({
    required int resourceId,
    required String content,
    int commentType = 1, // 1-post
  }) async {
    return await networkClient
        .doPost('/app-api/hub/comment/create', params: {
          'resourceId': resourceId,
          'commentContent': content,
          'commentType': commentType,
        })
        .mapResponse()
        .toValue<int>();
  }

  /// Delete hub comment
  Future<DbResult<bool>> deleteComment(int id) async {
    return await networkClient
        .doDelete('/app-api/hub/comment/delete', queryParameters: {'id': id})
        .mapResponse()
        .toValue<bool>();
  }

  /// Submit report
  Future<DbResult<int>> createReport({
    required int targetType,
    required int targetId,
    required String reportReason,
  }) async {
    return await networkClient
        .doPost('/app-api/hub/report/create', params: {
          'targetType': targetType,
          'targetId': targetId,
          'reportReason': reportReason,
        })
        .mapResponse()
        .toValue<int>();
  }
}
