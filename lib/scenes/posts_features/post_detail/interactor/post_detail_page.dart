import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/posts_features/post_detail/interactor/post_detail_event_state.dart';
import 'package:coffee_bean/scenes/posts_features/post_detail/interactor/post_detail_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/share_action/share_poster_dialog.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:coffee_bean/shared/widget/image_slider_widget.dart';
import 'package:coffee_bean/utils/extensions.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class PostDetailPage extends AppCubitStateFulWidget<PostDetailInteractor, PostDetailState> {
  PostDetailPage({super.key, required super.interactor});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends AppCubitState<PostDetailPage, PostDetailInteractor, PostDetailState> {
  @override
  bool get tapToUnfocus => true;

  DbNoteBuilder? _commentPlugin;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<PostDetailInteractor, PostDetailState>(
      builder: (context, state) {
        final post = state.post;
        final bool isLoading = state.isLoading && post == null;

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildCustomAppBar(post, isLoading),
              Expanded(
                child: FadeSwitcher(
                  stateKey: isLoading ? 'loading' : (post == null ? 'empty' : 'content_${post.id}'),
                  child: isLoading
                      ? _PostDetailShimmer.buildContent()
                      : (post == null
                          ? getEmptyItemView(caption: "Không tìm thấy bài viết")
                          : _buildMainScrollContent(post)),
                ),
              ),
              _buildFooter(post, isLoading),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainScrollContent(PostModel post) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title, style: TMLabsTextStyle.h2),
                if (post.hashtags != null && post.hashtags!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: post.hashtags!
                        .map(
                          (tag) => Text(
                            tag,
                            style: TMLabsTextStyle.body.copyWith(color: Colors.blue, fontSize: 13),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 16),
                if (post.images != null && post.images!.isNotEmpty)
                  context.imageSlider(
                    images: post.images!,
                    height: 240,
                    borderRadius: 16,
                    indicatorType: ImageSliderIndicatorType.dots,
                  ),
                const SizedBox(height: 16),
                Html(data: post.contentHtml, style: TMLabsTextStyle.htmlStyle),
                const SizedBox(height: 16),
                Row(
                  children: [
                    AppButton(
                      text: "Báo cáo",
                      width: 100,
                      height: 32,
                      style: TMLabsButtonStyle.outline.copyWith(borderRadius: 8),
                      onPressed: () => interactor.reportPost(),
                    ),
                    const Spacer(),
                    Text(
                      "${post.readCount.formatCompact()} lượt đọc",
                      style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: Container(height: 8, color: TMLabsColor.bgLight)),
        SliverToBoxAdapter(child: _buildCommentHeader(post)),
        SliverToBoxAdapter(child: _buildCommentPlugin(post)),
      ],
    );
  }


  Widget _buildCustomAppBar(PostModel? post, bool isLoading) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 8, left: 8, right: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: TMLabsColor.bgLight, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => interactor.router?.pop()),
          if (isLoading || post == null)
            Expanded(child: _PostDetailShimmer.buildAppBar())
          else ...[
            AvatarWidget(imageUrl: post.authorAvatar, size: 40),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.authorName, style: TMLabsTextStyle.bodyBold.copyWith(color: TMLabsColor.primary)),
                  Text(post.date, style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey)),
                ],
              ),
            ),
            TapEffect(
              onTap: () => interactor.toggleFollow(),
              child: AppLabel(
                post.isFollowing ? "Đã theo dõi" : "Theo dõi",
                backgroundColor: post.isFollowing ? TMLabsColor.primary : TMLabsColor.bgLight,
                style: TMLabsTextStyle.caption.copyWith(
                  color: post.isFollowing ? Colors.white : TMLabsColor.primary,
                  fontWeight: FontWeight.w600,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                borderRadius: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentHeader(PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Text("Bình luận", style: TMLabsTextStyle.title),
          const SizedBox(width: 4),
          Text(post.commentCount.formatCompact(), style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey)),
          const Spacer(),
          Text(post.likeCount.formatCompact(), style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey)),
          const SizedBox(width: 4),
          Text("Lượt thích", style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey)),
        ],
      ),
    );
  }

  Widget _buildCommentPlugin(PostModel post) {
    _commentPlugin ??= CommentListBuilder(productId: post.id, type: 0);
    return (_commentPlugin as CommentListBuildable).buildPlugin(5, interactor.commentController);
  }

  Widget _buildFooter(PostModel? post, bool isLoading) {
    return IgnorePointer(
      ignoring: isLoading || post == null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isLoading || post == null ? 0.5 : 1.0,
        child: Container(
          height: 50 + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: TMLabsColor.bgLight, width: 1)),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _buildFooterButton(AppAssets.icons.icComment, "Bình luận", onTap: () {})),
                _buildDivider(),
                Expanded(
                  child: _buildFooterButton(
                    (post?.isLiked ?? false) ? Icons.thumb_up : AppAssets.icons.icLike,
                    "Thích",
                    color: (post?.isLiked ?? false) ? TMLabsColor.primary : null,
                    onTap: () => interactor.toggleLike(),
                  ),
                ),
                _buildDivider(),
                Expanded(
                  child: _buildFooterButton(
                    (post?.isSaved ?? false) ? Icons.favorite : Icons.favorite_border,
                    "Lưu",
                    color: (post?.isSaved ?? false) ? TMLabsColor.primary : null,
                    size: 26,
                    onTap: () => interactor.toggleSave(),
                  ),
                ),
                _buildDivider(),
                Expanded(
                  child: _buildFooterButton(
                    AppAssets.icons.icShare,
                    "Chia sẻ",
                    onTap: () {
                      if (post == null) return;
                      SharePosterDialog.show(
                        context: context,
                        imageUrl: post.images?.firstOrNull ?? post.authorAvatar,
                        title: post.title,
                        shareLink: "https://coffeebean.com/post/${post.id}", // Fake link
                        subTitle: "Bởi ${post.authorName}",
                        shareText: "Xem bài viết thú vị này trên Coffee Bean: ${post.title}",
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 18, color: TMLabsColor.grey.withValues(alpha: 0.3));
  }

  Widget _buildFooterButton(dynamic icon, String label, {Color? color, VoidCallback? onTap, double? size}) {
    return TapEffect(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(icon, size: size ?? 20, color: color ?? TMLabsColor.grey),
          const SizedBox(width: 8),
          Text(
            label,
            style: TMLabsTextStyle.small.copyWith(
              color: color ?? TMLabsColor.grey,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostDetailShimmer {
  static Widget buildAppBar() {
    return Row(
      children: [
        _buildBlock(width: 40, height: 40, borderRadius: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBlock(width: 120, height: 16),
              const SizedBox(height: 4),
              _buildBlock(width: 80, height: 12),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildContent() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBlock(width: double.infinity, height: 28),
              const SizedBox(height: 8),
              _buildBlock(width: 200, height: 20),
              const SizedBox(height: 24),
              _buildBlock(width: double.infinity, height: 500, borderRadius: 16),
              const SizedBox(height: 24),
              _buildBlock(width: double.infinity, height: 40),
              const SizedBox(height: 24),
              _buildBlock(width: double.infinity, height: 40),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildBlock(width: 80, height: 32, borderRadius: 8),
                  const Spacer(),
                  _buildBlock(width: 100, height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildBlock({required double width, required double height, double borderRadius = 4}) {
    return Shimmer.fromColors(
      baseColor: TMLabsColor.bgLight,
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
