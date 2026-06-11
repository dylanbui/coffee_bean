import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/model/payment_domain.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_event_state.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/app_selection_row.dart';
import 'package:coffee_bean/shared/ui_control/note_picker_modal.dart';
import 'package:coffee_bean/shared/ui_control/option_picker_modal.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';

class OrderConfirmationContentPrices extends StatelessWidget {
  final OrderConfirmationInteractor interactor;

  const OrderConfirmationContentPrices({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderConfirmationInteractor, OrderConfirmationState>(
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

  /// Layout dành cho khách chưa đăng nhập (Chỉ hiện tổng tiền sản phẩm)
  List<Widget> _buildGuestLayout(OrderConfirmationState state) {
    return [
      _buildSummaryTable(state, isLoggedIn: false),
      const SizedBox(height: 24),
    ];
  }

  /// Layout dành cho thành viên (Hiện đầy đủ voucher, điểm, thanh toán, ghi chú)
  List<Widget> _buildMemberLayout(BuildContext context, OrderConfirmationState state) {
    final paymentMethod = interactor.paymentRepo.findPaymentByKey(state.preferences.paymentMethodKey);

    return [
      AppSelectionRow(
        title: "Phiếu giảm giá",
        value: state.promotion.selectedCoupon != null ? "Voucher đã chọn" : "Chọn voucher",
        trailingText: state.promotion.selectedCoupon != null ? "-${_formatPrice(state.promotion.couponDiscount)}" : null,
        onTap: () => interactor.selectCoupon(),
      ),
      const SizedBox(height: 12),
      AppSelectionRow(
        title: "Dùng điểm",
        value: "Đã dùng",
        trailingText: _formatPrice(state.promotion.pointsDiscount),
        showCheck: true,
        onTap: () {}, // TODO: Implement points logic
      ),
      const SizedBox(height: 12),
      _buildSummaryTable(state, isLoggedIn: true),
      const SizedBox(height: 12),
      AppSelectionRow(
        title: "Phương thức thanh toán",
        value: paymentMethod?.title ?? "Chọn phương thức",
        onTap: () => _showPaymentMethodPicker(context, interactor),
      ),
      const SizedBox(height: 12),
      _buildDeliveryAndNote(context, state),
      const SizedBox(height: 24),
    ];
  }

  Widget _buildSummaryTable(OrderConfirmationState state, {required bool isLoggedIn}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildSummaryRow("Tổng tiền sản phẩm", _formatPrice(state.subtotal), TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
          if (isLoggedIn) ...[
            const SizedBox(height: 20),
            _buildSummaryRow("Giảm giá", "-${_formatPrice(state.promotion.couponDiscount)}", TMLabsTextStyle.body.copyWith(color: Colors.red)),
            const SizedBox(height: 20),
            _buildSummaryRow("Dùng điểm", "-${_formatPrice(state.promotion.pointsDiscount)}", TMLabsTextStyle.body.copyWith(color: Colors.red)),
            const SizedBox(height: 24),
            _buildSummaryRow("Cần thanh toán", _formatPrice(state.totalAmount), TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.w900)),
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

  Widget _buildDeliveryAndNote(BuildContext context, OrderConfirmationState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Hình thức nhận hàng", style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              GroupButton<DeliveryMethod>(
                isRadio: true,
                onSelected: (val, index, isSelected) {
                  interactor.updateDeliveryMethod(val);
                },
                buttons: const [DeliveryMethod.dineIn, DeliveryMethod.takeAway],
                controller: GroupButtonController(selectedIndex: state.preferences.deliveryMethod == DeliveryMethod.dineIn ? 0 : 1),
                buttonBuilder: (selected, value, context) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: selected ? TMLabsColor.primary : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 2),
                      Text(value == DeliveryMethod.dineIn ? "Dùng tại quán" : "Mang đi", style: TMLabsTextStyle.caption.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => _showNoteDialog(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ghi chú", style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          state.preferences.note.isEmpty ? "Nhập ghi chú" : state.preferences.note,
                          style: TMLabsTextStyle.body,
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodPicker(BuildContext context, OrderConfirmationInteractor interactor) async {
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
    return NumberToVietnamese.formatNumber(price);
  }
}
