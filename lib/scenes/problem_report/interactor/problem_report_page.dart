import 'package:coffee_bean/shared/ui/app_input_configs.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/image_wechat_picker_list_view.dart';
import 'package:coffee_bean/scenes/problem_report/interactor/problem_report_interactor.dart';
import 'package:coffee_bean/scenes/problem_report/interactor/problem_report_event_state.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class ProblemReportPage extends AppCubitStateFulWidget<ProblemReportInteractor, ProblemReportState> {
  ProblemReportPage({super.key, required super.interactor});

  @override
  State<ProblemReportPage> createState() => _ProblemReportPageState();
}

class _ProblemReportPageState extends AppCubitState<ProblemReportPage, ProblemReportInteractor, ProblemReportState> {
  final TextEditingController _textController = TextEditingController();

  @override
  bool get tapToUnfocus => true;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  String? getTitle() => "Problems Report";

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<ProblemReportInteractor, ProblemReportState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess || prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.isSuccess) {
          _textController.clear();
          context.showFlashSuccess("Problem Report Success");
          // router.pop() can be handled here or in Interactor -> Router
        } else if (state.errorMessage != null) {
          context.showFlashError(state.errorMessage!);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
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
              const SizedBox(height: 40),
              _buildSubmitButton(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextArea(ProblemReportState state) {
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

  Widget _buildSubmitButton(ProblemReportState state) {
    return AppButton(
      text: "Gửi",
      style: TMLabsButtonStyle.primary,
      isLoading: state.isSubmitting,
      onPressed: state.text.isNotEmpty ? interactor.submitReport : null,
    );
  }
}
