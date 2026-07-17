import 'package:coffee_bean/scenes/expert_apply/interactor/expert_apply_event_state.dart';
import 'package:coffee_bean/scenes/expert_apply/interactor/expert_apply_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/base/tap_to_unfocus_mixin.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_input_configs.dart';
import 'package:coffee_bean/shared/widget/image_wechat_picker_list_view.dart';
import 'package:coffee_bean/shared/widget/phone_input_field.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpertApplyPage extends AppCubitStateFulWidget<ExpertApplyInteractor, ExpertApplyState> {
  ExpertApplyPage({super.key, required super.interactor});

  @override
  State<ExpertApplyPage> createState() => _ExpertApplyPageState();
}

class _ExpertApplyPageState extends AppCubitState<ExpertApplyPage, ExpertApplyInteractor, ExpertApplyState>
    with TapToUnfocusMixin {
  @override
  bool get tapToUnfocus => true;

  @override
  String? getTitle() => "Đăng ký trở thành chuyên gia";

  @override
  Widget getBody(BuildContext context) {
    return BlocListener<ExpertApplyInteractor, ExpertApplyState>(
      listenWhen: (previous, current) => previous.failure != current.failure && current.failure != null,
      listener: (context, state) {
        if (state.failure != null) {
          context.showFlashError(state.failure!.error.message);
        }
      },
      child: BlocBuilder<ExpertApplyInteractor, ExpertApplyState>(
        builder: (context, state) {
          return Stack(
            children: [
              _buildContent(state),
              if (state.isLoading) getLoadingView(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(ExpertApplyState state) {
    if (state.application == null) {
      // Nếu chưa có dữ liệu application và đang load (không phải đang submit), thì hiện màn hình trống kèm loading
      if (state.isLoading && !state.isSubmitting) {
        return const SizedBox.shrink();
      }
      return _buildForm(state);
    }

    final status = state.application!.applyStatus;
    switch (status) {
      case 0: // Pending
        return _buildStatusView(
          icon: Icons.access_time_filled,
          iconColor: Colors.orange,
          title: "Đơn ứng tuyển đã gửi thành công",
          subtitle: "Vui lòng chờ hệ thống phê duyệt",
        );
      case 1: // Approved
        return _buildStatusView(
          icon: Icons.check_circle,
          iconColor: Colors.green,
          title: "Chúc mừng!",
          subtitle: "Bạn đã trở thành chuyên gia của Coffee Bean",
        );
      case 2: // Rejected
        return _buildRejectedView(state);
      default:
        return _buildForm(state);
    }
  }

  Widget _buildForm(ExpertApplyState state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRequiredLabel("Họ và tên thật"),
                const SizedBox(height: 8),
                AppInputField(
                  hintText: "Nhập tên trên giấy tờ",
                  onChanged: interactor.onNameChanged,
                  errorText: state.validation.isNameValid ? null : "Tên không được để trống",
                  config: CoffeeInputStyles.outline,
                ),
                const SizedBox(height: 16),
                _buildRequiredLabel("Số điện thoại liên lạc"),
                const SizedBox(height: 8),
                PhoneInputField(
                  countryCodes: const ["+84", "+86"],
                  initialCountryCode: "+84",
                  onChanged: (val) => interactor.onPhoneChanged(val.countryCode, val.number, val.isValid),
                  errorText: state.validation.isPhoneValid ? null : "Số điện thoại không hợp lệ",
                  config: CoffeeInputStyles.outline,
                ),
                const SizedBox(height: 16),
                Text("Email", style: TMLabsTextStyle.bodyBold),
                const SizedBox(height: 8),
                AppInputField(
                  hintText: "Nhập địa chỉ email",
                  onChanged: interactor.onEmailChanged,
                  keyboardType: TextInputType.emailAddress,
                  errorText: state.validation.isEmailValid ? null : "Email không đúng định dạng",
                  config: CoffeeInputStyles.outline,
                ),
                const SizedBox(height: 16),
                _buildRequiredLabel("Lý do ứng tuyển"),
                const SizedBox(height: 8),
                AppInputField(
                  hintText: "Mô tả kinh nghiệm, thế mạnh của bạn...",
                  onChanged: interactor.onReasonChanged,
                  maxLines: 4,
                  errorText: state.validation.isReasonValid ? null : "Vui lòng nhập lý do ứng tuyển",
                  config: CoffeeInputStyles.outline,
                ),
                const SizedBox(height: 16),
                Text("Ghi chú", style: TMLabsTextStyle.body),
                const SizedBox(height: 8),
                AppInputField(
                  hintText: "Thêm thông tin bổ sung nếu có",
                  onChanged: interactor.onDescChanged,
                  maxLines: 3,
                  config: CoffeeInputStyles.outline,
                ),
                const SizedBox(height: 16),
                Text("Ảnh chứng minh (Bằng cấp, chứng chỉ...)", style: TMLabsTextStyle.body),
                const SizedBox(height: 8),
                ImageWechatPickerListView(
                  images: state.images,
                  maxImages: 5,
                  onImagesPicked: interactor.onImagesPicked,
                  onRemoveImage: interactor.removeImage,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: AppButton(
            text: "Xác nhận gửi",
            style: TMLabsButtonStyle.primary,
            onPressed: interactor.submitApplication,
            isLoading: state.isSubmitting,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusView({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: iconColor),
          const SizedBox(height: 24),
          Text(title, style: TMLabsTextStyle.h2, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(subtitle, style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildRejectedView(ExpertApplyState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            Text("Phê duyệt thất bại", style: TMLabsTextStyle.h2),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TMLabsColor.lightGrey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lý do từ chối:", style: TMLabsTextStyle.bodyBold),
                  const SizedBox(height: 8),
                  Text(
                    state.application?.reviewRemark ?? "Thông tin hồ sơ chưa phù hợp",
                    style: TMLabsTextStyle.body,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AppButton(
              text: "Đăng ký lại",
              style: TMLabsButtonStyle.outline,
              onPressed: interactor.onReApply,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequiredLabel(String text) {
    return Row(
      children: [
        const Text("*", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text(text, style: TMLabsTextStyle.bodyBold),
      ],
    );
  }
}
