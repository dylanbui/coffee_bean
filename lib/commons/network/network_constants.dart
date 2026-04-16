


import 'package:coffee_bean/commons/utils/tuple.dart';
import 'package:coffee_bean/commons/commons_constants.dart';

typedef ResultType<T> = Tuple<T?, BaseError?>;

enum NetworkType {
  get, post, put, delete
}

extension NetworkTypeExtension on NetworkType {

  String get name { return "demo thoi";}


  String toValue() {
    switch (this) {
      case NetworkType.post:
        return "POST";
      case NetworkType.get:
        return "GET";
      default:
        return "-1";
    }
  }
}

class NetworkError extends BaseError {
  NetworkError(super.code, super.messenger);

  static const ERROR_NETWORK_CODE_UNKNOWN = '-1000';
  static const ERROR_NETWORK_CODE_PARSING = '-999';
}