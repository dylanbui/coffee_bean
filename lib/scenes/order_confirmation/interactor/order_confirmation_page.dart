import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_event_state.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_interactor.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/widget/order_confirmation_content.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/widget/order_confirmation_footer.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/widget/order_confirmation_header.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui_control/note_picker_modal.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:db_core/utils/fade_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderConfirmationPage extends AppCubitStateFulWidget<OrderConfirmationInteractor, OrderConfirmationState> {
  OrderConfirmationPage({super.key, required super.interactor});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends AppCubitState<OrderConfirmationPage, OrderConfirmationInteractor, OrderConfirmationState> {
  @override
  String? getTitle() => "XÁC NHẬN ĐƠN HÀNG";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<OrderConfirmationInteractor, OrderConfirmationState>(
      builder: (context, state) {
        return Container(
          color: TMLabsColor.bgMain,
          child: FadeSwitcher(
            duration: const Duration(milliseconds: 300),
            showFirst: state.isLoading,
            first: const Center(child: LoadingView(width: 150, height: 150)),
            second: _buildMainContent(state),
          ),
        );
      },
    );
  }

  Widget _buildMainContent(OrderConfirmationState state) {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Height for footer
            child: Column(
              children: [
                OrderConfirmationHeader(interactor: interactor),
                OrderConfirmationContent(interactor: interactor),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: OrderConfirmationFooter(interactor: interactor),
        ),
      ],
    );
  }
}
