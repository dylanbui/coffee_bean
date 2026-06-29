import 'package:db_core/network/network_common.dart';

// =========================================================================
// SEALED CLASS SOLUTION - DbResult / DbSuccess / DbFailure
// =========================================================================

/// Lớp kết quả Sealed Class (Adapter)
sealed class DbResult<T> {
  const DbResult();

  /// Hàm Functional xử lý 2 trường hợp (Thay thế switch)
  R when<R>({
    required R Function(T data) success,
    required R Function(NetworkError error) failure,
  }) {
    final result = this;
    return switch (result) {
      DbSuccess<T>(:final data) => success(data),
      DbFailure<T>(:final error) => failure(error),
    };
  }

  /// Chuyển đổi dữ liệu nếu thành công
  DbResult<R> map<R>(R Function(T data) transform) {
    final result = this;
    return switch (result) {
      DbSuccess<T>(:final data) => DbSuccess(transform(data)),
      DbFailure<T>(:final error) => DbFailure(error),
    };
  }

  /// Xử lý kết quả và trả về một giá trị duy nhất (tương tự when nhưng ngắn gọn hơn)
  R fold<R>(R Function(NetworkError error) failure, R Function(T data) success) {
    final result = this;
    return switch (result) {
      DbSuccess<T>(:final data) => success(data),
      DbFailure<T>(:final error) => failure(error),
    };
  }

  /// Getters tiện lợi
  bool get isSuccess => this is DbSuccess<T>;
  bool get isFailure => this is DbFailure<T>;

  T? get data => isSuccess ? (this as DbSuccess<T>).data : null;
  NetworkError? get error => isFailure ? (this as DbFailure<T>).error : null;

  T? get dataOrNull => data;
  NetworkError? get errorOrNull => error;
}

class DbSuccess<T> extends DbResult<T> {
  final T data;
  const DbSuccess(this.data);
}

class DbFailure<T> extends DbResult<T> {
  final NetworkError error;
  const DbFailure(this.error);
}
