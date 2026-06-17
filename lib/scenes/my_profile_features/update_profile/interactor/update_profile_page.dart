import 'package:coffee_bean/shared/base/tap_to_unfocus_mixin.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/interactor/update_profile_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/interactor/update_profile_event_state.dart';

class UpdateProfilePage extends CubitStateFulWidget<UpdateProfileInteractor, UpdateProfileState> {
  UpdateProfilePage({super.key, required super.interactor});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends CubitState<UpdateProfilePage, UpdateProfileInteractor, UpdateProfileState>
    with TapToUnfocusMixin {

  @override
  bool get tapToUnfocus => true;

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();
  int _sex = 1;
  
  bool _initialized = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    return CoffeeAppBar(
      title: 'Cập nhật thông tin',
      style: TmLabAppBarStyle.whiteStyle,
      onBackTap: () => interactor.router?.pop(),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return wrapTapToUnfocus(
      BlocConsumer<UpdateProfileInteractor, UpdateProfileState>(
        listener: (context, state) {
          if (state.isUpdateSuccess) {
            context.showFlashSuccess("Cập nhật thành công");
          }
          if (state.error != null) {
            context.showFlashError(state.error!);
          }
          
          if (state.userInfo != null && !_initialized) {
            _nicknameController.text = state.userInfo?.nickname ?? "";
            _avatarController.text = state.userInfo?.avatar ?? "";
            _sex = state.userInfo?.sex ?? 1;
            _initialized = true;
          }
        },
        builder: (context, state) {
          if (state.userInfo == null && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAvatar(state.userInfo?.avatar),
                const SizedBox(height: 16),
                Text(state.userInfo?.nickname ?? "Nickname", style: TMLabsTextStyle.h2),
                const SizedBox(height: 32),
                _buildTextField(
                  controller: _nicknameController,
                  label: "Nickname",
                  hint: "Nhập nickname",
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _avatarController,
                  label: "Link Avatar (tạm sử dụng)",
                  hint: "Nhập link ảnh đại diện",
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Giới tính", style: TMLabsTextStyle.bodyBold),
                ),
                const SizedBox(height: 8),
                _buildSexSelector(),
                const SizedBox(height: 40),
                AppButton(
                  text: "Cập Nhật",
                  isLoading: state.isLoading,
                  style: TMLabsButtonStyle.primary,
                  onPressed: _onUpdate,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl) {
    return TapEffect(
      onTap: () {
        context.showFlashInfo("Tính năng chọn ảnh từ thư viện sẽ sớm được cập nhật");
      },
      child: Stack(
        children: [
          DbCachedImageWidget(
            imageUrl: avatarUrl,
            width: 150,
            height: 150,
            borderRadius: 75,
            fit: BoxFit.cover,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: TMLabsTextStyle.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.lightGrey),
            filled: true,
            fillColor: TMLabsColor.bgLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
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

  void _onUpdate() {
    final nickname = _nicknameController.text.trim();
    final avatar = _avatarController.text.trim();

    if (nickname.isEmpty || avatar.isEmpty) {
      context.showFlashError("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    interactor.updateProfile(
      nickname: nickname,
      avatar: avatar,
      sex: _sex,
    );
  }
}
