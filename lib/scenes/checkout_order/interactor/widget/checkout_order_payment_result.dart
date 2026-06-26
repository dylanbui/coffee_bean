import 'package:coffee_bean/scenes/checkout_order/interactor/checkout_order_event_state.dart';
import 'package:coffee_bean/scenes/checkout_order/interactor/checkout_order_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';

class CheckoutOrderPaymentResult extends StatelessWidget {
  final CheckoutOrderStatus status;
  final CheckoutOrderInteractor interactor;

  const CheckoutOrderPaymentResult({
    super.key,
    required this.status,
    required this.interactor,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = status == CheckoutOrderStatus.success;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: isSuccess ? TMLabsColor.success : TMLabsColor.error,
            size: 120,
          ),
          const SizedBox(height: 24),
          Text(
            isSuccess ? "Thanh toán thành công" : "Thanh toán thất bại",
            style: TMLabsTextStyle.h1,
          ),
          const SizedBox(height: 60),
          if (isSuccess)
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: "Hoàn tất",
                    style: TMLabsButtonStyle.primary,
                    onPressed: () => interactor.router?.pop(),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: "Thử lại",
                style: TMLabsButtonStyle.primary,
                onPressed: () => interactor.retryPayment(),
              ),
            ),
        ],
      ),
    );
  }
}
