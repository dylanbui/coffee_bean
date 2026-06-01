import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_event_state.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_interactor.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/widget/order_confirmation_content_items.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/note_picker_modal.dart';
import 'package:coffee_bean/shared/ui_control/option_picker_modal.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';

class OrderConfirmationContentPrices extends StatelessWidget {
  final OrderConfirmationInteractor interactor;

  const OrderConfirmationContentPrices({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderConfirmationInteractor, OrderConfirmationState>(
      builder: (context, state) {
        final isLoggedIn = UserManager().isLogin;

        return Column(
          children: [
            if (isLoggedIn) ...[
              _buildSelectionRow(
                title: "Phiếu giảm giá",
                value: state.selectedCoupon != null ? "Voucher đã chọn" : "Chọn voucher",
                trailing: state.selectedCoupon != null ? "-${_formatPrice(state.couponDiscount)}" : null,
                onTap: () => interactor.selectCoupon(),
              ),
              const SizedBox(height: 12),
              _buildSelectionRow(
                title: "Dùng điểm",
                value: "Đã dùng",
                trailing: _formatPrice(state.pointsDiscount),
                showCheck: true,
                onTap: () {}, // TODO
              ),
              const SizedBox(height: 12),
            ],
            _buildSummaryTable(state, isLoggedIn),
            const SizedBox(height: 12),
            if (isLoggedIn) ...[
              _buildSelectionRow(
                title: "Phương thức thanh toán",
                value: state.paymentMethod,
                onTap: () => _showPaymentMethodPicker(context, interactor),
              ),
              const SizedBox(height: 12),
              _buildDeliveryAndNote(context, state),
              const SizedBox(height: 24),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSelectionRow({
    required String title,
    required String value,
    String? trailing,
    bool showCheck = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(title, style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(value, style: TMLabsTextStyle.body),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  Text(trailing, style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold, color: trailing.startsWith('-') ? Colors.red : Colors.black)),
                ],
                const SizedBox(width: 8),
                if (showCheck)
                  const Icon(Icons.check_circle, color: TMLabsColor.primary, size: 20)
                else
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryTable(OrderConfirmationState state, bool isLoggedIn) {
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
            _buildSummaryRow("Giảm giá", "-${_formatPrice(state.couponDiscount)}", TMLabsTextStyle.body.copyWith(color: Colors.red)),
            const SizedBox(height: 20),
            _buildSummaryRow("Dùng điểm", "-${_formatPrice(state.pointsDiscount)}", TMLabsTextStyle.body.copyWith(color: Colors.red)),
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
                controller: GroupButtonController(selectedIndex: state.deliveryMethod == DeliveryMethod.dineIn ? 0 : 1),
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
              crossAxisAlignment: CrossAxisAlignment.start, // Giữ nhãn "Ghi chú" ở trên cùng
              children: [
                Text("Ghi chú", style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa text ghi chú và icon theo chiều dọc
                    children: [
                      Expanded(
                        child: Text(
                          state.note.isEmpty ? "Nhập ghi chú" : state.note,
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
    final items = [
      DefaultOptionItem(id: 1, key: "Tiền mặt", title: "Tiền mặt", icon: Icons.payments_outlined),
      DefaultOptionItem(id: 2, key: "Ví MoMo", title: "Ví MoMo", icon: Icons.account_balance_wallet_outlined),
      DefaultOptionItem(id: 3, key: "ZaloPay", title: "ZaloPay", icon: Icons.account_balance_wallet_outlined),
      DefaultOptionItem(id: 4, key: "Thẻ ATM / Visa", title: "Thẻ ATM / Visa", icon: Icons.credit_card_outlined),
    ];

    final result = await OptionPickerModal.show<DefaultOptionItem>(
      context: context,
      title: "Phương thức thanh toán",
      items: items,
      selectedKey: interactor.state.paymentMethod,
    );

    if (result != null) {
      interactor.updatePaymentMethod(result.key);
    }
  }

  Future<void> _showNoteDialog(BuildContext context) async {
    final result = await NotePickerModal.show(
      context: context,
      title: "Ghi chú",
      initialValue: interactor.state.note,
    );
    if (result != null) {
      interactor.updateNote(result);
    }
  }

  String _formatPrice(double price) {
    return NumberToVietnamese.formatNumber(price, "đ") ?? "0 đ";
  }
}
