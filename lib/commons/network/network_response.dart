

// import 'package:json_annotation/json_annotation.dart';

// part 'network_reponse.g.dart';
//
// @JsonSerializable()
// class NetworkResponse {
//   bool result;
//   String code;
//   String message;
//
//   // @JsonKey(ignore: true)
//   // Map<String, dynamic> data;
//
//   @JsonKey(ignore: true)
//   dynamic data;
//
//   // NetworkResponse(this.result, this.code, this.message);
//
//   factory NetworkResponse.fromJson(Map<String, dynamic> json) => _$NetworkResponseFromJson(json);
//
//   Map<String, dynamic> toJson() => _$NetworkResponseToJson(this);
//
//   // @override
//   // String toString() => '$code - $message';
// }

class NetworkResponse {
  final bool result;
  final String code;
  final String message;

  final Map<String, dynamic> data;
  // final dynamic data;
  // final Object data;

  const NetworkResponse({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory NetworkResponse.fromJson(Map < String, dynamic > json) {
    return NetworkResponse(
      result: json['result'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      data: json['data'],
    );
  }
}