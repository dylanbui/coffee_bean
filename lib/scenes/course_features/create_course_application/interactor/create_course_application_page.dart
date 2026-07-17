import 'package:coffee_bean/scenes/course_features/create_course_application/interactor/create_course_application_event_state.dart';
import 'package:coffee_bean/scenes/course_features/create_course_application/interactor/create_course_application_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_input_configs.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/image_wechat_picker_list_view.dart';
import 'package:coffee_bean/utils/flash_utils/flash_modal_helper.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCourseApplicationPage extends AppCubitStateFulWidget<CreateCourseApplicationInteractor, CreateCourseApplicationState> {
  CreateCourseApplicationPage({super.key, required super.interactor});

  @override
  State<CreateCourseApplicationPage> createState() => _CreateCourseApplicationPageState();
}

class _CreateCourseApplicationPageState
    extends AppCubitState<CreateCourseApplicationPage, CreateCourseApplicationInteractor, CreateCourseApplicationState> {
  
  @override
  String? getTitle() => "Đăng ký mở khóa học";

  @override
  bool get tapToUnfocus => true;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<CreateCourseApplicationInteractor, CreateCourseApplicationState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRuleHeader(),
                    const SizedBox(height: 24),
                    
                    _buildInputLabel("Tên khóa học", isRequired: true),
                    AppInputField(
                      hintText: "Nhập tên khóa học",
                      config: CoffeeInputStyles.outline,
                      onChanged: interactor.onNameChanged,
                      errorText: state.validation.isNameValid ? null : "Vui lòng nhập tên khóa học",
                    ),
                    const SizedBox(height: 20),

                    _buildInputLabel("Loại khóa học", isRequired: true),
                    _buildTypeSelector(state),
                    if (!state.validation.isTypeValid)
                      const Padding(
                        padding: EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          "Vui lòng chọn loại khóa học",
                          style: TextStyle(color: TMLabsColor.error, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 20),

                    _buildInputLabel("Học phí", isRequired: true),
                    AppInputField(
                      hintText: "Nhập học phí",
                      keyboardType: TextInputType.number,
                      config: CoffeeInputStyles.outline,
                      onChanged: interactor.onFeeChanged,
                      errorText: state.validation.isFeeValid ? null : "Vui lòng nhập học phí",
                    ),
                    const SizedBox(height: 20),

                    _buildInputLabel("Giới thiệu khóa học"),
                    AppInputField(
                      hintText: "Nhập nội dung giới thiệu...",
                      maxLines: 5,
                      maxLength: 1000,
                      config: CoffeeInputStyles.outline,
                      onChanged: interactor.onIntroChanged,
                    ),
                    const SizedBox(height: 24),

                    _buildInputLabel("Mô tả hình ảnh"),
                    const SizedBox(height: 8),
                    ImageWechatPickerListView(
                      images: state.images,
                      maxImages: 9,
                      onImagesPicked: interactor.onImagesPicked,
                      onRemoveImage: interactor.removeImage,
                    ),
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

  Widget _buildRuleHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: TMLabsColor.bgLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TMLabsColor.lightGrey,
          style: BorderStyle.solid, // Dash border mockup
        ),
      ),
      child: const Text(
        "Quy tắc đăng ký khóa học\nHệ thống quản lý nội dung",
        textAlign: TextAlign.center,
        style: TextStyle(color: TMLabsColor.grey, fontSize: 14),
      ),
    );
  }

  Widget _buildInputLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          if (isRequired)
            const Text("*", style: TextStyle(color: TMLabsColor.error)),
          Text(
            label,
            style: TMLabsTextStyle.title.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector(CreateCourseApplicationState state) {
    return GestureDetector(
      onTap: _showTypePicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: state.validation.isTypeValid ? TMLabsColor.lightGrey : TMLabsColor.error,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              state.selectedType ?? "Chọn loại khóa học",
              style: TextStyle(
                color: state.selectedType == null ? TMLabsColor.lightGrey : TMLabsColor.primary,
              ),
            ),
            const Icon(Icons.chevron_right, color: TMLabsColor.grey),
          ],
        ),
      ),
    );
  }

  void _showTypePicker() {
    final types = ["Tùy chọn A", "Tùy chọn B", "Tùy chọn C", "Tùy chọn D"];

    FlashModalHelper.showSmartModal<String>(
      context: context,
      title: "Chọn loại khóa học",
      childBuilder: (context, controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: types
              .map((type) => ListTile(
                    title: Text(type),
                    trailing: interactor.state.selectedType == type
                        ? const Icon(Icons.check, color: TMLabsColor.primary)
                        : null,
                    onTap: () {
                      interactor.onTypeSelected(type);
                      controller.dismiss();
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildSubmitButton(CreateCourseApplicationState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
        ],
      ),
      child: AppButton(
        text: "Xác nhận gửi",
        style: TMLabsButtonStyle.primary,
        isLoading: state.isSubmitting,
        onPressed: interactor.submit,
      ),
    );
  }
}
