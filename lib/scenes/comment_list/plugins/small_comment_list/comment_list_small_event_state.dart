import 'package:coffee_bean/data/model/response/product/product_comment_response.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

class CommentListSmallState extends BaseBlocState {
  final List<ProductComment> comments;
  final bool isLoading;

  CommentListSmallState({
    this.comments = const [],
    this.isLoading = false,
  });

  CommentListSmallState copyWith({
    List<ProductComment>? comments,
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
