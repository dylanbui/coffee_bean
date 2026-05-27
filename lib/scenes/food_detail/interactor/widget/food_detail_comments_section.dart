import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/food_detail_interactor.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

class FoodDetailCommentsSection extends StatefulWidget {
  final FoodDetailInteractor interactor;

  const FoodDetailCommentsSection({super.key, required this.interactor});

  @override
  State<FoodDetailCommentsSection> createState() => _FoodDetailCommentsSectionState();
}

class _FoodDetailCommentsSectionState extends State<FoodDetailCommentsSection> {
  late final Widget _commentPlugin;

  @override
  void initState() {
    super.initState();
    // Khởi tạo Plugin một lần duy nhất khi Widget này được tạo ra lần đầu.
    // Điều này đảm bảo Interactor của CommentList chỉ chạy loadComments() một lần.
    final commentBuilder = CommentListBuilder(
      productId: widget.interactor.state.product.serverId,
      type: "FOOD",
    );
    _commentPlugin = commentBuilder.buildPlugin(widget.interactor.router);
  }

  @override
  Widget build(BuildContext context) {
    // Trả về instance đã được cache, tránh việc tạo lại RIB khi trang cha build lại.
    return _commentPlugin;
  }
}
