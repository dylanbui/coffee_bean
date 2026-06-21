import 'package:coffee_bean/data/model/response/product/product_comment_response.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

class CommentListState extends BaseBlocState {
  final int productId;
  final int type; // Đổi từ String sang int theo API (0: all, 1: pos...)
  final List<ProductComment> comments;
  final bool isLoading;
  final bool isLoadMore;
  final bool hasMore;
  final int pageNo;
  final int pageSize;

  CommentListState({
    required this.productId,
    this.type = 0,
    this.comments = const [],
    this.isLoading = false,
    this.isLoadMore = false,
    this.hasMore = true,
    this.pageNo = 1,
    this.pageSize = 10,
  });

  CommentListState copyWith({
    List<ProductComment>? comments,
    bool? isLoading,
    bool? isLoadMore,
    bool? hasMore,
    int? pageNo,
    int? type,
  }) {
    return CommentListState(
      productId: productId,
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
  List<Object?> get props => [productId, type, comments, isLoading, isLoadMore, hasMore, pageNo, pageSize];
}
