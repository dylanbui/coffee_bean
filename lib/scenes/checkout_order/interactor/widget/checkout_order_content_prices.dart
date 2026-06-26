import 'package:coffee_bean/data/local/settings_app_manager/settings_app_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/model/payment_domain.dart';
import 'package:coffee_bean/scenes/checkout_order/interactor/checkout_order_event_state.dart';
import 'package:coffee_bean/scenes/checkout_order/interactor/checkout_order_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/note_picker_modal.dart';
import 'package:coffee_bean/shared/ui_control/option_picker_modal.dart';
import 'package:db_core/utils/ui_control/selection_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutOrderContentPrices extends StatelessWidget {
  final CheckoutOrderInteractor interactor;

  const CheckoutOrderContentPrices({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutOrderInteractor, CheckoutOrderState>(
      builder: (context, state) {
        final isLoggedIn = UserManager().isLogin;

        return Column(
          children: isLoggedIn 
            ? _buildMemberLayout(context, state) 
            : _buildGuestLayout(state),
        );
      },
    );
  }

  List<Widget> _buildGuestLayout(CheckoutOrderState state) {
    return [
      _buildSummaryTable(state, isLoggedIn: false),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _buildMemberLayout(BuildContext context, CheckoutOrderState state) {
    final paymentMethod = interactor.paymentRepo.findPaymentByKey(state.preferences.paymentMethodKey);

    return [
      DbSelectionRow(
        title: "Phiếu giảm giá",
        value: state.promotion.selectedCoupon != null ? "Đã chọn" : "Chọn phiếu giảm giá",
        trailingText: state.promotion.selectedCoupon != null ? "-${_formatPrice(state.promotion.couponDiscount)}" : null,
        trailing: state.promotion.selectedCoupon == null ? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey) : null,
        onTap: () => interactor.selectCoupon(),
        titleStyle: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold),
        valueStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
        trailingTextStyle: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      const SizedBox(height: 12),
      DbSelectionRow(
        title: "Dùng điểm (${state.userPoints.toInt()} pts)",
        trailingText: "-${_formatPrice(state.potentialPointDiscount)}",
        onTap: () => interactor.togglePoints(state.usedPoints == 0),
        trailing: Icon(
          state.usedPoints > 0 ? Icons.check_circle : Icons.radio_button_unchecked,
          color: state.usedPoints > 0 ? TMLabsColor.primary : Colors.grey,
          size: 20,
        ),
        titleStyle: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold),
        trailingTextStyle: TMLabsTextStyle.body.copyWith(
          fontWeight: FontWeight.bold, 
          color: state.usedPoints > 0 ? Colors.red : TMLabsColor.grey,
        ),
      ),
      const SizedBox(height: 12),
      _buildSummaryTable(state, isLoggedIn: true),
      const SizedBox(height: 12),
      DbSelectionRow(
        title: "Phương thức thanh toán",
        value: paymentMethod?.title ?? "Chọn phương thức",
        onTap: () => _showPaymentMethodPicker(context, interactor),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        titleStyle: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold),
        valueStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
      ),
      const SizedBox(height: 12),
      _buildNoteSection(context, state),
      const SizedBox(height: 24),
    ];
  }

  Widget _buildSummaryTable(CheckoutOrderState state, {required bool isLoggedIn}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildSummaryRow("Số tiền gốc", _formatPrice(state.baseAmount), TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
          if (isLoggedIn) ...[
            const SizedBox(height: 20),
            _buildSummaryRow("Giảm giá ưu đãi", "-${_formatPrice(state.promotion.couponDiscount)}", TMLabsTextStyle.body.copyWith(color: Colors.red)),
            const SizedBox(height: 20),
            _buildSummaryRow("Giảm giá từ điểm", "-${_formatPrice(state.pointDiscount)}", TMLabsTextStyle.body.copyWith(color: Colors.red)),
            const SizedBox(height: 24),
            _buildSummaryRow("Cần thanh toán", _formatPrice(state.finalAmount), TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.w900)),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, TextStyle style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
        Text(value, style: style),
      ],
    );
  }

  Widget _buildNoteSection(BuildContext context, CheckoutOrderState state) {
    return DbSelectionRow(
      title: "Ghi chú",
      value: state.preferences.note.isEmpty ? "Nhập ghi chú" : state.preferences.note,
      onTap: () => _showNoteDialog(context),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      titleStyle: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold),
      valueStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
    );
  }

  void _showPaymentMethodPicker(BuildContext context, CheckoutOrderInteractor interactor) async {
    final result = await OptionPickerModal.show<PaymentMethod>(
      context: context,
      title: "Phương thức thanh toán",
      items: interactor.paymentRepo.allPayment,
      selectedKey: interactor.state.preferences.paymentMethodKey,
    );

    if (result != null) {
      interactor.updatePaymentMethod(result.key);
    }
  }

  Future<void> _showNoteDialog(BuildContext context) async {
    final result = await NotePickerModal.show(
      context: context,
      title: "Ghi chú",
      initialValue: interactor.state.preferences.note,
    );
    if (result != null) {
      interactor.updateNote(result);
    }
  }

  String _formatPrice(double price) {
    return SettingsAppManager.currentCurrency.format(price);
  }
}
