// import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_event_state.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:flutter/material.dart';

class VenuePaymentSlotsCard extends StatelessWidget {
  final VenuePaymentParams params;

  const VenuePaymentSlotsCard({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text("Khung giờ", style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey))),
              Expanded(child: Center(child: Text("Số sân", style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey)))),
              Expanded(child: Align(alignment: Alignment.centerRight, child: Text("Giá", style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey)))),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: TMLabsColor.bgLight),
          const SizedBox(height: 12),
          const Center(child: Text("Dữ liệu tạm thời đóng để chờ cập nhật")),
          /*
          ...params.selectedSlots.map((slot) {
            final court = params.courts.firstWhere((c) => c.id == slot.courtId, orElse: () => VenueCourtModel(id: slot.courtId, name: slot.courtId));
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      slot.time,
                      style: TMLabsTextStyle.bodyBold,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        court.name,
                        style: TMLabsTextStyle.body,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        NumberToVietnamese.formatNumber(slot.price),
                        style: TMLabsTextStyle.bodyBold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          */
        ],
      ),
    );
  }
}
