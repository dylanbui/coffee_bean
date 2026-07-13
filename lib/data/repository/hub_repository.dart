import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:db_core/db_core.dart';

class HubRepository extends BaseRepository {
  HubRepository({super.client});

  /// Get hot topics (top 10)
  Future<DbResult<List<HotTopic>>> getHotTopics() async {
    return await networkClient
        .doGet('/app-api/hub/topic/index-hot-topic')
        .mapTo(HotTopic.fromJson)
        .toList();
  }

  /// Get index topic list with hotness sort
  Future<DbResult<List<HotTopic>>> getChooseTopicList() async {
    return await networkClient
        .doGet('/app-api/hub/topic/index-choose-topic')
        .mapTo(HotTopic.fromJson)
        .toList();
  }

  /// Save my followed topic tags
  Future<DbResult<bool>> saveTopicTags(List<String> tags) async {
    return await networkClient
        .doPost('/app-api/hub/expert/save-topic-tags', params: tags)
        .mapToData<bool>();
  }

  /// Get index post list by scene: RECOMMEND / FOLLOWING / TRENDING
  Future<DbResult<List<Post>>> getPostIndexList(String scene) async {
    return await networkClient
        .doGet('/app-api/hub/post/index-list', queryParameters: {'scene': scene})
        .mapTo(Post.fromJson)
        .toList();
  }

  /// Get post detail
  Future<DbResult<Map<String, dynamic>>> getPostDetail(int id) async {
    return await networkClient
        .doGet('/app-api/hub/post/get', queryParameters: {'id': id})
        .mapToData<Map<String, dynamic>>();
  }
}
