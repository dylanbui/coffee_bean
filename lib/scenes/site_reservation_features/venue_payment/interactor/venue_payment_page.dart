import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/widget/venue_payment_footer.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/widget/venue_payment_info_card.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/widget/venue_payment_price_breakdown.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/widget/venue_payment_result_view.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/widget/venue_payment_rules_card.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/widget/venue_payment_slots_card.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:coffee_bean/utils/flash_utils/flash_toast_helper.dart';
import 'package:db_core/utils/fade_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VenuePaymentPage extends AppCubitStateFulWidget<VenuePaymentInteractor, VenuePaymentState> {
  VenuePaymentPage({super.key, required super.interactor});

  @override
  State<VenuePaymentPage> createState() => _VenuePaymentPageState();
}

class _VenuePaymentPageState extends AppCubitState<VenuePaymentPage, VenuePaymentInteractor, VenuePaymentState> {
  @override
  String? getTitle() => "XÁC NHẬN ĐẶT LỊCH";

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<VenuePaymentInteractor, VenuePaymentState>(
      listener: (context, state) {
        if (state.status == VenuePaymentStatus.processing) {
          showLoading(text: "Đang xử lý thanh toán ...", style: TMLabsLoadingStyle.defaultLoadingStyle);
        } else {
          hideLoading();
        }

        if (state.uiStatus.successMessageKey == "LOGIN_SUCCESS") {
          FlashToastHelper.success(context, "Đăng nhập thành công! Bạn có thể tiếp tục thanh toán.");
        }
      },
      builder: (context, state) {
        return Container(
          color: TMLabsColor.bgMain,
          child: FadeSwitcher.binary(
            duration: const Duration(milliseconds: 300),
            showFirst: state.uiStatus.isLoading,
            first: const Center(child: LoadingView(width: 150, height: 150)),
            second: _buildMainContentByStatus(state),
          ),
        );
      },
    );
  }

  Widget _buildMainContentByStatus(VenuePaymentState state) {
    switch (state.status) {
      case VenuePaymentStatus.confirming:
      case VenuePaymentStatus.processing:
        return _buildConfirmingContent(state);
      case VenuePaymentStatus.success:
      case VenuePaymentStatus.failure:
        return VenuePaymentResultView(
          status: state.status,
          interactor: interactor,
        );
    }
  }

  Widget _buildConfirmingContent(VenuePaymentState state) {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                VenuePaymentInfoCard(params: state.params),
                VenuePaymentSlotsCard(params: state.params),
                VenuePaymentPriceBreakdown(interactor: interactor),
                const VenuePaymentRulesCard(),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: VenuePaymentFooter(interactor: interactor),
        ),
      ],
    );
  }
}
