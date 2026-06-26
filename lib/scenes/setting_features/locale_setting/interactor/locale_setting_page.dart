import 'package:coffee_bean/scenes/setting_features/locale_setting/interactor/locale_setting_event_state.dart';
import 'package:coffee_bean/scenes/setting_features/locale_setting/interactor/locale_setting_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:coffee_bean/utils/language_utils.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';

class LocaleSettingPage extends AppCubitStateFulWidget<LocaleSettingInteractor, LocaleSettingState> {
  LocaleSettingPage({super.key, required super.interactor});

  @override
  State<LocaleSettingPage> createState() => _LocaleSettingPageState();
}

class _LocaleSettingPageState extends AppCubitState<LocaleSettingPage, LocaleSettingInteractor, LocaleSettingState> {
  @override
  String? getTitle() => "Ngôn ngữ & Giá tiền";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<LocaleSettingInteractor, LocaleSettingState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Cài đặt ngôn ngữ"),
                    const SizedBox(height: 12),
                    _buildLanguageGroup(state),
                    const SizedBox(height: 32),
                    _buildSectionTitle("Cài đặt giá tiền"),
                    const SizedBox(height: 12),
                    _buildCurrencyGroup(state),
                  ],
                ),
              ),
            ),
            _buildFooter(state),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TMLabsTextStyle.title.copyWith(color: TMLabsColor.grey),
      ),
    );
  }

  Widget _buildLanguageGroup(LocaleSettingState state) {
    return GroupButton<Language>(
      buttons: Language.values,
      options: const GroupButtonOptions(
        groupingType: GroupingType.column,
      ),
      controller: GroupButtonController(
        selectedIndex: Language.values.indexOf(state.selectedLanguage),
      ),
      onSelected: (val, index, isSelected) => interactor.onLanguageChanged(val),
      buttonIndexedBuilder: (selected, index, context) {
        final lang = Language.values[index];
        return DbSelectionRow(
          key: ValueKey('lang_${lang.code}'),
          title: lang.name,
          titleStyle: TMLabsTextStyle.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TMLabsColor.primary,
          ),
          leading: Text(lang.emoji, style: const TextStyle(fontSize: 24)),
          trailing: selected ? const Icon(Icons.check_circle, color: TMLabsColor.primary, size: 22) : null,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          onTap: () => interactor.onLanguageChanged(lang), 
        );
      },
    );
  }

  Widget _buildCurrencyGroup(LocaleSettingState state) {
    return GroupButton<Currency>(
      buttons: Currency.values,
      options: const GroupButtonOptions(
        groupingType: GroupingType.column,
      ),
      controller: GroupButtonController(
        selectedIndex: Currency.values.indexOf(state.selectedCurrency),
      ),
      onSelected: (val, index, isSelected) => interactor.onCurrencyChanged(val),
      buttonIndexedBuilder: (selected, index, context) {
        final currency = Currency.values[index];
        return DbSelectionRow(
          key: ValueKey('currency_${currency.name}'),
          title: "${currency.name.toUpperCase()} (${currency.symbol})",
          titleStyle: TMLabsTextStyle.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TMLabsColor.primary,
          ),
          leading: Text(currency.emoji, style: const TextStyle(fontSize: 24)),
          trailing: selected ? const Icon(Icons.check_circle, color: TMLabsColor.primary, size: 22) : null,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          onTap: () => interactor.onCurrencyChanged(currency),
        );
      },
    );
  }

  Widget _buildFooter(LocaleSettingState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: AppButton(
        text: "Cập nhật",
        style: TMLabsButtonStyle.primary,
        isLoading: state.isSubmitting,
        onPressed: () => _showConfirmUpdateDialog(context),
      ),
    );
  }

  Future<void> _showConfirmUpdateDialog(BuildContext context) async {
    final result = await FlashDialogHelper.show<bool>(
      context: context,
      title: "Xác nhận cập nhật",
      content: "Ứng dụng sẽ tải lại dữ liệu để áp dụng cài đặt mới. Bạn có muốn tiếp tục?",
      actions: [
        FlashDialogAction(label: "Để sau", value: false, color: Colors.grey),
        FlashDialogAction(label: "Đồng ý", value: true),
      ],
    );
    if (result == true) {
      interactor.performUpdate();
    }
  }
}
