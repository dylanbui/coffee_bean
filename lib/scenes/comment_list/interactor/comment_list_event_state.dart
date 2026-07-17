import 'package:coffee_bean/scenes/comment_list/comment_constant.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

class CommentListState extends BaseBlocState {
  final int resourceId;
  final CommentSource source;
  final int type; // Filter type (mostly for product)
  final List<IComment> comments;
  final bool isLoading;
  final bool isLoadMore;
  final bool hasMore;
  final int pageNo;
  final int pageSize;

  CommentListState({
    required this.resourceId,
    required this.source,
    this.type = 0,
    this.comments = const [],
    this.isLoading = false,
    this.isLoadMore = false,
    this.hasMore = true,
    this.pageNo = 1,
    this.pageSize = 10,
  });

  CommentListState copyWith({
    List<IComment>? comments,
    bool? isLoading,
    bool? isLoadMore,
    bool? hasMore,
    int? pageNo,
    int? type,
  }) {
    return CommentListState(
      resourceId: resourceId,
      source: source,
      type: type ?? this.type,
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      hasMore: hasMore ?? this.hasMore,
      pageNo: pageNo ?? this.pageNo,
      pageSize: pageSize,
    );
  }

  @override
  List<Object?> get props => [resourceId, source, type, comments, isLoading, isLoadMore, hasMore, pageNo, pageSize];
}
