/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 17/4/26 - 00:48
 * To change this template use File | Settings | File Templates.
 */

import 'package:dio/dio.dart';
import 'package:coffee_bean/commons/network/network_client.dart';
import 'package:coffee_bean/commons/commons_constants.dart';

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
    Future<(R?, NetworkError?)> mapToData<R>() async {
        try {
            final response = await this;
            return (response.data as R, null);
        } on DioException catch (ex) {
            return (null, NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
        } catch (e) {
            return (null, NetworkError(500, e.toString()));
        }
    }
    /// Xử lý lấy Data (không quan tâm vỏ NetworkResponse)
    /// mapper: Truyền vào Post.fromJson
    Future<(R?, NetworkError?)> mapToObject<R>(JsonMapper<dynamic> mapper) async {
        try {
            final response = await this;
            final rawData = response.data;
            // Check data to mapper
            if (rawData is Map<String, dynamic>) {
                final result = mapper(rawData);
                return (result as R, null);
            } else if (rawData is List) {
                // Tự động xử lý nếu data là List mà không cần hàm fromJsonList thủ công
                final list = rawData.map((e) => mapper(e as Map<String, dynamic>)).toList();
                return (list as R, null);
            }
            return (null, NetworkError(500, "Dữ liệu không đúng định dạng Map/List"));
        } on DioException catch (ex) {
            return (null, NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
        } catch (e) {
            return (null, NetworkError(500, e.toString()));
        }
    }




}


