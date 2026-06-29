

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:db_core/commons_constants.dart';
import 'package:db_core/network/network_response.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/network/network_upload_response.dart';



class NetworkDioApi {

  // region Make Singleton Class
  static final NetworkDioApi _singleton = NetworkDioApi._internal();
  factory NetworkDioApi(String? url) {

    // Update url
    if (url != null) {
      final options = BaseOptions(
        baseUrl: url,
        connectTimeout: Duration(milliseconds: 60000),
        receiveTimeout: Duration(milliseconds: 60000),
      );
      _singleton._dio.options = options;
    }

    return _singleton;
  }

  NetworkDioApi._internal() {
    /* Config Dio */
    //NetworkConfig.baseURL
    final options = BaseOptions(
      baseUrl: "",
      connectTimeout: Duration(milliseconds: 60000),
      receiveTimeout: Duration(milliseconds: 60000),
    );

    _dio = Dio(options);

    /* Add log interceptor */

    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }
  // endregion

  late Dio _dio;

  Future<List?> testCall(String url, NetworkType type) async {
    try {
      // Add header if need
      // _dio.options.headers['content-Type'] = 'application/json';
      // _dio.options.headers["authorization"] = "Bearer --String token--";

      Response<List> result = await _dio.get(url);

      log("count = + ${result.data?.length.toString()}" );

      return result.data;
    } on DioException {
      return null;
    }
  }

  Future<DbResult<T>> makeCall<T>(String url, {NetworkType type = NetworkType.get, Dictionary? params}) async {
    try {
      Response<T> result;
      if (type == NetworkType.post) {
        result = await _dio.post<T>(url, data: params);
      } else {
        result = await _dio.get<T>(url);
      }
      if (result.data == null) {
        return DbFailure(NetworkError(404, "Data is null"));
      }
      return DbSuccess(result.data as T);
    } on DioException catch (ex) {
      return DbFailure(NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
    } catch (e) {
      return DbFailure(NetworkError(500, e.toString()));
    }
  }


  // T only is : List, Map<String, dynamic>
  // Dung cho tat ca cac truong hop can call server Json
  // Simple call for https://jsonplaceholder.typicode.com/posts?_start=0&_limit=5
  Future<DbResult<T>> simpleCall<T>(String url, {NetworkType type = NetworkType.get, Dictionary? params}) async {
    try {
      Response<T> result;
      if (type == NetworkType.post) {
        result = await _dio.post<T>(url, data: params);
      } else {
        result = await _dio.get<T>(url);
      }

      if (result.data == null) {
        return DbFailure(NetworkError(404, "Data is null"));
      }
      return DbSuccess(result.data as T);
    } on DioException catch (ex) {
      return DbFailure(NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
    } catch (e) {
      return DbFailure(NetworkError(500, e.toString()));
    }
  }

  // GOOD
  // T only is : List, Map<String, dynamic>
  Future<DbResult<T>> call<T>(String url, {NetworkType type = NetworkType.get, Dictionary? params}) async {
    try {
      Response<Dictionary> result;
      if (type == NetworkType.post) {
        result = await _dio.post(url, data: params);
      } else {
        result = await _dio.get(url);
      }
      // TODO: Them cac loai khac DELETE, PUT

      final json = result.data;
      if (json != null) {
        final networkResponse = NetworkResponse.fromJson(json);
        // Kiem tra cac loi tu server tra ve va xu ly
        if (networkResponse.result == false) {
          // Cac loi tra ve tu server
          return DbFailure(NetworkError(int.tryParse(networkResponse.code) ?? 500, networkResponse.message));
        }
        return DbSuccess(networkResponse.data as T);
      }

      // return ve loi mac dinh
      return DbFailure(NetworkError(4040, "result.data == NULL"));
    } on DioException catch (ex) {
      return DbFailure(NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
    } catch (e) {
      return DbFailure(NetworkError(500, e.toString()));
    }
  }

  // GOOD
  // https://www.topcoder.com/thrive/articles/networking-with-flutter
  Future<DbResult<UploadResult>> doUpload(String url, UploadData uploadData) async {
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

      Response<Dictionary> result = await _dio.post(url, data: payload, onSendProgress: (sent, total) {
        // If the 'content-length' header is not sent from the server, the value
        // of 'total' will always be set to -1 so we want to make sure that the
        // progress percentage can be computed.
        if (total != -1) {}
        var callback = uploadData.progressCallback;
        if (callback != null) {
          callback(sent, total);
        }
      });

      // Kiem tra result tra ve o day nhu kieu post
      final json = result.data;
      if (json != null) {
        final networkResponse = NetworkResponse.fromJson(json);
        // Kiem tra cac loi tu server tra ve va xu ly
        if (networkResponse.result == false) {
          // Cac loi tra ve tu server
          return DbFailure(NetworkError(int.tryParse(networkResponse.code) ?? 500, networkResponse.message));
        }
        return DbSuccess(UploadResult.fromMap(networkResponse.data));
      }

      // return ve loi mac dinh
      return DbFailure(NetworkError(4040, "result.data == NULL"));
    } on DioException catch (ex) {
      return DbFailure(NetworkError(ex.response?.statusCode ?? 500, ex.message ?? "Error Connect"));
    } catch (e) {
      return DbFailure(NetworkError(500, e.toString()));
    }
  }

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
