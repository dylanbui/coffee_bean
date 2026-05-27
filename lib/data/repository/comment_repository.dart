import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/utils/locator.dart';

class CommentRepository {
  final DatabaseService _dbService = locator<DatabaseService>();

  /// Lấy danh sách comment cho sản phẩm (Food hoặc Course)
  /// Hỗ trợ cơ chế Cache-Aside: 
  /// 1. Nếu cache hợp lệ -> Lấy từ Isar
  /// 2. Nếu cache hết hạn -> Giả lập gọi API (đọc file JSON) -> Lưu Isar -> Trả về kết quả
  Future<List<TblComment>> getComments({
    required int productId,
    required String type,
    int offset = 0,
    int limit = 10,
  }) async {
    return await _dbService.getCommentsWithProduct(
      productId: productId,
      type: type,
      offset: offset,
      limit: limit,
      remoteFetcher: () async {
        // Giả lập gọi API bằng cách đọc file JSON local
        final String response = await rootBundle.loadString('assets/json/sample_comment.json');
        final List<dynamic> data = json.decode(response);
        return data;
      },
    );
  }
}
