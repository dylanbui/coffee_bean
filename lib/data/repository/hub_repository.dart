import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:coffee_bean/data/model/response/hub/topic_detail.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:db_core/db_core.dart';

class HubRepository extends BaseRepository {
  HubRepository({super.client});

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
}
