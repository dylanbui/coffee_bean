/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 20/4/26 - 16:25
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/network/network_common.dart';
import 'package:dio/dio.dart';

class NetworkResponse<T> {
    final String message;
    final String code;
    final bool result;
    final T? data;

    NetworkResponse({required this.message, required this.code, required this.result, this.data});

    factory NetworkResponse.fromJson(Map<String, dynamic> json, JsonMapper<dynamic> mapper) {
        final dynamic rawData = json['data'];
        dynamic parsedData;
        // Check and parse json from rawData
        if (rawData != null) {
            if (rawData is List) {
                // Tự động map nếu là List
                parsedData = rawData.map((e) => mapper(e as Map<String, dynamic>)).toList();
            } else if (rawData is Map<String, dynamic>) {
                // Parse Object đơn
                parsedData = mapper(rawData);
            }
        }
        return NetworkResponse(
            message: json['message'] ?? "",
            code: json['code']?.toString() ?? "0",
            result: json['result'] ?? false,
            data: parsedData as T?,
        );
    }
}

extension NetworkMappingProject<T> on Future<Response<T>> {

    /// Process for project-specific NetworkResponse
    /// This extension automatically checks 'result == true'
    /// If true, it returns data (List<Post>, User...).
    /// If false or network error, it returns NetworkError.
    Future<ResultType<R>> mapToNetworkResponse<R>(JsonMapper<dynamic> mapper) async {
        try {
            final response = await this;
            final rawData = response.data;

            if (rawData is Map<String, dynamic>) {
                // 1. Parse into NetworkResponse wrapper first
                final networkRes = NetworkResponse<R>.fromJson(rawData, mapper);
                // 2. Check Server business logic (result variable)
                if (networkRes.result == true) {
                    // Success: Return data (e.g., List<Post>)
                    return (data: networkRes.data, error: null);
                } else {
                    // Business error (e.g., wrong password, expired package): Return error
                    return (data: null, error: NetworkError(int.tryParse(networkRes.code) ?? 500, networkRes.message));
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

/*
// Ví dụ về một loại phản hồi khác từ bên thứ 3 hoặc dự án khác
class YourResponse<T> {
  final int errorCode;
  final T? content;

  YourResponse({required this.errorCode, this.content});

  factory YourResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) mapper) {
    return YourResponse(
      errorCode: json['errorCode'] ?? 0,
      content: json['content'] != null ? mapper(json['content']) : null,
    );
  }
}

extension NetworkMappingYourResponse<T> on Future<Response<T>> {

  /// Extension for parsing YourResponse structure (errorCode, content)
  Future<ResultType<R>> mapToYourResponse<R>(JsonMapper<dynamic> mapper) async {
    try {
      final response = await this;
      final rawData = response.data;

      if (rawData is Map<String, dynamic>) {
        // 1. Parse into YourResponse wrapper
        final yourRes = YourResponse<R>.fromJson(rawData, mapper);

        // 2. Check errorCode (Assume 0 is success)
        if (yourRes.errorCode == 0) {
          return (data: yourRes.content, error: null); // Return actual data (content)
        } else {
          // Return business error from YourResponse
          return (data: null, error: NetworkError(yourRes.errorCode, "Error from YourResponse"));
        }
      }
      return (data: null, error: NetworkError(500, "Invalid YourResponse JSON format"));
    } on DioException catch (ex) {
      return (data: null, error: NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
    } catch (e) {
      return (data: null, error: NetworkError(500, e.toString()));
    }
  }
}


*
* */

// =========================================================================
// PHIÊN BẢN MỚI: FLUENT INTERFACE CHO PROJECT-SPECIFIC WRAPPER
// (Không sửa class cũ bên trên để có thể đối chiếu, so sánh)
// =========================================================================

/// Lớp trung gian xử lý cấu trúc bọc (Wrapper) của dự án
class NetworkResponseDataMapper<T, M> {
  final Future<Response<T>> responseFuture;
  final JsonMapper<M> mapper;

  NetworkResponseDataMapper(this.responseFuture, this.mapper);

  /// Hàm nội bộ: Bóc tách vỏ bọc JSON, kiểm tra 'result' và lấy ra trường 'data'
  Future<(dynamic innerData, NetworkError? error)> _extractInnerData() async {
    try {
      final response = await responseFuture;
      final rawData = response.data;

      if (rawData is Map<String, dynamic>) {
        // Kiểm tra Server business logic theo cấu trúc dự án của bạn
        final bool result = rawData['result'] ?? false;
        final String code = rawData['code']?.toString() ?? "0";
        final String message = rawData['message'] ?? "";

        if (result == true) {
          // Thành công: Lấy trường 'data' bên trong để đưa cho Utility xử lý
          return (rawData['data'], null);
        } else {
          // Lỗi nghiệp vụ (VD: Sai mật khẩu)
          return (null, NetworkError(int.tryParse(code) ?? 500, message));
        }
      }
      return (null, NetworkError(500, "Invalid JSON wrapper format"));
    } on DioException catch (ex) {
      return (null, NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
    } catch (e) {
      return (null, NetworkError(500, e.toString()));
    }
  }

  /// Lấy trường 'data' và nhờ Utility parse thành Object
  Future<(M? data, NetworkError? error)> toObject() async {
    final (innerData, error) = await _extractInnerData();
    if (error != null) return (null, error); // Thoát sớm nếu việc bóc vỏ bị lỗi
    return NetworkParsingUtils.parseToObject(innerData, mapper);
  }

  /// Lấy trường 'data' và nhờ Utility parse thành List
  Future<(List<M>? data, NetworkError? error)> toList() async {
    final (innerData, error) = await _extractInnerData();
    if (error != null) return (null, error); // Thoát sớm nếu việc bóc vỏ bị lỗi
    return NetworkParsingUtils.parseToList(innerData, mapper);
  }
}

extension NetworkMappingProjectChaining<T> on Future<Response<T>> {
  /// Cung cấp hàm mapResponseTo() cho các API bọc cấu trúc NetworkResponse
  NetworkResponseDataMapper<T, M> mapResponseTo<M>(JsonMapper<M> mapper) {
    return NetworkResponseDataMapper<T, M>(this, mapper);
  }
}