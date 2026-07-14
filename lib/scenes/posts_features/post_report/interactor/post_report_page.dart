import 'package:coffee_bean/scenes/posts_features/post_report/interactor/post_report_event_state.dart';
import 'package:coffee_bean/scenes/posts_features/post_report/interactor/post_report_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_report/post_report_builder.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_input_configs.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';

class PostReportPage extends AppCubitStateFulWidget<PostReportInteractor, PostReportState> {
  PostReportPage({super.key, required super.interactor});

  @override
  State<PostReportPage> createState() => _PostReportPageState();
}

class _PostReportPageState extends AppCubitState<PostReportPage, PostReportInteractor, PostReportState> {
  @override
  bool get tapToUnfocus => true;

  @override
  String? getTitle() => 'Báo cáo';

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<PostReportInteractor, PostReportState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess && curr.isSuccess,
      listener: (context, state) {
        _showSuccessDialog(context);
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
                    _buildTargetInfo(state),
                    const SizedBox(height: 24),
                    _buildReasonSection(state),
                    const SizedBox(height: 24),
                    _buildDescriptionSection(state),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(state),
          ],
        );
      },
    );
  }

  Widget _buildTargetInfo(PostReportState state) {
    final info = interactor.targetInfo;
    final typeText = info.type == ReportTargetType.post ? 'bài viết' : 'bình luận';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TMLabsTextStyle.body,
            children: [
              const TextSpan(text: 'Báo cáo '),
              TextSpan(
                text: info.nickname,
                style: TMLabsTextStyle.bodyBold,
              ),
              TextSpan(text: ' phát biểu $typeText:'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TMLabsColor.accent.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (info.imageUrl != null) ...[
                DbCachedImageWidget(
                  imageUrl: info.imageUrl!,
                  width: 60,
                  height: 60,
                  borderRadius: 8,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  info.summary ?? "",
                  style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReasonSection(PostReportState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLabel(
          'Chọn loại báo cáo',
          style: TMLabsTextStyle.title,
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(height: 12),
        GroupButton(
          isRadio: false,
          buttons: interactor.reportReasons,
          onSelected: (val, index, isSelected) {
            final currentSelected = List<int>.from(state.selectedReasonIndexes);
            if (isSelected) {
              currentSelected.add(index);
            } else {
              currentSelected.remove(index);
            }
            interactor.onReasonSelected(currentSelected);
          },
          options: GroupButtonOptions(
            mainGroupAlignment: MainGroupAlignment.start,
            groupingType: GroupingType.wrap,
            spacing: 8,
            runSpacing: 8,
            borderRadius: BorderRadius.circular(20),
            unselectedShadow: const [],
            unselectedTextStyle: TMLabsTextStyle.body.copyWith(fontSize: 13, color: TMLabsColor.grey),
            selectedTextStyle: TMLabsTextStyle.bodyBold.copyWith(fontSize: 13, color: TMLabsColor.primary),
            unselectedColor: TMLabsColor.accent.withValues(alpha: 0.05),
            selectedColor: TMLabsColor.accent.withValues(alpha: 0.2),
            selectedBorderColor: TMLabsColor.primary,
            unselectedBorderColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(PostReportState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLabel(
          'Viết mô tả báo cáo',
          style: TMLabsTextStyle.title,
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(height: 12),
        AppInputField(
          config: CoffeeInputStyles.outline,
          hintText: 'Nhập nội dung báo cáo tại đây...',
          maxLines: 5,
          onChanged: interactor.onDescriptionChanged,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(PostReportState state) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AppButton(
          text: 'Gửi báo cáo',
          style: TMLabsButtonStyle.primary,
          width: double.infinity,
          isLoading: state.isLoading,
          onPressed: (state.selectedReasonIndexes.isNotEmpty || state.description.trim().isNotEmpty)
              ? interactor.submitReport
              : null,
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    FlashDialogHelper.show(
      context: context,
      title: 'Thông báo',
      content: 'Cám ơn bạn đã gửi báo cáo, chúng tôi sẽ nghiêm túc xem xét',
      actions: [
        FlashDialogAction(
          label: 'Xin cảm ơn',
          value: true,
          onPressed: () {
            interactor.router?.pop();
          },
        ),
      ],
    );
  }
}
