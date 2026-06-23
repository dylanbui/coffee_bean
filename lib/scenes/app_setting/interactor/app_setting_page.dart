import 'package:coffee_bean/scenes/app_setting/interactor/app_setting_event_state.dart';
import 'package:coffee_bean/scenes/app_setting/interactor/app_setting_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/db_selection_row.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:coffee_bean/utils/language_utils.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_button/group_button.dart';

class AppSettingPage extends AppCubitStateFulWidget<AppSettingInteractor, AppSettingState> {
  AppSettingPage({super.key, required super.interactor});

  @override
  State<AppSettingPage> createState() => _AppSettingPageState();
}

class _AppSettingPageState extends AppCubitState<AppSettingPage, AppSettingInteractor, AppSettingState> {
  @override
  String? getTitle() => "Cài đặt ứng dụng";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<AppSettingInteractor, AppSettingState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Diagnostic Section (To check SVG files) ---
                    _buildDiagnosticIcons(),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    
                    _buildSectionTitle("Ngôn ngữ"),
                    const SizedBox(height: 12),
                    _buildLanguageGroup(state),
                    const SizedBox(height: 32),
                    _buildSectionTitle("Tiền tệ"),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title.toUpperCase(),
        style: TMLabsTextStyle.body.copyWith(
          fontWeight: FontWeight.bold,
          color: TMLabsColor.secondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildLanguageGroup(AppSettingState state) {
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
          // Sử dụng Emoji thay cho SVG
          leading: Text(lang.emoji, style: const TextStyle(fontSize: 24)),
          trailing: selected ? const Icon(Icons.check_circle, color: TMLabsColor.primary, size: 22) : null,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          onTap: () => interactor.onLanguageChanged(lang), 
        );
      },
    );
  }

  Widget _buildCurrencyGroup(AppSettingState state) {
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
          title: "${currency.name.toUpperCase()} (${currency.symbol})",
          // Sử dụng Emoji lá cờ đại diện cho quốc gia của đồng tiền
          leading: Text(currency.emoji, style: const TextStyle(fontSize: 24)),
          trailing: selected ? const Icon(Icons.check_circle, color: TMLabsColor.primary, size: 22) : null,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          onTap: () => interactor.onCurrencyChanged(currency),
        );
      },
    );
  }

  Widget _buildFooter(AppSettingState state) {
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

  /// Diagnostic Widget to check SVGs
  Widget _buildDiagnosticIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("DIAGNOSTIC - SVG CHECK", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 10),
          Row(
            children: [
              ...Language.values.map((lang) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      Text(lang.code),
                      const SizedBox(height: 4),
                      SvgPicture.asset(
                        lang.flag, 
                        width: 40, 
                        height: 40,
                        placeholderBuilder: (context) => const Icon(Icons.error_outline, color: Colors.orange),
                      ),
                    ],
                  ),
                );
              }),
              // Thêm 1 icon chắc chắn tồn tại để đối chứng
              Column(
                children: [
                  const Text("home"),
                  const SizedBox(height: 4),
                  SvgPicture.asset(
                    'assets/icons/ic_home.svg',
                    width: 40,
                    height: 40,
                    colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
