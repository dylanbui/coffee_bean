/*
 * Created with IntelliJ IDEA
 * Package: db_core/network
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 2024
 */

import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:db_core/cache/cache_provider.dart';
import 'package:db_core/network/network_common.dart';
import 'package:dio/dio.dart';

/// SMART CACHE SYSTEM: Định nghĩa nguồn gốc dữ liệu để UI có thể xử lý UX phù hợp
enum DataOrigin { 
  /// Dữ liệu lấy từ local storage (Instant UI)
  cache, 
  /// Dữ liệu mới nhất vừa được đồng bộ từ Server (Silent Sync)
  fresh 
}

/// Record bọc kết quả trả về gồm Dữ liệu và Nguồn gốc
typedef SmartResult<T> = (T data, DataOrigin origin);

/// Flag báo hiệu cần hiển thị trạng thái chờ (Loading) khi hoàn toàn chưa có cache
class SmartLoading {}

/// Mixin cung cấp khả năng Stale-While-Revalidate (SWR) cho Repository.
/// Tự động quản lý việc hiển thị dữ liệu từ cache và cập nhật ngầm từ network.
mixin SmartFetchMixin {
  /// Yêu cầu lớp sử dụng cung cấp một DbCacheProvider
  DbCacheProvider get cache;

  /// Tính mã hash MD5 từ chuỗi JSON để thực hiện Change Detection
  String _generateMd5(String input) => crypto.md5.convert(utf8.encode(input)).toString();

  /// HÀM CỐT LÕI: Xử lý quy trình Stale-While-Revalidate (SWR)
  /// 
  /// Quy trình hoạt động:
  /// 1. [Cache Check]: Lấy dữ liệu từ local DB phát ra ngay lập tức.
  /// 2. [Network Fetch]: Gọi API ngầm để kiểm tra dữ liệu mới nhất.
  /// 3. [Change Detection]: So sánh MD5 của Response mới với mã hash trong cache.
  /// 4. [Silent Update]: Nếu MD5 khác biệt, cập nhật DB và phát dữ liệu mới ra UI. 
  ///    Nếu MD5 giống, chỉ cập nhật thời gian sống (TTL) của cache.
  Stream<dynamic> _smartFetchInternal<T>({
    required String cacheKey,
    required Future<Response> request,
    required T Function(dynamic json) parser,
  }) async* {
    // 1. Kiểm tra và phát dữ liệu từ Cache ngay lập tức (Ưu tiên Instant UI)
    final cached = await cache.getWithMetadata<T>(cacheKey, fromJson: parser);
    String? oldHash;

    if (cached != null) {
      oldHash = cached.$2; // Giữ lại mã hash cũ để so sánh sau
      if (cached.$1 != null) {
        yield (cached.$1 as T, DataOrigin.cache);
      }
    } else {
      // CASE 1: Hoàn toàn không có cache -> Thông báo UI hiện Spinner
      yield SmartLoading();
    }

    // 2. Revalidate: Fetch dữ liệu mới từ Network ngầm
    try {
      final response = await request;
      final rawData = response.data; // Cấu trúc tiêu chuẩn: {code, msg, data}
      
      if (rawData is Map<String, dynamic>) {
        final code = rawData['code'] is int ? rawData['code'] : (int.tryParse(rawData['code']?.toString() ?? "-1") ?? -1);
        final String msg = rawData['msg']?.toString() ?? rawData['message']?.toString() ?? "";

        if (code == 0) {
          final innerData = rawData['data']; // Dữ liệu nghiệp vụ thực tế
          // Tính toán mã hash trên TOÀN BỘ body để phát hiện bất kỳ sự thay đổi nào (kể cả msg)
          final newHash = _generateMd5(jsonEncode(rawData));

          // 3. So sánh MD5: Chỉ cập nhật UI nếu dữ liệu có sự thay đổi thực sự
          if (oldHash != newHash) {
            // CASE 2: Dữ liệu mới khác biệt -> Phát tín hiệu DataOrigin.fresh
            final T data = parser(innerData);
            await cache.set(cacheKey, innerData, hash: newHash);
            yield (data, DataOrigin.fresh);
          } else {
            // Dữ liệu giống hệt -> Chỉ cập nhật lại thời gian hết hạn (TTL) giúp cache luôn tươi
            await cache.set(cacheKey, innerData, hash: newHash);
          }
        } else if (cached == null) {
          // Chỉ báo lỗi network nếu trong cache chưa có gì để hiển thị
          yield DbFailure(NetworkError(code, msg));
        }
      }
    } catch (e) {
      // Lỗi kết nối: Nếu đã có cache thì im lặng, nếu chưa có thì báo lỗi
      if (cached == null) yield DbFailure(NetworkError(500, e.toString()));
    }
  }

  /// Dùng cho danh sách (Trả về Stream<(List<M>, DataOrigin)>)
  /// Tự động parse innerData thành một List các Model M.
  Stream<dynamic> smartFetchList<M>({
    required String cacheKey,
    required Future<Response> request,
    required M Function(Map<String, dynamic> json) mapper,
  }) {
    return _smartFetchInternal<List<M>>(
      cacheKey: cacheKey,
      request: request,
      parser: (json) => NetworkParsingUtils.parseToList<M>(json, mapper).data!,
    );
  }

  /// Dùng cho đối tượng đơn (Trả về Stream<(M, DataOrigin)>)
  /// Tự động parse innerData thành một Object Model M.
  Stream<dynamic> smartFetchObject<M>({
    required String cacheKey,
    required Future<Response> request,
    required M Function(Map<String, dynamic> json) mapper,
  }) {
    return _smartFetchInternal<M>(
      cacheKey: cacheKey,
      request: request,
      parser: (json) => NetworkParsingUtils.parseToObject<M>(json, mapper).data!,
    );
  }

  /// Tiện ích gộp nhiều request chạy song song thành một kết quả duy nhất.
  /// Dùng kết hợp với smartFetchObject để cache dữ liệu tổng hợp.
  Future<Response> batch(List<Future<Response>> requests) async {
    final results = await Future.wait(requests);
    return Response(
      requestOptions: RequestOptions(), // Mock options
      data: {
        'code': 0,
        'msg': 'success',
        // Dữ liệu trả về là mảng kết quả của các API theo thứ tự truyền vào
        'data': results.map((r) => r.data).toList(),
      },
    );
  }
}
