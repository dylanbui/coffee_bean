import 'package:coffee_bean/scenes/posts_features/post_list/interactor/post_list_event_state.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/interactor/post_list_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/widgets/post_list_item.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/search_bar.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListPage extends AppCubitStateFulWidget<PostListInteractor, PostListState> {
  PostListPage({super.key, required super.interactor});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends AppCubitState<PostListPage, PostListInteractor, PostListState> {
  @override
  String? getTitle() => "BÀI VIẾT";

  @override
   CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<PostListInteractor, PostListState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildFilterHeader(context, state),
            Expanded(child: _buildContent(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildFilterHeader(BuildContext context, PostListState state) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: TMLabsColor.bgLight, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 36,
        child: AppSearchBar(
          hintText: "Tìm kiếm bài viết",
          onSearch: interactor.onSearchChanged,
          backgroundColor: TMLabsColor.bgLight,
          borderRadius: 22,
          leftIcon: AppAssets.icons.icSearch,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PostListState state) {
    if (state.isLoading && state.posts.isEmpty) {
      return FadeSwitcher(stateKey: "getLoadingView", child: getLoadingView());
    }

    if (state.posts.isEmpty) {
      return FadeSwitcher(stateKey: "getEmptyItemView", child: getEmptyItemView(caption: "Không tìm thấy bài viết nào"));
    }

    final content = GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: state.posts.length,
      itemBuilder: (context, index) {
        final post = state.posts[index];
        return PostListItem(
          data: post,
          onTap: () => interactor.onPostTapped(post),
        );
      },
    );
    return FadeSwitcher(stateKey: "content_${state.posts.length}", child: content);
  }
}
