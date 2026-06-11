/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 17/4/26 - 00:48
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/commons_constants.dart';
import 'package:db_core/network/network_client.dart';
import 'package:dio/dio.dart';

export 'package:db_core/network/network_utils.dart';

typedef ResultType<T> = ({T? data, NetworkError? error});

// Define JSON parse for Object
// typedef JsonMapper<T> = T Function(dynamic json);

typedef JsonMapper<T> = T Function(Map<String, dynamic> json);

/// Safely parse a list of JSON objects into a list of models.
/// If an element fails to parse, it will be skipped instead of crashing the whole list.
List<T> parseList<T>(dynamic json, JsonMapper<T> fromJson) {
  if (json is! List || json.isEmpty) return <T>[];
  
  final List<T> result = [];
  // Lưu ý: Dart tự động tối ưu việc tăng kích thước List (exponential growth)
  // Việc check type trước khi try-catch giúp giảm chi phí CPU.
  for (final element in json) {
    if (element is Map<String, dynamic>) {
      try {
        result.add(fromJson(element));
      } catch (e) {
        // Log lỗi parse để debug nếu cần, nhưng không làm crash app
      }
    }
  }
  return result;
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

class NetworkError extends DbError {
    NetworkError(super.code, super.message);

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


    /// [M]: Kiểu đối tượng Model sinh ra từ mapper (Ví dụ: ProductModel)
    /// [R]: Kiểu dữ liệu trả về cuối cùng (Ví dụ: ProductModel hoặc List<ProductModel>)
    // Future<(R? data, NetworkError? error)> superMapToObject<R, M>(M Function(Map<String, dynamic>) mapper) async {
    Future<ResultType<R>> superMapToObject<R, M>(JsonMapper<M> mapper) async {
        try {
            final response = await this;
            final rawData = response.data;
            // Check data for mapper
            if (rawData is Map<String, dynamic>) {
                final result = mapper(rawData);
                return (data: result as R, error: null);
            } else if (rawData is List) {
                // Automatically handle if data is List without needing manual fromJsonList
                final list = rawData.map((e) => mapper(e as Map<String, dynamic>)).toList();
                return (data: list as R, error: null);
            }
            return (data: null, error: NetworkError(500, "Invalid Data format (Map/List)"));
        } on DioException catch (ex) {
            return (data: null, error: NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
        } catch (e) {
            return (data: null, error: NetworkError(500, e.toString()));
        }
    }

    Future<ResultType<R>> mapToObject<R>(R Function(Map<String, dynamic>) mapper) async {
      try {
        final response = await this;
        final rawData = response.data;
        // Check data for mapper
        if (rawData is Map<String, dynamic>) {
          final result = mapper(rawData);
          return (data: result, error: null);
        }
        return (data: null, error: NetworkError(500, "Invalid Data format (Map/List)"));
      } on DioException catch (ex) {
        return (data: null, error: NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
      } catch (e) {
        return (data: null, error: NetworkError(500, e.toString()));
      }
    }


/// Xử lý trả về một Danh sách Object
  Future<ResultType<List<R>>> mapToObjectList<R>(R Function(Map<String, dynamic>) mapper) async {
    try {
      final response = await this;
      final rawData = response.data;

      if (rawData is List) {
        // Tận dụng kiểu R rõ ràng để tạo List<R> chuẩn xác ngay từ đầu
        final list = rawData.map((e) => mapper(e as Map<String, dynamic>)).toList();
        return (data: list, error: null);
      }

      return (data: null, error: NetworkError(500, "Server không trả về List"));
    } on DioException catch (ex) {
      return (data: null, error: NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Lỗi kết nối"));
    } catch (e) {
      return (data: null, error: NetworkError(500, e.toString()));
    }
  }
    
    




}

// =========================================================================
// COMMON PARSING UTILITY (Shared for standard API and Response Wrapper)
// =========================================================================
class NetworkParsingUtils {
  /// Parse Data into an Object (includes fallback to the first element if data is a List)
  static ResultType<M> parseToObject<M>(dynamic rawData, JsonMapper<M> mapper) {
    try {
      if (rawData == null) return (data: null, error: null);
      if (rawData is Map<String, dynamic>) {
        return (data: mapper(rawData), error: null);
      } else if (rawData is List) {
        if (rawData.isNotEmpty) {
          return (data: mapper(rawData.first as Map<String, dynamic>), error: null);
        }
        return (data: null, error: NetworkError(500, "The list is empty, no first element found"));
      }
      return (data: null, error: NetworkError(500, "Invalid data format (Not Map/List)"));
    } catch (e) {
      return (data: null, error: NetworkError(500, e.toString()));
    }
  }

  /// Parse Data into a List (includes fallback to wrap Object in a List)
  static ResultType<List<M>> parseToList<M>(dynamic rawData, JsonMapper<M> mapper) {
    try {
      if (rawData == null) return (data: <M>[], error: null);
      if (rawData is List) {
        // Using the global parseList function to handle fault tolerance
        return (data: parseList(rawData, mapper), error: null);
      } else if (rawData is Map<String, dynamic>) {
        return (data: [mapper(rawData)], error: null);
      }
      return (data: null, error: NetworkError(500, "Invalid data format (Not Map/List)"));
    } catch (e) {
      return (data: null, error: NetworkError(500, e.toString()));
    }
  }
}

// =========================================================================
// FLUENT INTERFACE SOLUTION (CHAINING) - mapTo().toObject() / toList()
// =========================================================================

/// Intermediate builder class holding Future<Response> and mapper for casting
class NetworkDataMapper<T, M> {
  final Future<Response<T>> responseFuture;
  // final M Function(Map<String, dynamic>) mapper;
  final JsonMapper<M> mapper;

  NetworkDataMapper(this.responseFuture, this.mapper);

  /// Parse data into a single Object (Model)
  Future<ResultType<M>> toObject() async {
    try {
      final response = await responseFuture;
      // Call the shared Utility function
      return NetworkParsingUtils.parseToObject(response.data, mapper);
    } on DioException catch (ex) {
      return (data: null, error: NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Connection Error"));
    } catch (e) {
      return (data: null, error: NetworkError(500, e.toString()));
    }
  }

  /// Parse data into a List of Objects
  Future<ResultType<List<M>>> toList() async {
    try {
      final response = await responseFuture;
      // Call the shared Utility function
      return NetworkParsingUtils.parseToList(response.data, mapper);
    } on DioException catch (ex) {
      return (data: null, error: NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Connection Error"));
    } catch (e) {
      return (data: null, error: NetworkError(500, e.toString()));
    }
  }
}

/// Extension providing the mapTo() function to initiate chaining
extension NetworkMappingChaining<T> on Future<Response<T>> {
  /// Returns a Builder to continue calling .toObject() or .toList()
  NetworkDataMapper<T, M> mapTo<M>(M Function(Map<String, dynamic>) mapper) {
    return NetworkDataMapper<T, M>(this, mapper);
  }
}
