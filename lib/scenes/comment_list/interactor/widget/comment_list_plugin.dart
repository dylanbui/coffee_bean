import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_event_state.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_interactor.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/widget/comment_item_widget.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentListPlugin extends AppCubitStateFulWidget<CommentListInteractor, CommentListState> {
  CommentListPlugin({super.key, required super.interactor});

  @override
  State<CommentListPlugin> createState() => _CommentListPluginState();
}

class _CommentListPluginState extends AppCubitState<CommentListPlugin, CommentListInteractor, CommentListState> {
  
  @override
  String? getTitle() => null; // Plugin không có AppBar riêng

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    // Quan trọng: Plugin không được dùng Scaffold vì nó sẽ được nhúng vào ScrollView của trang cha.
    // Trả về trực tiếp body để tránh lỗi "Infinite height"
    return body;
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<CommentListInteractor, CommentListState>(
      builder: (context, state) {
        final comments = state.comments;

        if (state.isLoading && comments.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: TMLabsColor.primary),
            ),
          );
        }

        if (comments.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Đánh giá", style: TMLabsTextStyle.h2),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "Chưa có đánh giá nào cho sản phẩm này",
                    style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Đánh giá", style: TMLabsTextStyle.h2),
                  TextButton(
                    onPressed: () => interactor.onViewAll(),
                    child: Row(
                      children: [
                        Text("Tất cả", style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey)),
                        const Icon(Icons.chevron_right, size: 20, color: TMLabsColor.grey),
                      ],
                    ),
                  ),
                ],
              ),
              ...comments.map((comment) => CommentItemWidget(comment: comment)),
            ],
          ),
        );
      },
    );
  }
}
