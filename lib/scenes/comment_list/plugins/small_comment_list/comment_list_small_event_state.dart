import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

class CommentListSmallState extends BaseBlocState {
  final List<TblComment> comments;
  final bool isLoading;

  CommentListSmallState({
    this.comments = const [],
    this.isLoading = false,
  });

  CommentListSmallState copyWith({
    List<TblComment>? comments,
    bool? isLoading,
  }) {
    return CommentListSmallState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [comments, isLoading];
}
