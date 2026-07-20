import 'package:coffee_bean/scenes/my_profile_features/disable_user/interactor/disable_user_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/disable_user/interactor/disable_user_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_localization/easy_localization.dart';

class DisableUserPage extends AppCubitStateFulWidget<DisableUserInteractor, DisableUserState> {
  DisableUserPage({super.key, required super.interactor});

  @override
  State<DisableUserPage> createState() => _DisableUserPageState();
}

class _DisableUserPageState extends AppCubitState<DisableUserPage, DisableUserInteractor, DisableUserState> {
  @override
  String? getTitle() => 'disable_user.title'.tr();

  @override
  Widget getBody(BuildContext context) {
    return BlocListener<DisableUserInteractor, DisableUserState>(
      listener: (context, state) {
        if (state.error != null) {
          context.showFlashError(state.error!);
        }
        if (state.isSuccess) {
          context.showFlashSuccess('disable_user.success_message'.tr());
        }
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'disable_user.warning_header'.tr(),
                    style: TMLabsTextStyle.title.copyWith(fontSize: 18, color: TMLabsColor.error),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'disable_user.warning_subheader'.tr(),
                    style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildWarningItem('disable_user.warning_item1'.tr()),
                  _buildWarningItem('disable_user.warning_item2'.tr()),
                  _buildWarningItem('disable_user.warning_item3'.tr()),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'disable_user.support_header'.tr(),
                          style: TMLabsTextStyle.title.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'disable_user.support_body'.tr(),
                          style: TMLabsTextStyle.body.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text('• ' + 'disable_user.support_item1'.tr(), style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.w500, fontSize: 13)),
                        Text('• ' + 'disable_user.support_item2'.tr(), style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.w500, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: TMLabsColor.error, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TMLabsTextStyle.body.copyWith(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return BlocBuilder<DisableUserInteractor, DisableUserState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
          child: AppButton(
            text: 'disable_user.button_delete'.tr(),
            isLoading: state.isLoading,
            style: TMLabsButtonStyle.error,
            onPressed: () => _showConfirmDialog(context),
          ),
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context) {
    context.showFlashConfirm<bool>(
      title: 'disable_user.confirm_title'.tr(),
      content: 'disable_user.confirm_message'.tr(),
      actions: [
        FlashDialogAction(label: "Hủy", value: false, color: TMLabsColor.grey),
        FlashDialogAction(label: "Đồng ý xóa", value: true, color: TMLabsColor.error),
      ],
    ).then((confirmed) {
      if (confirmed == true) {
        interactor.cancelAccount();
      }
    });
  }
}
