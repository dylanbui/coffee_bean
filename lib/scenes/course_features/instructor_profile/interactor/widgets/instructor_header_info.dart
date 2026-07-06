import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/models/instructor_profile_model.dart';

class InstructorHeaderInfo extends StatelessWidget {
  final InstructorProfileModel data;
  final VoidCallback onFollowTap;

  const InstructorHeaderInfo({
    super.key,
    required this.data,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB (16.0,16.0,16.0,8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarWidget(imageUrl: data.avatar, size: 70),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.name,
                        style: TMLabsTextStyle.h2.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (data.title != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: TMLabsColor.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: TMLabsColor.primary),
                        ),
                        child: Text(
                          data.title!,
                          style: TMLabsTextStyle.caption.copyWith(
                            color: TMLabsColor.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Wrap(
                  spacing: 40,
                  runSpacing: 4,
                  children: [
                    _buildStatItem(data.postCount.toString(), "Bài viết"),
                    _buildStatItem(_formatCount(data.followerCount), "Follower"),
                    _buildStatItem(data.followingCount.toString(), "Đã Follow"),
                  ],
                ),
                const SizedBox(height: 6),
                _buildFollowButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TMLabsTextStyle.bodyBold.copyWith(fontSize: 16)),
        Text(label, style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey, fontSize: 11)),
      ],
    );
  }

  Widget _buildFollowButton() {
    return AppButton(
      text: data.isFollowed ? "Đã Follow" : "Theo dõi",
      style: data.isFollowed ? TMLabsButtonStyle.secondary : TMLabsButtonStyle.primary,
      width: 120,
      height: 28,
      padding: EdgeInsets.zero,
      onPressed: onFollowTap,
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}k";
    }
    return count.toString();
  }
}
