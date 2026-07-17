import 'dart:io';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_input_configs.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/interactor/update_profile_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/interactor/update_profile_event_state.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:coffee_bean/shared/widget/image_wechat_picker_list_view.dart';

class UpdateProfilePage extends AppCubitStateFulWidget<UpdateProfileInteractor, UpdateProfileState> {
  UpdateProfilePage({super.key, required super.interactor});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends AppCubitState<UpdateProfilePage, UpdateProfileInteractor, UpdateProfileState> {
  @override
  bool get tapToUnfocus => true;

  final TextEditingController _nicknameController = TextEditingController();
  int _sex = 1;

  bool _initialized = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  String? getTitle() => 'Cập nhật thông tin';

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<UpdateProfileInteractor, UpdateProfileState>(
      listener: (context, state) {
        if (state.isUpdateSuccess) {
          context.showFlashSuccess("Cập nhật thành công");
        }
        if (state.error != null) {
          context.showFlashError(state.error!);
        }

        if (state.userInfo != null) {
          if (!_initialized) {
            _nicknameController.text = state.nickname;
            _sex = state.userInfo?.sex ?? 1;
            _initialized = true;
          }
        }
      },
      builder: (context, state) {
        if (state.userInfo == null && state.isLoading) {
          return getLoadingView();
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          _buildInputLabel("Ảnh đại diện", isRequired: true, center: true),
                          const SizedBox(height: 8),
                          _buildAvatar(state.userInfo?.avatar, state.selectedAvatarFile),
                          if (!state.validation.isAvatarValid)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                "Vui lòng chọn ảnh đại diện",
                                style: TextStyle(color: TMLabsColor.error, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildInputLabel("Nickname", isRequired: true),
                    AppInputField(
                      controller: _nicknameController,
                      hintText: "Nhập nickname",
                      config: CoffeeInputStyles.outline,
                      onChanged: interactor.onNicknameChanged,
                      errorText: state.validation.isNicknameValid ? null : "Vui lòng nhập nickname",
                    ),
                    const SizedBox(height: 20),
                    _buildInputLabel("Giới tính"),
                    _buildSexSelector(),
                    const SizedBox(height: 20),
                    _buildInputLabel("Ảnh bìa (Cover)"),
                    ImageWechatPickerListView(
                      images: state.selectedCoverFile != null
                          ? [state.selectedCoverFile!.path]
                          : (state.userInfo?.background != null && state.userInfo!.background!.isNotEmpty
                              ? [state.userInfo!.background!]
                              : []),
                      maxImages: 1,
                      onImagesPicked: (paths) => interactor.onCoverFileSelected(paths),
                      onRemoveImage: (_) => interactor.removeCoverImage(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
              child: AppButton(
                text: "Cập Nhật",
                isLoading: state.isLoading,
                style: TMLabsButtonStyle.primary,
                onPressed: () => interactor.updateProfile(sex: _sex),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputLabel(String label, {bool isRequired = false, bool center = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TMLabsTextStyle.title.copyWith(fontSize: 14),
          ),
          if (isRequired) ...[
            const SizedBox(width: 4),
            const Text("*", style: TextStyle(color: TMLabsColor.error)),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl, File? localFile) {
    return TapEffect(
      onTap: _onPickAvatar,
      child: Stack(
        children: [
          AvatarWidget(
            imageUrl: localFile?.path ?? avatarUrl,
            size: 150,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: TMLabsColor.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _onPickAvatar() async {
    final file = await DbAssetPicker.pickSingleImage(context, crop: true);
    if (file != null) {
      interactor.onAvatarFileSelected(file);
    }
  }

  Widget _buildSexSelector() {
    return GroupButton<String>(
      buttons: const ["Nam", "Nữ"],
      options: GroupButtonOptions(
        selectedColor: TMLabsColor.primary,
        unselectedColor: Colors.white,
        selectedTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        unselectedTextStyle: const TextStyle(color: TMLabsColor.primary, fontSize: 14),
        borderRadius: BorderRadius.circular(8),
        unselectedBorderColor: TMLabsColor.primary,
        spacing: 12,
        runSpacing: 10,
        groupingType: GroupingType.row,
        mainGroupAlignment: MainGroupAlignment.start,
        buttonWidth: 80,
        buttonHeight: 40,
      ),
      onSelected: (val, index, isSelected) {
        _sex = index + 1;
      },
      controller: GroupButtonController(selectedIndex: _sex - 1),
    );
  }
}
