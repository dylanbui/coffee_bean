import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:db_core/network/network_upload_response.dart';
import 'package:db_core/network/base_request.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/commons_constants.dart';

class NetworkClient {
  // region Make Constructor Class
  final Dio _dio;
  late String baseUrl = "";
  late NetworkConfig config;

  // Constructor nhận cấu hình từ bên ngoài
  NetworkClient(this.config) : _dio = Dio() {
    _dio.options.baseUrl = config.baseUrl;
    _dio.options.connectTimeout = config.timeout;
    _dio.options.receiveTimeout = config.timeout;
    // Default process JSON
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';

    // default log
    _dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: false, error: true, compact: true, maxWidth: 90));

    // Cho phép thêm các interceptor tùy biến từ dự án cụ thể
    // Same if let interceptors = config.interceptors in Swift
    if (config.interceptors case final interceptors?) {
      _dio.interceptors.addAll(interceptors);
    }
  }
  // endregion

  // region Make Call API function
  // Check Json
  Object? _tryToJson(Object other) {
    try {
      // Ép kiểu dynamic nội bộ để kiểm tra hàm toJson
      return (other as dynamic).toJson();
    } catch (_) {
      return other;
    }
  }

  // Make request data
  Object? _extractRequestData(Object? params) {
    return switch (params) {
      BaseRequest req => req.getRequestParams(),
      Dictionary map => map,
      List list => list,
      final other? => _tryToJson(other),
      _ => null,
    };
  }

  /// Do Request
  Future<Response<T>> _executeRequest<T>(String url, NetworkType type, Object? requestData, Options? options, bool isPublic) {
    // Logic GET use queryParameters, other use data
    final isGet = type == NetworkType.get;

    // Merge Options và gộp metadata 'isPublic' vào 'extra'
    // isPublic need to check in interceptor class for remove token if need
    final finalOptions = (options ?? Options()).copyWith(
      method: type.method,
      extra: {
        ...(options?.extra ?? {}), // Giữ lại các extra tùy chỉnh khác nếu có
        "isPublic": isPublic, // Đưa flag bảo mật vào đây
      },
    );

    // 2. Thực thi Request
    return _dio.request<T>(
      url,
      data: isGet ? null : requestData,
      // Cast an toàn sang Map<String, dynamic> cho QueryParams của Dio
      queryParameters: isGet && requestData is Map<String, dynamic> ? requestData : null,
      options: finalOptions,
    );
  }

  // --- NUCLEUS: Hàm thực thi gốc ---

  /// Đây là hàm trung tâm mới thay thế cho makeCall.
  /// Nó trả về Future<Response<T>> để các Extension có thể "chain" vào.
  Future<Response<T>> request<T>(String url, {NetworkType type = NetworkType.get, Object? params, Options? options, bool isPublic = false}) {
    final requestData = _extractRequestData(params);
    return _executeRequest<T>(url, type, requestData, options, isPublic);
  }

  // --- RETRY LOGIC (Dành cho Interceptor) ---
  /// Hàm này rất quan trọng cho Refresh Token logic.
  /// Tôi đã thêm xử lý để đảm bảo options được copy đúng luồng.
  Future<Response<T>> reTryConnectionWithOption<T>({required RequestOptions options}) async {
    try {
      // Sử dụng .fetch để thực hiện lại đúng chính xác Request cũ với Options mới (đã update Token)
      return await _dio.fetch<T>(options);
    } catch (e) {
      rethrow;
    }
  }

  // Handle response after call api
  // Tuple<T?, NetworkError?> _handleResponse<T>(Response<T> response) {
  //   if (response.data == null) {
  //     return Tuple(null, NetworkError(404, "Data is null"));
  //   }
  //
  //   final networkResponse = NetworkResponse.fromJson(response.data as Map<String, dynamic>);
  //   if (networkResponse.result == false) {
  //     return Tuple(null, NetworkError(int.parse(networkResponse.code), networkResponse.message));
  //   }
  //
  //   return Tuple(networkResponse.data as T, null);
  // }

  // Future<Tuple<T?, NetworkError?>> makeCall<T>(String url, {NetworkType type = NetworkType.get, Object? params, Options? options, bool isPublic = false}) async {
  //   // For public API set isPublic = true, default is FALSE
  //   try {
  //     // Data Normalization
  //     final requestData = _extractRequestData(params);
  //     // Call API
  //     final response = await _executeRequest<T>(url, type, requestData, options, isPublic);
  //     // Process response with custom logic
  //     return _handleResponse<T>(response);
  //   } on DioException catch (ex) {
  //     return Tuple(null, NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Lỗi kết nối"));
  //   } catch (e) {
  //     return Tuple(null, NetworkError(500, e.toString()));
  //   }
  // }

  // endregion
  // ---------------------------------------------------------------------

  // T only is : List, Map<String, dynamic>
  // Dung cho tat ca cac truong hop can call server Json
  // Simple call for https://jsonplaceholder.typicode.com/posts?_start=0&_limit=5
  Future<T?> simpleCall<T>(String url, {NetworkType type = NetworkType.get, Dictionary? requestData}) async {
    // Check kieu nya bi sai, tam thoi dong lai
    // if (T is! List || T is! Map<String, dynamic>) {
    //   // return const Tuple(null, DbError(500, "Cast error: T only is : List, Map<String, dynamic>")));
    //   throw Exception("Cast error: T only is : List, Map<String, dynamic>");
    // }
    try {
      Response<T> result;
      if (type == NetworkType.post) {
        result = await _dio.post<T>(url, data: requestData);
      } else {
        result = await _dio.get<T>(url);
      }
      return result.data;
    } on DioException {
      return null;
    }
  }

  Future<Response<T>> doUpload<T>(String url, UploadData uploadData) async {
    // 1. Tạo FormData linh hoạt
    final Map<String, dynamic> formDataMap = {
      if (uploadData.extraData != null) ...uploadData.extraData!,
      uploadData.fieldName: await MultipartFile.fromFile(
        uploadData.filePath,
        filename: uploadData.filePath.split('/').last, // Lấy tên file từ path
      ),
    };

    final payload = FormData.fromMap(formDataMap);

    // 2. Thực thi post (Dùng lại cấu trúc request của Dio)
    return _dio.post<T>(url, data: payload, onSendProgress: uploadData.progressCallback);
  }

/*
  // GOOD
  // https://www.topcoder.com/thrive/articles/networking-with-flutter
  Future<Tuple<UploadResult?, NetworkError?>> doUpload(String url, UploadData uploadData) async {
    // The image to be uploaded
    // final imagePath = 'path/to/image.jpg';
    // Filling the HTML form programmatically
    final payload = FormData.fromMap({
      'nickname': 'Roberto', // Them gia tri neu can
      'file': await MultipartFile.fromFile(uploadData.filePath),
    });

    try {
      // Dung cach nay cung dc, nhung xai cach duoi cho de thay
      //Response<Dictionary> result = await _dio.post(url, data: payload, onSendProgress: uploadData?.progressCallback);

      Response<Dictionary> result = await _dio.post(
        url,
        data: payload,
        onSendProgress: (sent, total) {
          // If the 'content-length' header is not sent from the server, the value
          // of 'total' will always be set to -1 so we want to make sure that the
          // progress percentage can be computed.
          if (total != -1) {}
          var callback = uploadData.progressCallback;
          if (callback != null) {
            callback(sent, total);
          }
        },
      );

      // Kiem tra result tra ve o day nhu kieu post
      final json = result.data;
      if (json != null) {
        final networkResponse = NetworkResponse.fromJson(json);
        // Kiem tra cac loi tu server tra ve va xu ly
        if (networkResponse.result == false) {
          // Cac loi tra ve tu server
          return Tuple(null, NetworkError(int.parse(networkResponse.code), networkResponse.message));
        }
        return Tuple(UploadResult.fromJson(networkResponse.data), null);
      }

      // return ve loi mac dinh
      return Tuple(null, NetworkError(4040, "result.data == NULL"));
    } on DioException catch (ex) {
      return Tuple(null, NetworkError(ex.hashCode, ex.toString()));
    } on Error catch (error) {
      return Tuple(null, NetworkError(error.hashCode, "Error : ${error.toString()}"));
    } on Exception catch (ex) {
      return Tuple(null, NetworkError(ex.hashCode, "Exception : ${ex.toString()}"));
    }
  }
*/
  // Code mau vi du sai
  // Sai khong su dung dc voi doi tuong nhu Post
  // Phai dung kieu du lieu co ban : List, Map<String, dynamic>
  //   Future<void> callPost(String url) async {
  //
  //     try {
  //       final params = {
  // //        "fromDate": fromDate,
  // //        "listingTypes": listingTypes.map((e) => e.id).toList(),
  // //        "scorecardTypes": dealScorecardTypes.map((e) => e.stringId).toList(),
  // //        "toDate": toDate,
  // //        "statusDeals": dealStatus.map((e) => e.id).toList(),
  // //         "textSearch": textSearch
  //       };
  //       Response<Post> result = await _dio.post<Post>(url, data: params,);
  //       //return handleListResponse<Deal>(result);
  //     } on DioException catch (ex) {
  //       //return handleException(ex);
  //     }
  //
  //
  //     //jsonDecode(source)
  //   }
}
