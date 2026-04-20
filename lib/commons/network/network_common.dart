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
import 'package:coffee_bean/commons/utils/tuple.dart';
import 'package:coffee_bean/commons/commons_constants.dart';

typedef JsonMapper<T> = T Function(dynamic json);

List<T> parseList<T>(dynamic json, T Function(Map<String, dynamic>) fromJson) {
    return (json as List).map((e) => fromJson(e as Map<String, dynamic>)).toList();
}

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

typedef ResultType<T> = Tuple<T?, BaseError?>;

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
    /// Xử lý cho JSON Trần (Dùng chung cho mọi dự án)
    Future<Tuple<R?, NetworkError?>> mapToData<R>(JsonMapper<R> mapper) async {
        try {
            final response = await this;
            return Tuple(mapper(response.data), null);
        } on DioException catch (ex) {
            return Tuple(null, NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
        } catch (e) {
            return Tuple(null, NetworkError(500, e.toString()));
        }
    }
}


