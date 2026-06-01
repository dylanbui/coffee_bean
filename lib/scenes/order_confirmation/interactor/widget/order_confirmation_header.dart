import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_event_state.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderConfirmationHeader extends StatelessWidget {
  final OrderConfirmationInteractor interactor;

  const OrderConfirmationHeader({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderConfirmationInteractor, OrderConfirmationState>(
      builder: (context, state) {
        final store = state.selectedStore;
        return Container(
          color: TMLabsColor.bgMain,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildDeliveryTab(state),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (store != null) ...[
                      Text(store.name, style: TMLabsTextStyle.title.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on, color: TMLabsColor.error, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(store.address, style: TMLabsTextStyle.body.copyWith(fontSize: 13, height: 1.2)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled, size: 18, color: TMLabsColor.grey),
                          const SizedBox(width: 8),
                          Text(
                            "${store.openingTime ?? '--:--'} - ${store.closingTime ?? '--:--'}",
                            style: TMLabsTextStyle.body.copyWith(fontSize: 13),
                          ),
                          const SizedBox(width: 12),
                          _buildOpenStatusTag(),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeliveryTab(OrderConfirmationState state) {
    return Row(
      children: [
        CustomPaint(
          painter: TabPainter(),
          child: Container(
            height: 36,
            width: 200,
            padding: const EdgeInsets.only(left: 20, right: 40),
            alignment: Alignment.center,
            child: Text("Cửa hàng", style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildOpenStatusTag() {
    return AppLabel(
      "Đang mở cửa",
      backgroundColor: TMLabsColor.success,
      height: 24,
      borderRadius: 12,
      style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.white, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    );
  }
}

class TabPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
