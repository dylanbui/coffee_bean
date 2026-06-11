import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';

class VenuePaymentResultView extends StatelessWidget {
  final VenuePaymentStatus status;
  final VenuePaymentInteractor interactor;

  const VenuePaymentResultView({
    super.key,
    required this.status,
    required this.interactor,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = status == VenuePaymentStatus.success;

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
                    text: "Xem lịch đặt",
                    style: TMLabsButtonStyle.outline,
                    onPressed: () {
                      // TODO: Navigate to Reservation List or Detail
                      interactor.router?.pop();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    text: "Quay lại",
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
