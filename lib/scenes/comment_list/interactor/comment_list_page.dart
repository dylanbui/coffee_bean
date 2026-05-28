import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_event_state.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_interactor.dart';
import 'package:coffee_bean/scenes/comment_list/shared/comment_item_widget.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:db_core/utils/fade_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentListPage extends AppCubitStateFulWidget<CommentListInteractor, CommentListState> {
  CommentListPage({super.key, required super.interactor});

  @override
  State<CommentListPage> createState() => _CommentListPageState();
}

class _CommentListPageState extends AppCubitState<CommentListPage, CommentListInteractor, CommentListState> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      interactor.loadMore();
    }
  }

  @override
  String? getTitle() => "TẤT CẢ ĐÁNH GIÁ";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<CommentListInteractor, CommentListState>(
      builder: (context, state) {
        return FadeSwitcher(
          duration: const Duration(milliseconds: 300),
          showFirst: state.isLoading && state.comments.isEmpty,
          first: const Center(child: CircularProgressIndicator(color: TMLabsColor.primary)),
          second: _buildMainContent(state),
        );
      },
    );
  }

  Widget _buildMainContent(CommentListState state) {
    if (state.comments.isEmpty) {
      return const Center(child: Text("Chưa có đánh giá nào"));
    }

    return RefreshIndicator(
      onRefresh: interactor.loadComments,
      color: TMLabsColor.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: state.comments.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < state.comments.length) {
            return CommentItemWidget(comment: state.comments[index]);
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(color: TMLabsColor.primary, strokeWidth: 2)),
            );
          }
        },
      ),
    );
  }
}
