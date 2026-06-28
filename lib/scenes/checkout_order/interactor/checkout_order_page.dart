import 'package:coffee_bean/scenes/checkout_order/interactor/checkout_order_event_state.dart';
import 'package:coffee_bean/scenes/checkout_order/interactor/checkout_order_interactor.dart';
import 'package:coffee_bean/scenes/checkout_order/interactor/widget/checkout_order_content_prices.dart';
import 'package:coffee_bean/scenes/checkout_order/interactor/widget/checkout_order_footer.dart';
import 'package:coffee_bean/scenes/checkout_order/interactor/widget/checkout_order_summary_fallback.dart';
import 'package:coffee_bean/scenes/checkout_order/interactor/widget/checkout_order_payment_result.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:coffee_bean/utils/flash_utils/flash_toast_helper.dart';
import 'package:db_core/utils/fade_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutOrderPage extends AppCubitStateFulWidget<CheckoutOrderInteractor, CheckoutOrderState> {
  CheckoutOrderPage({super.key, required super.interactor});

  @override
  State<CheckoutOrderPage> createState() => _CheckoutOrderPageState();
}

class _CheckoutOrderPageState extends AppCubitState<CheckoutOrderPage, CheckoutOrderInteractor, CheckoutOrderState> {
  
  @override
  String? getTitle() {
    final state = interactor.state;
    if (state.status == CheckoutOrderStatus.success) {
      return "Hóa đơn ${state.orderNumber ?? ''}";
    }
    return "THANH TOÁN";
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<CheckoutOrderInteractor, CheckoutOrderState>(
      listener: (context, state) {
        if (state.status == CheckoutOrderStatus.processing) {
          showLoading(text: "Đang xử lý thanh toán ...", style: TMLabsLoadingStyle.defaultLoadingStyle);
        } else {
          hideLoading();
        }

        if (state.successMessageKey == "LOGIN_SUCCESS") {
          FlashToastHelper.success(context, "Đăng nhập thành công!");
        }
      },
      builder: (context, state) {
        return Container(
          color: TMLabsColor.bgMain,
          child: FadeSwitcher.binary(
            duration: const Duration(milliseconds: 300),
            showFirst: state.isLoading,
            first: const Center(child: LoadingView(width: 150, height: 150)),
            second: _buildMainContentByStatus(state),
          ),
        );
      },
    );
  }

  Widget _buildMainContentByStatus(CheckoutOrderState state) {
    switch (state.status) {
      case CheckoutOrderStatus.confirming:
      case CheckoutOrderStatus.processing:
        return _buildConfirmingContent(state);
      case CheckoutOrderStatus.success:
      case CheckoutOrderStatus.failure:
        return CheckoutOrderPaymentResult(
          status: state.status,
          interactor: interactor,
        );
    }
  }

  Widget _buildConfirmingContent(CheckoutOrderState state) {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                _buildSummarySection(context, state),
                const SizedBox(height: 12),
                CheckoutOrderContentPrices(interactor: interactor),
                const SizedBox(height: 12),
                _buildOptionsSection(context, state),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CheckoutOrderFooter(interactor: interactor),
        ),
      ],
    );
  }

  Widget _buildSummarySection(BuildContext context, CheckoutOrderState state) {
    final contract = state.checkoutItem;
    if (contract == null) return const SizedBox();

    final customWidget = contract.buildSummaryWidget(context);
    if (customWidget != null) {
      return customWidget;
    }

    return CheckoutOrderSummaryFallback(contract: contract);
  }

  Widget _buildOptionsSection(BuildContext context, CheckoutOrderState state) {
    final contract = state.checkoutItem;
    if (contract == null) return const SizedBox();

    final optionsWidget = contract.buildOptionsWidget(context);
    if (optionsWidget == null) return const SizedBox();

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: optionsWidget,
    );
  }
}
