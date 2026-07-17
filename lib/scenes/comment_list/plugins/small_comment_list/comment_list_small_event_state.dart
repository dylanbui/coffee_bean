import 'package:coffee_bean/scenes/comment_list/comment_constant.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

class CommentListSmallState extends BaseBlocState {
  final List<IComment> comments;
  final bool isLoading;

  CommentListSmallState({
    this.comments = const [],
    this.isLoading = false,
  });

  CommentListSmallState copyWith({
    List<IComment>? comments,
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
