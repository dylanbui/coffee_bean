import 'package:coffee_bean/data/model/response/product/product_comment.dart';
import 'package:coffee_bean/data/model/response/hub/hub_comment.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:coffee_bean/scenes/comment_list/comment_constant.dart';
import 'package:db_core/db_core.dart';

abstract interface class ICommentRepository {
  Future<ResultPageType<IComment>> getCommentPage({
    required int resourceId,
    int? type, // Filter type (used for product)
    int pageNo = 1,
    int pageSize = 50,
  });

  Future<DbResult<int>> createComment({
    required int resourceId,
    required String content,
  });

  Future<DbResult<bool>> deleteComment(int id);
}

class CommentRepository extends BaseRepository {
  CommentRepository({super.client});

  ICommentRepository getSource(CommentSource source) {
    return switch (source.serverType) {
      CommentServerType.product => ProductCommentRepositoryAdapter(client: networkClient),
      CommentServerType.hub => HubCommentRepositoryAdapter(
          client: networkClient,
          commentType: source.value,
        ),
    };
  }
}

class ProductCommentRepositoryAdapter extends BaseRepository implements ICommentRepository {
  ProductCommentRepositoryAdapter({super.client});

  @override
  Future<ResultPageType<IComment>> getCommentPage({
    required int resourceId,
    int? type = 0,
    int pageNo = 1,
    int pageSize = 50,
  }) async {
    return await networkClient
        .request('/app-api/product/comment/page', params: {
          'spuId': resourceId,
          'type': type ?? 0,
          'pageNo': pageNo,
          'pageSize': pageSize,
        })
        .mapResponseToPage<IComment>(ProductComment.fromJson)
        .toObject();
  }

  @override
  Future<DbResult<int>> createComment({required int resourceId, required String content}) async {
    return DbFailure(NetworkError(501, 'Not implemented for Product'));
  }

  @override
  Future<DbResult<bool>> deleteComment(int id) async {
    return DbFailure(NetworkError(501, 'Not implemented for Product'));
  }
}

class HubCommentRepositoryAdapter extends BaseRepository implements ICommentRepository {
  final int commentType;
  HubCommentRepositoryAdapter({super.client, required this.commentType});

  @override
  Future<ResultPageType<IComment>> getCommentPage({
    required int resourceId,
    int? type,
    int pageNo = 1,
    int pageSize = 50,
  }) async {
    return await networkClient
        .doGet('/app-api/hub/comment/page', queryParameters: {
          'resourceId': resourceId,
          'commentType': commentType,
          'pageNo': pageNo,
          'pageSize': pageSize,
        })
        .mapResponseToPage<IComment>(HubComment.fromJson)
        .toObject();
  }

  @override
  Future<DbResult<int>> createComment({
    required int resourceId,
    required String content,
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

  @override
  Future<DbResult<bool>> deleteComment(int id) async {
    return await networkClient
        .doDelete('/app-api/hub/comment/delete', queryParameters: {'id': id})
        .mapResponse()
        .toValue<bool>();
  }
}
