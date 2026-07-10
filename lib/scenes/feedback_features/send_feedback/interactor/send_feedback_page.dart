import 'package:coffee_bean/scenes/feedback_features/send_feedback/send_feedback_builder.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_input_configs.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/shared/widget/image_wechat_picker_list_view.dart';
import 'package:coffee_bean/scenes/feedback_features/send_feedback/interactor/send_feedback_interactor.dart';
import 'package:coffee_bean/scenes/feedback_features/send_feedback/interactor/send_feedback_event_state.dart';

//ignore: must_be_immutable
class SendFeedbackPage extends AppCubitStateFulWidget<SendFeedbackInteractor, SendFeedbackState> {
  SendFeedbackPage({super.key, required super.interactor});

  @override
  State<SendFeedbackPage> createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends AppCubitState<SendFeedbackPage, SendFeedbackInteractor, SendFeedbackState> {
  final TextEditingController _textController = TextEditingController();

  @override
  bool get tapToUnfocus => true;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  String? getTitle() => "Góp ý & Khiếu nại";

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<SendFeedbackInteractor, SendFeedbackState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess || prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.isSuccess) {
          _textController.clear(); // Xóa sạch textarea khi thành công
          FlashDialogHelper.show(
            context: context,
            title: "Thông báo",
            content: "Phản hồi của bạn đã được chúng tôi ghi nhận ! Chúng tôi sẽ xử lý trong thời gian sớm nhất.",
            actions: [
              FlashDialogAction(
                label: "Cám ơn bạn.",
                value: "done",
                onPressed: () {
                  interactor.router?.pop();
                },
              ),
            ],
          );
        } else if (state.errorMessage != null) {
          context.showFlashError(state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextArea(state),
                    const SizedBox(height: 20),
                    ImageWechatPickerListView(
                      images: state.images,
                      maxImages: 5,
                      onImagesPicked: interactor.onImagesPicked,
                      onRemoveImage: interactor.removeImage,
                    ),
                    const SizedBox(height: 24),
                    _buildSubmitButton(state),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppButton(
                text: "Lịch sử phản hồi",
                onPressed: () {
                  interactor.router?.navigate(FeedbackRecordRoute());
                },
                style: TMLabsButtonStyle.outline,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextArea(SendFeedbackState state) {
    return Column(
      children: [
        AppInputField(
          controller: _textController,
          hintText: "Nhập thông tin",
          maxLines: 6,
          maxLength: 1000,
          config: CoffeeInputStyles.filled.copyWith(borderRadius: 12),
          onChanged: interactor.onTextChanged,
          style: TMLabsTextStyle.body,
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            "${state.text.length}/1000",
            style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
          ),
        )
      ],
    );
  }

  Widget _buildSubmitButton(SendFeedbackState state) {
    return AppButton(
      text: "Gửi",
      onPressed: state.text.isNotEmpty ? interactor.sendFeedback : null,
      isLoading: state.isSubmitting,
      style: TMLabsButtonStyle.primary,
    );
  }
}
