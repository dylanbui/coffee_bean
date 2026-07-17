import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/plugins/post_card_list/post_card_list_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_list/plugins/post_card_list/post_card_list_state_event.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:coffee_bean/utils/extensions.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCardListWidget extends AppCubitStateFulWidget<PostCardListInteractor, PostCardListState> {
  PostCardListWidget({super.key, required super.interactor});

  @override
  State<PostCardListWidget> createState() => _PostCardListWidgetState();
}

class _PostCardListWidgetState extends AppCubitState<PostCardListWidget, PostCardListInteractor, PostCardListState> {
  
  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    // Plugin không được dùng Scaffold vì nó sẽ được nhúng vào ScrollView của trang cha.
    return body;
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<PostCardListInteractor, PostCardListState>(
      builder: (context, state) {
        if (state.isLoading && state.posts.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.posts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(AppStrings.posts, style: TMLabsTextStyle.h1),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return _PostCardItem(
                  item: state.posts[index],
                  onPostTapped: interactor.onPostTapped,
                  onShareTapped: interactor.onShareTapped,
                  onCommentTapped: (post) => interactor.onPostTapped(post),
                  onLikeTapped: interactor.onLikeTapped,
                  onFollowTapped: interactor.onFollowTapped,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _PostCardItem extends StatelessWidget {
  final Post item;
  final Function(Post) onPostTapped;
  final Function(Post) onShareTapped;
  final Function(Post) onCommentTapped;
  final Function(Post) onLikeTapped;
  final Function(Post) onFollowTapped;

  const _PostCardItem({
    required this.item,
    required this.onPostTapped,
    required this.onShareTapped,
    required this.onCommentTapped,
    required this.onLikeTapped,
    required this.onFollowTapped,
  });

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: () => onPostTapped(item),
      child: Container(
        height: 395,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: TMLabsColor.bgLight, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TapEffect(
                  onTap: () => {},
                  child: AvatarWidget(
                      imageUrl: item.userAvatar, size: 40, backgroundColor: TMLabsColor.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.userNickname ?? "",
                        style: TMLabsTextStyle.bodyBold,
                      ),
                      Text(
                        "${AppStrings.postedOn} ${item.displayCreateTime}",
                        style: TMLabsTextStyle.small.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  text: AppStrings.follow,
                  onPressed: () => onFollowTapped(item),
                  style: TMLabsButtonStyle.primary.copyWith(
                    backgroundColor: const Color(0xFFA6B5C5),
                    height: 32,
                    textStyle: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.postTitle ?? "",
              style: TMLabsTextStyle.h2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              item.postDesc ?? "", // CHỈ SỬ DỤNG postDesc
              style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            if (item.postImgs != null && item.postImgs!.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: item.postImgs!.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => context.showMediaGallery(urls: item.postImgs!, initialIndex: index),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          width: 100,
                          child: DbCachedImageWidget(imageUrl: item.postImgs![index], fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const Spacer(),
            if (item.topicTags != null && item.topicTags!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 8),
                child: SizedBox(
                  height: 28,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.topicTags!.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return AppLabel(
                        "#${item.topicTags![index]}",
                        style: TMLabsTextStyle.caption.copyWith(fontSize: 11, color: Colors.black87),
                        backgroundColor: const Color(0xFFD9D9D9),
                        borderRadius: 12,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      );
                    },
                  ),
                ),
              ),
            Row(
              children: [
                TapEffect(
                    onTap: () => onShareTapped(item),
                    child: _buildActionIcon(AppAssets.icons.icShare, (item.postShareCount ?? 0).formatCompact())),
                const SizedBox(width: 10),
                TapEffect(
                    onTap: () => onCommentTapped(item),
                    child: _buildActionIcon(AppAssets.icons.icComment, (item.postCommentCount ?? 0).formatCompact())),
                const SizedBox(width: 10),
                TapEffect(
                    onTap: () => onLikeTapped(item),
                    child: _buildActionIcon(AppAssets.icons.icLike, (item.postLikeCount ?? 0).formatCompact())),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(dynamic icon, String count) {
    return Row(
      children: [
        AppIcon(icon, size: 18, color: TMLabsColor.grey),
        const SizedBox(width: 6),
        Text(count, style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey)),
      ],
    );
  }
}
