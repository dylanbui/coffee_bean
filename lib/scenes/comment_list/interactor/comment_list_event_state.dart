import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

class CommentListState extends BaseBlocState {
  final int productId;
  final String type;
  final List<TblComment> comments;
  final bool isLoading;
  final bool isLoadMore;
  final bool hasMore;
  final int limit;

  CommentListState({
    required this.productId,
    required this.type,
    this.comments = const [],
    this.isLoading = false,
    this.isLoadMore = false,
    this.hasMore = true,
    this.limit = 10,
  });

  CommentListState copyWith({
    List<TblComment>? comments,
    bool? isLoading,
    bool? isLoadMore,
    bool? hasMore,
    int? limit,
  }) {
    return CommentListState(
      productId: productId,
      type: type,
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      hasMore: hasMore ?? this.hasMore,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [productId, type, comments, isLoading, isLoadMore, hasMore, limit];
}
