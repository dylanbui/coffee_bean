import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/app_selection_row.dart';
import 'package:coffee_bean/shared/ui_control/option_picker_modal.dart';
import 'package:coffee_bean/data/model/payment_domain.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VenuePaymentPriceBreakdown extends StatelessWidget {
  final VenuePaymentInteractor interactor;

  const VenuePaymentPriceBreakdown({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VenuePaymentInteractor, VenuePaymentState>(
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

  List<Widget> _buildGuestLayout(VenuePaymentState state) {
    return [
      _buildSummaryTable(state, isLoggedIn: false),
      const SizedBox(height: 12),
    ];
  }

  List<Widget> _buildMemberLayout(BuildContext context, VenuePaymentState state) {
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
        trailingText: "-${_formatPrice(state.promotion.pointsDiscount)}",
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
    ];
  }

  Widget _buildSummaryTable(VenuePaymentState state, {required bool isLoggedIn}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildSummaryRow("Tổng tiền sản phẩm", _formatPrice(state.subtotal), TMLabsTextStyle.bodyBold),
          if (isLoggedIn) ...[
            const SizedBox(height: 16),
            _buildSummaryRow("Giảm giá", "-${_formatPrice(state.promotion.couponDiscount)}", TMLabsTextStyle.body.copyWith(color: Colors.red)),
            const SizedBox(height: 16),
            _buildSummaryRow("Dùng điểm", "-${_formatPrice(state.promotion.pointsDiscount)}", TMLabsTextStyle.body.copyWith(color: Colors.red)),
            const SizedBox(height: 20),
            _buildSummaryRow("Cần thanh toán", _formatPrice(state.totalAmount), TMLabsTextStyle.bodyBold.copyWith(fontSize: 18)),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, TextStyle style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.w500)),
        Text(value, style: style),
      ],
    );
  }

  void _showPaymentMethodPicker(BuildContext context, VenuePaymentInteractor interactor) async {
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

  String _formatPrice(double price) {
    return NumberToVietnamese.formatNumber(price);
  }
}
