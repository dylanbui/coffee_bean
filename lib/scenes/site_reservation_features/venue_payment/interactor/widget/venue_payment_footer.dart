import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_interactor.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VenuePaymentFooter extends StatelessWidget {
  final VenuePaymentInteractor interactor;

  const VenuePaymentFooter({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VenuePaymentInteractor, VenuePaymentState>(
      builder: (context, state) {
        final isLoggedIn = UserManager().isLogin;
        final displayAmount = isLoggedIn ? state.totalAmount : state.subtotal;

        return Container(
          height: 72 + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: MediaQuery.of(context).padding.bottom + 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    NumberToVietnamese.formatNumber(displayAmount),
                    style: TMLabsTextStyle.h2.copyWith(fontWeight: FontWeight.w900),
                  ),
                  _buildPromotionText(isLoggedIn, state),
                ],
              ),
              SizedBox(
                width: 164,
                height: 44,
                child: AppButton(
                  text: "THANH TOÁN",
                  style: TMLabsButtonStyle.primary,
                  isLoading: state.status == VenuePaymentStatus.processing,
                  onPressed: () => _onPaymentPressed(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromotionText(bool isLoggedIn, VenuePaymentState state) {
    if (!isLoggedIn) {
      return const Text("Đăng nhập để sử dụng ưu đãi", style: TMLabsTextStyle.small);
    }
    
    if (state.promotion.couponDiscount > 0) {
      return Text(
        "Đã áp dụng mã giảm giá -${NumberToVietnamese.formatNumber(state.promotion.couponDiscount)}",
        style: TMLabsTextStyle.small.copyWith(color: Colors.red),
      );
    }
    
    return const Text("Chưa áp dụng mã giảm giá", style: TMLabsTextStyle.small);
  }

  void _onPaymentPressed(BuildContext context) async {
    if (!UserManager().isLogin) {
      final confirm = await FlashDialogHelper.show<bool>(
        context: context,
        title: "Yêu cầu đăng nhập",
        content: "Bạn cần đăng nhập để thực hiện thanh toán. Bạn có muốn đăng nhập ngay?",
        actions: [
          FlashDialogAction(label: "Để sau", value: false, color: Colors.grey),
          FlashDialogAction(label: "Đăng nhập", value: true, color: Colors.red),
        ],
      );
      if (confirm == true) {
        interactor.doLogin();
      }
      return;
    }

    interactor.processPayment();
  }
}
