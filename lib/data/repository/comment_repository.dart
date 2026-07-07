import 'package:coffee_bean/data/model/response/product/product_comment.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:db_core/network/base_repository.dart';

class CommentRepository extends BaseRepository {
  CommentRepository({super.client});

  /// Lấy danh sách bình luận (phân trang) từ API
  /// Sử dụng ResultPageType alias giúp code ngắn gọn
  Future<ResultPageType<ProductComment>> getCommentPage({
    required int spuId,
    int type = 0, // 0: all, 1: positive, 2: medium, 3: negative
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    return await networkClient
        .request('/app-api/product/comment/page', params: {
          'spuId': spuId,
          'type': type,
          'pageNo': pageNo,
          'pageSize': pageSize,
        })
        .mapResponseTo((json) => PageResult.fromJson(json, (j) => ProductComment.fromJson(j as Map<String, dynamic>)))
        .toObject();
  }
}
