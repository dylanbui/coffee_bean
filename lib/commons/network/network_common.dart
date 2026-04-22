/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 17/4/26 - 00:48
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/commons_constants.dart';
import 'package:coffee_bean/commons/network/network_client.dart';
import 'package:dio/dio.dart';

typedef ResultType<T> = ({T? data, NetworkError? error});

// Define JSON parse for Object
// typedef JsonMapper<T> = T Function(dynamic json);

typedef JsonMapper<T> = T Function(Map<String, dynamic> json);

List<T> parseList<T>(dynamic json, T Function(Map<String, dynamic>) fromJson) {
    return (json as List).map((e) => fromJson(e as Map<String, dynamic>)).toList();
}

// Class configure network
class NetworkConfig {
    final String baseUrl;
    final List<Interceptor>? interceptors;
    final Duration timeout;

    NetworkConfig({
        required this.baseUrl,
        this.interceptors,
        this.timeout = const Duration(seconds: 30),
    });
}

// Class Network Provider (Quản lý NetworkClient Instance)
class NetworkServiceProvider {
    // Save instance of NetworkClient to static variable
    static NetworkClient? _instance;

    // Setup call this function at main.dart
    static void init(NetworkConfig config) {
        _instance = NetworkClient(config);
    }

    // Getter instance
    static NetworkClient get client {
        if (_instance == null) {
            throw Exception("NetworkServiceProvider chưa được khởi tạo. Hãy gọi init() trong main.dart");
        }
        return _instance!;
    }
}

enum NetworkType {
    get, post, put, delete, patch;
    String get method => name.toUpperCase();
}

class NetworkError extends BaseError {
    NetworkError(super.code, super.messenger);

    static const errorNetworkCodeUnknown = '-1000';
    static const errorNetworkCodeNoInternet = '-999';
}

extension NetworkMappingCommon<T> on Future<Response<T>> {
    /// Simple JSON (Default for API) Map {} , List<Map> [{}]
    Future<ResultType<R>> mapToData<R>() async {
        try {
            final response = await this;
            return (data: response.data as R, error: null);
        } on DioException catch (ex) {
            return (data: null, error: NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
        } catch (e) {
            return (data: null, error: NetworkError(500, e.toString()));
        }
    }

    /// Process getting Data (ignore NetworkResponse wrapper)
    /// mapper: Pass Post.fromJson
    // Future<ResultType<R>> mapToObject<R>(JsonMapper<dynamic> mapper) async {
    //     try {
    //         final response = await this;
    //         final rawData = response.data;
    //         // Check data for mapper
    //         if (rawData is Map<String, dynamic>) {
    //             final result = mapper(rawData);
    //             return (data: result as R, error: null);
    //         } else if (rawData is List) {
    //             // Automatically handle if data is List without needing manual fromJsonList
    //             final list = rawData.map((e) => mapper(e as Map<String, dynamic>)).toList();
    //             return (data: list as R, error: null);
    //         }
    //         return (data: null, error: NetworkError(500, "Invalid Data format (Map/List)"));
    //     } on DioException catch (ex) {
    //         return (data: null, error: NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
    //     } catch (e) {
    //         return (data: null, error: NetworkError(500, e.toString()));
    //     }
    // }

    Future<(R? data, NetworkError? error)> mapToObject<R>(R Function(Map<String, dynamic>) mapper) async {
      try {
        final response = await this;
        final rawData = response.data;
        // Check data for mapper
        if (rawData is Map<String, dynamic>) {
          final result = mapper(rawData);
          return (result, null);
        }
        return (null, NetworkError(500, "Invalid Data format (Map/List)"));
      } on DioException catch (ex) {
        return (null, NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
      } catch (e) {
        return (null, NetworkError(500, e.toString()));
      }
    }


/// Xử lý trả về một Danh sách Object
  Future<(List<R>? data, NetworkError? error)> mapToObjectList<R>(R Function(Map<String, dynamic>) mapper) async {
    try {
      final response = await this;
      final rawData = response.data;

      if (rawData is List) {
        // Tận dụng kiểu R rõ ràng để tạo List<R> chuẩn xác ngay từ đầu
        final list = rawData.map((e) => mapper(e as Map<String, dynamic>)).toList();
        return (list, null);
      }

      return (null, NetworkError(500, "Server không trả về List"));
    } on DioException catch (ex) {
      return (null, NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Lỗi kết nối"));
    } catch (e) {
      return (null, NetworkError(500, e.toString()));
    }
  }
    
    




}


