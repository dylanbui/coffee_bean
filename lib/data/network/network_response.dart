/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 20/4/26 - 16:25
 * To change this template use File | Settings | File Templates.
 */

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
  Future<ResultType<R>> mapToNetworkResponse<R>(JsonMapper<dynamic> mapper) async {
    try {
      final response = await this;
      final rawData = response.data;

      if (rawData is Map<String, dynamic>) {
        final networkRes = NetworkResponse<R>.fromJson(rawData, mapper);
        if (networkRes.isSuccess) {
          return (data: networkRes.data, error: null);
        } else {
          return (data: null, error: NetworkError(networkRes.code, networkRes.msg));
        }
      }
      return (data: null, error: NetworkError(500, "Invalid JSON format"));
    } on DioException catch (ex) {
      return (data: null, error: NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
    } catch (e) {
      return (data: null, error: NetworkError(500, e.toString()));
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
  Future<(dynamic innerData, NetworkError? error)> _extractInnerData() async {
    try {
      final response = await responseFuture;
      final rawData = response.data;

      if (rawData is Map<String, dynamic>) {
        // Kiểm tra Server business logic theo cấu trúc mới: code == 0 là thành công
        final int code = rawData['code'] is int ? rawData['code'] : (int.tryParse(rawData['code']?.toString() ?? "-1") ?? -1);
        final String msg = rawData['msg']?.toString() ?? rawData['message']?.toString() ?? "";

        if (code == 0) {
          // Thành công: Trả về phần data bên trong
          return (rawData['data'], null);
        } else {
          // Lỗi nghiệp vụ từ Server
          return (null, NetworkError(code, msg));
        }
      }
      return (null, NetworkError(500, "Invalid JSON wrapper format"));
    } on DioException catch (ex) {
      return (null, NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
    } catch (e) {
      return (null, NetworkError(500, e.toString()));
    }
  }

  /// Parse trường 'data' thành một Object đơn
  Future<ResultType<M>> toObject() async {
    final (innerData, error) = await _extractInnerData();
    if (error != null) return (data: null, error: error);
    if (innerData == null) return (data: null, error: null);

    // Nếu là Map mới dùng mapper để bóc tách
    if (innerData is Map<String, dynamic>) {
      return NetworkParsingUtils.parseToObject(innerData, mapper);
    }

    // Nếu là kiểu Primitive (bool, int, String...) trả về trực tiếp
    try {
      return (data: innerData as M?, error: null);
    } catch (e) {
      return (data: null, error: NetworkError(500, "Type mismatch: expected $M but got ${innerData.runtimeType}"));
    }
  }

  /// Parse trường 'data' thành một Danh sách Object
  Future<ResultType<List<M>>> toList() async {
    final (innerData, error) = await _extractInnerData();
    if (error != null) return (data: null, error: error);
    return NetworkParsingUtils.parseToList(innerData, mapper);
  }

  /// Parse trường 'data' thành một giá trị Primitive (bool, int, String, double...)
  /// Đảm bảo bắt đúng kiểu dữ liệu V yêu cầu.
  Future<ResultType<V>> toValue<V>() async {
    final (innerData, error) = await _extractInnerData();
    if (error != null) return (data: null, error: error);

    if (innerData is V) {
      return (data: innerData, error: null);
    }

    if (innerData == null) {
      return (data: null, error: null);
    }

    // Trường hợp kiểu dữ liệu không khớp
    return (data: null, error: NetworkError(500, "Type mismatch: expected $V but got ${innerData.runtimeType}"));
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
}
