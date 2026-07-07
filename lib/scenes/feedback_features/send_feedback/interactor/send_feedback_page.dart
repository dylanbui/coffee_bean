import 'package:coffee_bean/scenes/feedback_features/send_feedback/send_feedback_builder.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/utils/flash_utils/flash_toast_helper.dart';
import 'package:db_core/utils/app_button.dart';
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
      listener: (context, state) {
        if (state is SendFeedbackSuccess) {
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
        } else if (state is SendFeedbackError) {
          FlashToastHelper.error(context, state.message);
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextField(
            controller: _textController,
            maxLines: 6,
            maxLength: 1000,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              hintText: "Nhập thông tin",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              counterText: "", 
            ),
            onChanged: interactor.onTextChanged,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "${state.text.length}/1000",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton(SendFeedbackState state) {
    bool isSubmitting = state is SendFeedbackSubmitting;
    bool isValid = state.text.isNotEmpty;
    
    return AppButton(
      text: "Gửi",
      onPressed: isValid ? interactor.sendFeedback : null,
      isLoading: isSubmitting,
      style: TMLabsButtonStyle.primary,
    );
  }
}
