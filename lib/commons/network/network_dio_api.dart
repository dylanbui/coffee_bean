

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:coffee_bean/commons/commons_constants.dart';
import 'package:coffee_bean/commons/network/network_response.dart';
import 'package:coffee_bean/commons/network/network_common.dart';
import 'package:coffee_bean/commons/network/network_upload_response.dart';



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

  Future<ResultType<T>> makeCall<T>(String url, {NetworkType type = NetworkType.get, Dictionary? params}) async {
    try {
      Response<T> result;
      if (type == NetworkType.post) {
        result = await _dio.post<T>(url, data: params,);
      } else {
        result = await _dio.get<T>(url);
      }
      return (data: result.data as T, error: null);

    } on DioException catch (ex) {
      return (data: null, error: NetworkError(ex.hashCode, ex.toString()));
    }
  }


  // T only is : List, Map<String, dynamic>
  // Dung cho tat ca cac truong hop can call server Json
  // Simple call for https://jsonplaceholder.typicode.com/posts?_start=0&_limit=5
  Future<T?> simpleCall<T>(String url, {NetworkType type = NetworkType.get, Dictionary? params}) async {

    // Check kieu nya bi sai, tam thoi dong lai
    // if (T is! List || T is! Map<String, dynamic>) {
    //   // return const Tuple(null, BaseError("Cast error: T only is : List, Map<String, dynamic>"));
    //   throw Exception("Cast error: T only is : List, Map<String, dynamic>");
    // }

    try {
      Response<T> result;
      if (type == NetworkType.post) {
        result = await _dio.post<T>(url, data: params,);
      } else {
        result = await _dio.get<T>(url);
      }
      return result.data;
    } on DioException {
      return null;
    }
  }

  // GOOD
  // T only is : List, Map<String, dynamic>
  Future<(T?, NetworkError?)> call<T>(String url, {NetworkType type = NetworkType.get, Dictionary? params}) async {

    if (T is! List || T is! Map<String, dynamic>) {
      // return const Tuple(null, BaseError("Cast error: T only is : List, Map<String, dynamic>"));
      throw Exception("Cast error: T only is : List, Map<String, dynamic>");
    }

    try {
      Response<Dictionary> result;
      if (type == NetworkType.post) {
        result = await _dio.post(url, data: params,);
      } else {
        result = await _dio.get(url);
      }
      //TODO: Them cac load khac DELETE, PUT

      final json = result.data;
      if (json != null) {
        final networkResponse = NetworkResponse.fromJson(json);
        // Kiem tra cac loi tu server tra ve va xu ly
        if (networkResponse.result == false) {
          // Cac loi tra ve tu server
          return (null, NetworkError(int.parse(networkResponse.code), networkResponse.message));
        }
        return (networkResponse.data as T, null);
      }

      // return ve loi mac dinh
      return (null, NetworkError(4040, "result.data == NULL"));
    } on DioException catch (ex) {
      return (null, NetworkError(ex.hashCode, ex.toString()));
    } on Error catch (error) {
      return (null, NetworkError(error.hashCode, "Error : ${error.toString()}"));
    } on Exception catch (ex) {
      return (null, NetworkError(ex.hashCode, "Exception : ${ex.toString()}"));
    }
  }

  // GOOD
  // https://www.topcoder.com/thrive/articles/networking-with-flutter
  Future<(UploadResult?, NetworkError?)> doUpload(String url, UploadData uploadData) async {
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
        if (total != -1) {

        }
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
          return (null, NetworkError(int.parse(networkResponse.code), networkResponse.message));
        }
        return (UploadResult.fromJson(networkResponse.data), null);
      }

      // return ve loi mac dinh
      return (null, NetworkError(4040, "result.data == NULL"));
    } on DioException catch (ex) {
      return (null, NetworkError(ex.hashCode, ex.toString()));
    } on Error catch (error) {
      return (null, NetworkError(error.hashCode, "Error : ${error.toString()}"));
    } on Exception catch (ex) {
      return (null, NetworkError(ex.hashCode, "Exception : ${ex.toString()}"));
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
