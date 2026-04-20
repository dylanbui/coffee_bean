


import 'package:coffee_bean/commons/utils/tuple.dart';
import 'package:coffee_bean/commons/commons_constants.dart';

// Dont use this

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