import 'package:db_core/network/network_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page_result.g.dart';

/// Kiểu rút gọn (Alias) cho kết quả API phân trang
/// Thay vì viết: Future<DbResult<PageResult<T>>>
/// Bạn chỉ cần viết: Future<ResultPageType<T>>
typedef ResultPageType<T> = DbResult<PageResult<T>>;

@JsonSerializable(genericArgumentFactories: true)
class PageResult<T> {
  final int total;
  final List<T> list;

  PageResult({required this.total, required this.list});

  factory PageResult.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PageResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PageResultToJson(this, toJsonT);
}
