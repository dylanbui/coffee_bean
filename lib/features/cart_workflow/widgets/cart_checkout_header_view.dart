import 'package:coffee_bean/data/model/response/trade/store_model.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:flutter/material.dart';

class CartCheckoutHeaderView extends StatelessWidget {
  final StoreModel? store;

  const CartCheckoutHeaderView({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final currentStore = store;
    if (currentStore == null) return const SizedBox.shrink();
    
    return Container(
      color: TMLabsColor.bgMain,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _buildTab(),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentStore.name, style: TMLabsTextStyle.title.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: TMLabsColor.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        currentStore.fullAddress, 
                        style: TMLabsTextStyle.body.copyWith(fontSize: 13, height: 1.2)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time_filled, size: 18, color: TMLabsColor.grey),
                    const SizedBox(width: 8),
                    Text(
                      "${(currentStore.openingTime == null || currentStore.openingTime!.isEmpty) ? '--:--' : currentStore.openingTime} - ${(currentStore.closingTime == null || currentStore.closingTime!.isEmpty) ? '--:--' : currentStore.closingTime}",
                      style: TMLabsTextStyle.body.copyWith(fontSize: 13),
                    ),
                    const SizedBox(width: 12),
                    _buildOpenStatusTag(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab() {
    return CustomPaint(
      painter: _TabPainter(),
      child: Container(
        height: 36,
        width: 160,
        padding: const EdgeInsets.only(left: 20, right: 30),
        alignment: Alignment.centerLeft,
        child: Text("Cửa hàng", style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
      ),
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

class _TabPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white..style = PaintingStyle.fill;
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
