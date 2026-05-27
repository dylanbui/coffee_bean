import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

class CommentListState extends BaseBlocState {
  final int productId;
  final String type;
  final List<TblComment> comments;
  final bool isLoading;
  final bool isLoadMore;
  final bool hasMore;

  CommentListState({
    required this.productId,
    required this.type,
    this.comments = const [],
    this.isLoading = false,
    this.isLoadMore = false,
    this.hasMore = true,
  });

  CommentListState copyWith({
    List<TblComment>? comments,
    bool? isLoading,
    bool? isLoadMore,
    bool? hasMore,
  }) {
    return CommentListState(
      productId: productId,
      type: type,
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [productId, type, comments, isLoading, isLoadMore, hasMore];
}
