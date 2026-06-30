/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 20/4/26 - 16:25
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/data/network/page_result.dart';
import 'package:db_core/network/network_common.dart';
import 'package:dio/dio.dart';

/// Lớp bọc phản hồi tiêu chuẩn của dự án (Project Standard Wrapper)
/// Cấu trúc: { "code": 0, "msg": "", "data": ... }
class NetworkResponse<T> {
  final String msg;
  final int code;
  final T? data;

  NetworkResponse({required this.msg, required this.code, this.data});

  /// Kiểm tra xem phản hồi có thành công theo nghiệp vụ không (code == 0)
  bool get isSuccess => code == 0;

  factory NetworkResponse.fromJson(Map<String, dynamic> json, JsonMapper<dynamic> mapper) {
    final dynamic rawData = json['data'];
    dynamic parsedData;

    // Sử dụng logic parseList an toàn để xử lý data là List
    // Tránh lỗi crash khi map dynamic trực tiếp
    if (rawData != null) {
      if (rawData is List) {
        parsedData = parseList(rawData, mapper);
      } else if (rawData is Map<String, dynamic>) {
        parsedData = mapper(rawData);
      } else {
        // Hỗ trợ các kiểu dữ liệu cơ bản: bool, int, String...
        parsedData = rawData;
      }
    }

    return NetworkResponse(
      msg: json['msg']?.toString() ?? json['message']?.toString() ?? "",
      code: json['code'] is int ? json['code'] : (int.tryParse(json['code']?.toString() ?? "0") ?? 0),
      data: parsedData as T?,
    );
  }
}

extension NetworkMappingProject<T> on Future<Response<T>> {
  /// Xử lý phản hồi theo cấu trúc NetworkResponse cũ/tương thích ngược
  /// Khuyến khích sử dụng mapResponseTo().toObject() thay thế
  Future<DbResult<R>> mapToNetworkResponse<R>(JsonMapper<dynamic> mapper) async {
    try {
      final response = await this;
      final rawData = response.data;

      if (rawData is Map<String, dynamic>) {
        final networkRes = NetworkResponse<R>.fromJson(rawData, mapper);
        if (networkRes.isSuccess) {
          final data = networkRes.data;
          if (data == null) {
            return DbFailure(NetworkError(500, "Dữ liệu trả về trống"));
          }
          return DbSuccess(data);
        } else {
          return DbFailure(NetworkError(networkRes.code, networkRes.msg));
        }
      }
      return DbFailure(NetworkError(500, "Invalid JSON format"));
    } on DioException catch (ex) {
      return DbFailure(NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
    } catch (e) {
      return DbFailure(NetworkError(500, e.toString()));
    }
  }
}

// =========================================================================
// PHIÊN BẢN FLUENT INTERFACE CHO PROJECT WRAPPER (RECOMMENDED)
// =========================================================================

/// Lớp trung gian xử lý cấu trúc bọc {code, msg, data}
class NetworkResponseDataMapper<T, M> {
  final Future<Response<T>> responseFuture;
  final JsonMapper<M> mapper;

  NetworkResponseDataMapper(this.responseFuture, this.mapper);

  /// Hàm nội bộ: Bóc tách vỏ bọc JSON, kiểm tra 'code' và lấy ra trường 'data'
  Future<DbResult<dynamic>> _extractInnerData() async {
    try {
      final response = await responseFuture;
      final rawData = response.data;

      if (rawData is Map<String, dynamic>) {
        // Kiểm tra Server business logic theo cấu trúc mới: code == 0 là thành công
        final int code = rawData['code'] is int ? rawData['code'] : (int.tryParse(rawData['code']?.toString() ?? "-1") ?? -1);
        final String msg = rawData['msg']?.toString() ?? rawData['message']?.toString() ?? "";

        if (code == 0) {
          // Thành công: Trả về phần data bên trong
          return DbSuccess(rawData['data']);
        } else {
          // Lỗi nghiệp vụ từ Server
          return DbFailure(NetworkError(code, msg));
        }
      }
      return DbFailure(NetworkError(500, "Invalid JSON wrapper format"));
    } on DioException catch (ex) {
      return DbFailure(NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
    } catch (e) {
      return DbFailure(NetworkError(500, e.toString()));
    }
  }

  /// Parse trường 'data' thành một Object đơn
  Future<DbResult<M>> toObject() async {
    final result = await _extractInnerData();
    if (result case DbFailure(:final error)) return DbFailure(error);
    final innerData = result.dataOrNull;
    if (innerData == null) return DbFailure(NetworkError(500, "Dữ liệu trả về trống"));

    // Nếu là Map mới dùng mapper để bóc tách
    if (innerData is Map<String, dynamic>) {
      return NetworkParsingUtils.parseToObject(innerData, mapper);
    }

    // Nếu là kiểu Primitive (bool, int, String...) trả về trực tiếp
    try {
      return DbSuccess(innerData as M);
    } catch (e) {
      return DbFailure(NetworkError(500, "Type mismatch: expected $M but got ${innerData.runtimeType}"));
    }
  }

  /// Parse trường 'data' thành một Danh sách Object
  Future<DbResult<List<M>>> toList() async {
    final result = await _extractInnerData();
    if (result case DbFailure(:final error)) return DbFailure(error);
    return NetworkParsingUtils.parseToList(result.dataOrNull, mapper);
  }

  /// Parse trường 'data' thành một giá trị Primitive (bool, int, String, double...)
  /// Đảm bảo bắt đúng kiểu dữ liệu V yêu cầu.
  Future<DbResult<V>> toValue<V>() async {
    final result = await _extractInnerData();
    if (result case DbFailure(:final error)) return DbFailure(error);
    final innerData = result.dataOrNull;

    if (innerData is V) {
      return DbSuccess(innerData);
    }

    if (innerData == null) {
      return DbFailure(NetworkError(500, "Dữ liệu trả về trống"));
    }

    // Trường hợp kiểu dữ liệu không khớp
    return DbFailure(NetworkError(500, "Type mismatch: expected $V but got ${innerData.runtimeType}"));
  }
}

extension NetworkMappingProjectChaining<T> on Future<Response<T>> {
  /// Bắt đầu chuỗi xử lý cho các API có bọc cấu trúc {code, msg, data}
  NetworkResponseDataMapper<T, M> mapResponseTo<M>(JsonMapper<M> mapper) {
    return NetworkResponseDataMapper<T, M>(this, mapper);
  }

  /// Khởi tạo chuỗi xử lý API mà không cần mapper (dùng khi data trả về kiểu cơ bản)
  NetworkResponseDataMapper<T, dynamic> mapResponse() {
    return NetworkResponseDataMapper<T, dynamic>(this, (json) => json);
  }

  /// Bắt đầu chuỗi xử lý cho các API phân trang có cấu trúc {code, msg, data: { total, list: [] }}
  NetworkResponseDataMapper<T, PageResult<M>> mapResponseToPage<M>(JsonMapper<M> mapper) {
    return NetworkResponseDataMapper<T, PageResult<M>>(this, (json) {
      return PageResult<M>.fromJson(json, (j) => mapper(j as Map<String, dynamic>),);
    });
  }
}
