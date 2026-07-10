import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/base/tap_to_unfocus_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_input_configs.dart';
import 'package:coffee_bean/shared/widget/image_wechat_picker_list_view.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_evaluation/interactor/course_order_evaluation_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_evaluation/interactor/course_order_evaluation_event_state.dart';

class CourseOrderEvaluationPage extends AppCubitStateFulWidget<CourseOrderEvaluationInteractor, CourseOrderEvaluationState> {
  CourseOrderEvaluationPage({super.key, required super.interactor});

  @override
  State<CourseOrderEvaluationPage> createState() => _CourseOrderEvaluationPageState();
}

class _CourseOrderEvaluationPageState extends AppCubitState<CourseOrderEvaluationPage, CourseOrderEvaluationInteractor, CourseOrderEvaluationState>
    with TapToUnfocusMixin {
  
  final TextEditingController _commentController = TextEditingController();

  @override
  bool get tapToUnfocus => true;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  String? getTitle() => "Đánh giá";

  @override
  Widget getBody(BuildContext context) {
    return wrapTapToUnfocus(
      BlocConsumer<CourseOrderEvaluationInteractor, CourseOrderEvaluationState>(
        listener: (context, state) {
          // Xử lý các side effects nếu cần
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRewardBanner(),
                      const SizedBox(height: 16),
                      _buildProductCard(state),
                      const SizedBox(height: 24),
                      Center(child: _buildRatingBar(state)),
                      const SizedBox(height: 24),
                      _buildCommentInput(state),
                      const SizedBox(height: 16),
                      ImageWechatPickerListView(
                        images: state.images,
                        maxImages: 5,
                        onImagesPicked: interactor.onImagesPicked,
                        onRemoveImage: interactor.removeImage,
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppButton(
                    text: "Gửi đánh giá",
                    isLoading: state.isSubmitting,
                    style: TMLabsButtonStyle.primary,
                    onPressed: () => _handleSubmit(state),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRewardBanner() {
    return const Center(
      child: AppLabel(
        "Hoàn thành bản đơn này có thể nhận được 120 tích điểm",
        backgroundColor: Colors.transparent,
        style: TextStyle(color: Colors.orange, fontSize: 13),
      ),
    );
  }

  Widget _buildProductCard(CourseOrderEvaluationState state) {
    final order = state.orderData;
    return Row(
      children: [
        DbCachedImageWidget(
          imageUrl: order?.imageUrl,
          width: 44,
          height: 44,
          borderRadius: 8,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            order?.title ?? "...",
            style: TMLabsTextStyle.title.copyWith(fontSize: 15),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(CourseOrderEvaluationState state) {
    return RatingBar.builder(
      initialRating: state.rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: interactor.onRatingChanged,
    );
  }

  Widget _buildCommentInput(CourseOrderEvaluationState state) {
    const int maxLength = 1000;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppInputField(
          controller: _commentController,
          hintText: "Mô tả trải nghiệm học tập của khóa học này",
          maxLines: 6,
          maxLength: maxLength,
          style: TMLabsTextStyle.body,
          config: CoffeeInputStyles.filled,
          onChanged: (value) {
            interactor.onCommentChanged(value);
            setState(() {}); // Cập nhật số ký tự đếm ngược
          },
        ),
        const SizedBox(height: 4),
        Text(
          "${maxLength - _commentController.text.length}",
          style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
        ),
      ],
    );
  }

  Future<void> _handleSubmit(CourseOrderEvaluationState state) async {
    await interactor.submitEvaluation();
    
    if (!mounted) return;

    FlashDialogHelper.show(
      context: context,
      title: "Thông báo",
      content: "Bạn đã đánh giá ${state.rating.toInt()} sao cho sản phẩm ${state.orderData?.title}",
      barrierDismissible: false,
      actions: [
        FlashDialogAction(
          label: "Xin cảm ơn",
          value: null,
          onPressed: () => interactor.router?.pop(),
        ),
      ],
    );
  }
}
