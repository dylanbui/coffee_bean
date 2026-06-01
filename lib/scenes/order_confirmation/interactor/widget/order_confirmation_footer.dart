import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_event_state.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_interactor.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderConfirmationFooter extends StatelessWidget {
  final OrderConfirmationInteractor interactor;

  const OrderConfirmationFooter({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderConfirmationInteractor, OrderConfirmationState>(
      builder: (context, state) {
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
                    NumberToVietnamese.formatNumber(state.totalAmount, "đ") ?? "0 đ",
                    style: TMLabsTextStyle.h2.copyWith(fontWeight: FontWeight.w900),
                  ),
                  if (state.couponDiscount > 0)
                    const Text("Đã áp dụng mã giảm giá", style: TMLabsTextStyle.small),
                ],
              ),
              SizedBox(
                width: 164,
                height: 44,
                child: AppButton(
                  text: "THANH TOÁN",
                  style: TMLabsButtonStyle.primary,
                  isLoading: state.status == OrderConfirmationStatus.processing,
                  onPressed: () => interactor.processPayment(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
