import 'package:coffee_bean/data/model/response/hub/feedback_info.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:db_core/commons_constants.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/network/network_response.dart';

class FeedbackRepository extends BaseRepository {
  FeedbackRepository({super.client});

  /// Gửi phản hồi
  /// API: POST /app-api/hub/feedback/create
  Future<DbResult<int>> createFeedback({
    required String content,
    List<String> images = const [],
  }) async {
    final Dictionary postData = {
      'feedbackContent': content,
    };

    // Ánh xạ danh sách ảnh vào các key feedbackImg1 -> feedbackImg5
    for (int i = 0; i < images.length && i < 5; i++) {
      postData['feedbackImg${i + 1}'] = images[i];
    }

    return await networkClient
        .request(
          '/app-api/hub/feedback/create',
          type: NetworkType.post,
          params: postData,
        )
        .mapResponse()
        .toValue<int>();
  }

  /// Lấy danh sách phản hồi của tôi
  /// API: GET /app-api/hub/feedback/page-my
  Future<ResultPageType<FeedbackInfo>> getMyFeedbacks({int pageNo = 1, int pageSize = 100,}) async {
    return await networkClient
        .request(
          '/app-api/hub/feedback/page-my',
          type: NetworkType.get,
          params: {
            'pageNo': pageNo,
            'pageSize': pageSize,
          },
        )
        .mapResponseToPage(FeedbackInfo.fromJson)
        .toObject();
  }

  /// Lấy chi tiết phản hồi
  /// API: GET /app-api/hub/feedback/get
  Future<DbResult<FeedbackInfo>> getFeedbackDetail(int id) async {
    return await networkClient
        .request(
          '/app-api/hub/feedback/get',
          type: NetworkType.get,
          params: {'id': id},
        )
        .mapResponseTo<FeedbackInfo>(FeedbackInfo.fromJson)
        .toObject();
  }
}
