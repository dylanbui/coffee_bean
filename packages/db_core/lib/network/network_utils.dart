import 'package:db_core/network/network_common.dart';

extension ResultTypeExtension<T> on ResultType<T> {
  /// Nếu thành công, trả về dữ liệu (chắc chắn khác null).
  /// Nếu thất bại, ném ra NetworkError để khối try-catch xử lý.
  T getOrThrow() {
    if (error != null) {
      throw error!;
    }
    if (data == null) {
      throw NetworkError(500, "Dữ liệu trả về trống (Null Data)");
    }
    return data!;
  }

  /// Chuyển đổi từ Record sang Sealed Class để bóc tách an toàn hơn
  DbResult<T> toResult() {
    if (error != null) {
      return DbFailure(error!);
    }
    if (data == null) {
      return DbFailure(NetworkError(500, "Dữ liệu trả về trống"));
    }
    return DbSuccess(data!);
  }
}

// =========================================================================
// SEALED CLASS SOLUTION - DbResult / DbSuccess / DbFailure
// =========================================================================

/// Lớp kết quả Sealed Class (Adapter) bọc ngoài ResultType (Record)
sealed class DbResult<T> {
  const DbResult();

  /// Hàm Functional xử lý 2 trường hợp (Thay thế switch)
  R when<R>({
    required R Function(T data) success,
    required R Function(NetworkError error) failure,
  }) {
    if (this is DbSuccess<T>) {
      return success((this as DbSuccess<T>).data);
    } else {
      return failure((this as DbFailure<T>).error);
    }
  }

  /// Getters tiện lợi
  bool get isSuccess => this is DbSuccess<T>;
  bool get isFailure => this is DbFailure<T>;

  T? get dataOrNull => isSuccess ? (this as DbSuccess<T>).data : null;
  NetworkError? get errorOrNull => isFailure ? (this as DbFailure<T>).error : null;
}

class DbSuccess<T> extends DbResult<T> {
  final T data;
  const DbSuccess(this.data);
}

class DbFailure<T> extends DbResult<T> {
  final NetworkError error;
  const DbFailure(this.error);
}
