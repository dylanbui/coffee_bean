import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';

class VenuePaymentRulesCard extends StatelessWidget {
  const VenuePaymentRulesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quy định đặt chỗ", style: TMLabsTextStyle.title),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: TMLabsColor.bgLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TMLabsColor.lightGrey.withValues(alpha: 0.5), style: BorderStyle.solid),
            ),
            child: Center(
              child: Text(
                "Giới thiệu quy tắc cố định bằng hình ảnh",
                style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
