/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 20/4/26 - 16:25
 * To change this template use File | Settings | File Templates.
 */

import 'package:dio/dio.dart';
import 'package:coffee_bean/commons/network/network_common.dart';

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

    /// Xử lý cho NetworkResponse đặc thù của dự án
    /// Extension này sẽ tự động kiểm tra 'result == true'
    /// Nếu đúng, nó trả về data (List<Post>, User...).
    /// Nếu sai hoặc lỗi mạng, nó trả về NetworkError.
    Future<(R? data, NetworkError? error)> mapToNetworkResponse<R>(JsonMapper<dynamic> mapper) async {
        try {
            final response = await this;
            final rawData = response.data;

            if (rawData is Map<String, dynamic>) {
                // 1. Parse ra lớp vỏ NetworkResponse trước
                final networkRes = NetworkResponse<R>.fromJson(rawData, mapper);
                // 2. Kiểm tra logic nghiệp vụ của Server (biến result)
                if (networkRes.result == true) {
                    // Thành công: Trả về data (Ví dụ: List<Post>)
                    return (networkRes.data, null);
                } else {
                    // Lỗi nghiệp vụ (ví dụ: sai mật khẩu, hết hạn gói): Trả về error
                    return (null, NetworkError(int.tryParse(networkRes.code) ?? 500, networkRes.message));
                }
            }
            return (null, NetworkError(500, "Định dạng JSON không hợp lệ"));
        } on DioException catch (ex) {
            return (null, NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
        } catch (e) {
            return (null, NetworkError(500, e.toString()));
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

  /// Extension bóc tách dữ liệu cho cấu trúc YourResponse (errorCode, content)
  /// Trả về Record: (R? data, NetworkError? error)
  Future<(R? data, NetworkError? error)> mapToYourResponse<R>(JsonMapper<dynamic> mapper) async {
    try {
      final response = await this;
      final rawData = response.data;

      if (rawData is Map<String, dynamic>) {
        // 1. Parse ra lớp vỏ YourResponse
        final yourRes = YourResponse<R>.fromJson(rawData, mapper);

        // 2. Kiểm tra errorCode (Giả định 0 là thành công)
        if (yourRes.errorCode == 0) {
          return (yourRes.content, null); // Trả về data thực tế (content)
        } else {
          // Trả về lỗi nghiệp vụ từ YourResponse
          return (null, NetworkError(yourRes.errorCode, "Error from YourResponse"));
        }
      }
      return (null, NetworkError(500, "Định dạng JSON YourResponse không hợp lệ"));
    } on DioException catch (ex) {
      return (null, NetworkError(ex.response?.statusCode ?? 500, ex.message));
    } catch (e) {
      return (null, NetworkError(500, e.toString()));
    }
  }
}


*
* */