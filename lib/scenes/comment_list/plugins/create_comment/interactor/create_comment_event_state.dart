import 'package:db_core/db_core.dart';
import 'package:equatable/equatable.dart';

class CreateCommentState extends BaseBlocState with EquatableMixin {
  final String content;
  final bool isSending;
  final DbFailure? failure;

  CreateCommentState({
    this.content = '',
    this.isSending = false,
    this.failure,
  });

  @override
  List<Object?> get props => [content, isSending, failure];

  CreateCommentState copyWith({
    String? content,
    bool? isSending,
    DbFailure? failure,
    bool clearFailure = false,
  }) {
    return CreateCommentState(
      content: content ?? this.content,
      isSending: isSending ?? this.isSending,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
