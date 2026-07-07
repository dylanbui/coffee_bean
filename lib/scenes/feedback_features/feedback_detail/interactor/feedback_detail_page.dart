import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_detail/interactor/feedback_detail_interactor.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_detail/interactor/feedback_detail_event_state.dart';

class FeedbackDetailPage extends AppCubitStateFulWidget<FeedbackDetailInteractor, FeedbackDetailState> {
  FeedbackDetailPage({super.key, required super.interactor});

  @override
  State<FeedbackDetailPage> createState() => _FeedbackDetailPageState();
}

class _FeedbackDetailPageState extends AppCubitState<FeedbackDetailPage, FeedbackDetailInteractor, FeedbackDetailState> {
  @override
  String? getTitle() => "Chi tiết phản hồi";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<FeedbackDetailInteractor, FeedbackDetailState>(
      builder: (context, state) {
        if (state.isLoading && state.feedback == null) {
          return getLoadingView();
        }

        final item = state.feedback;
        if (item == null) {
          return getEmptyItemView(caption: "Không tìm thấy nội dung phản hồi.");
        }

        String formattedDate = "";
        if (item.createTime != null) {
          formattedDate = UtcUtils.formatTimestamp(
            item.createTime!, 
            format: AppDateTimeFormat.fullDatetime
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.feedbackContent ?? "",
                  style: TMLabsTextStyle.body.copyWith(height: 1.5),
                ),
                if (item.feedbackImgs != null && item.feedbackImgs!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildImageHorizontalList(item.feedbackImgs!),
                ],
                const SizedBox(height: 24),
                Text(
                  formattedDate,
                  style: TMLabsTextStyle.caption.copyWith(color: Colors.grey),
                ),
                if (item.feedbackRemark != null && item.feedbackRemark!.isNotEmpty) ...[
                  const Divider(height: 32),
                  Text(
                    "Phản hồi từ hệ thống:",
                    style: TMLabsTextStyle.bodyBold,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.feedbackRemark!,
                    style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.secondary),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageHorizontalList(List<String> images) {
    final heroTagPrefix = "feedback_detail_image";
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.showPhotoGallery(
              imageUrls: images, 
              initialIndex: index,
              heroPrefix: heroTagPrefix,
            ),
            child: Hero(
              tag: "${heroTagPrefix}_$index",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 100,
                  child: DbCachedImageWidget(imageUrl: images[index], fit: BoxFit.cover),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
