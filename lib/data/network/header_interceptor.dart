import 'package:dio/dio.dart';

/// Interceptor chuyên trách việc chèn các thông số cố định vào Header của mọi request
class HeaderInterceptor extends Interceptor {
  // Map chứa các headers mặc định
  final Map<String, dynamic> headers;

  HeaderInterceptor({required this.headers});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Chèn tất cả headers vào request
    options.headers.addAll(headers);

    // Tiếp tục luồng request
    return handler.next(options);
  }
}
