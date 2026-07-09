import 'package:coffee_bean/data/local/settings_app_manager/settings_app_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/features/checkout_order/interactor/checkout_order_event_state.dart';
import 'package:coffee_bean/features/checkout_order/interactor/checkout_order_interactor.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutOrderFooter extends StatelessWidget {
  final CheckoutOrderInteractor interactor;

  const CheckoutOrderFooter({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutOrderInteractor, CheckoutOrderState>(
      builder: (context, state) {
        final isLoggedIn = UserManager().isLogin;
        final displayAmount = isLoggedIn ? state.finalAmount : state.baseAmount;

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
                    SettingsAppManager.currentCurrency.format(displayAmount),
                    style: TMLabsTextStyle.h2.copyWith(fontWeight: FontWeight.w900),
                  ),
                  if (isLoggedIn && state.totalDiscount > 0)
                    const Text("Đã áp dụng giảm giá", style: TMLabsTextStyle.small),
                ],
              ),
              SizedBox(
                width: 164,
                height: 44,
                child: AppButton(
                  text: "THANH TOÁN",
                  style: TMLabsButtonStyle.primary,
                  isLoading: state.status == CheckoutOrderStatus.processing,
                  onPressed: state.isOrderButtonEnabled ? () => _onPaymentPressed(context) : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onPaymentPressed(BuildContext context) async {
    // Clone 100% logic check login từ order_confirmation
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
