import 'package:coffee_bean/data/model/response/hub/venue_schedule.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/diagonal_stripes_widget.dart';
import 'package:db_core/utils/fade_switcher.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class VenueDetailMainContent extends StatelessWidget {
  final VenueDetailState state;
  final VenueDetailInteractor interactor;

  const VenueDetailMainContent({
    super.key,
    required this.state,
    required this.interactor,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSwitcher(
      stateKey: "matrix_${state.selectedDate}_${state.isLoading}",
      child: Opacity(
        opacity: state.isLoading ? 0.5 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegend(),
            _buildBookingMatrix(),
            _buildRulesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(Colors.white, "Còn trống", border: true),
          const SizedBox(width: 16),
          _buildLegendItem(TMLabsColor.primary, "Đã chọn"),
          const SizedBox(width: 16),
          _buildLegendItem(
            TMLabsColor.bgLight,
            "Đã hết chỗ",
            hasStripes: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text, {bool border = false, bool hasStripes = false}) {
    return Row(
      children: [
        DiagonalStripesWidget(
          width: 30,
          height: 16,
          backgroundColor: color,
          borderRadius: BorderRadius.circular(4),
          stripeColor: hasStripes ? TMLabsColor.lightGrey.withValues(alpha: 0.5) : Colors.transparent,
          child: border
              ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: TMLabsColor.lightGrey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 4),
        Text(text, style: TMLabsTextStyle.caption.copyWith(fontSize: 10)),
      ],
    );
  }

  /// logic: Kiểm tra khung giờ có hợp lệ để đặt hay không (Dựa trên thời gian hiện tại và Buffer)
  bool _isSlotExpired(DateTime selectedDate, String startTime) {
    final now = DateTime.now();
    // Quy định: Không cho phép đặt khung giờ sắp diễn ra trong vòng 30 phút tới
    const buffer = VenueDetailConstants.bookingBufferTime;

    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    // 1. Nếu ngày chọn là ngày trong quá khứ -> Hết hạn
    if (date.isBefore(today)) return true;
    // 2. Nếu ngày chọn là tương lai -> Hợp lệ
    if (date.isAfter(today)) return false;

    // 3. Nếu là hôm nay, kiểm tra giờ bắt đầu của slot
    try {
      final parts = startTime.split(':');
      final slotTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      // logic: Nếu thời gian hiện tại cộng thêm 30p buffer vượt quá giờ bắt đầu slot -> Hết hạn
      return slotTime.isBefore(now.add(buffer));
    } catch (_) {
      return false;
    }
  }

  Widget _buildBookingMatrix() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Column
          Container(
            width: 60,
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: state.timeSlots.map((time) {
                return SizedBox(
                  height: 60,
                  child: Center(
                    child: Text(time, style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey)),
                  ),
                );
              }).toList(),
            ),
          ),
          // Courts Matrix
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Court Headers
                  Row(
                    children: state.spaces.map((space) {
                      return Container(
                        width: 100,
                        height: 32,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: TMLabsColor.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            space.spaceName ?? "Sân",
                            style: TMLabsTextStyle.small.copyWith(color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  // Matrix Cells
                  ...state.timeSlots.map((time) {
                    final isExpired = _isSlotExpired(state.selectedDate, time);

                    return Row(
                      children: state.spaces.map((space) {
                        // Tìm slot khớp với mốc giờ này trong danh sách slots của sân
                        // Nếu không tìm thấy hoặc slots null, tạo một slot ảo với trạng thái 'Đã hết chỗ'
                        final slot = (space.slots ?? []).firstWhere(
                          (s) => s.slotStartTime == time,
                          orElse: () => VenueSlot(
                            spaceId: space.spaceId,
                            slotDate: space.slotDate,
                            slotStartTime: time,
                            slotStatus: 1,
                          ),
                        );

                        final isSelected = interactor.isSlotSelected(slot);
                        // logic: Coi các slot đã hết hạn (expired) như các slot đã được đặt (booked) về mặt hiển thị
                        final isBooked = slot.slotStatus == 1 || isExpired;
                        final priceText = slot.slotPrice.toFormatPrice();

                        return TapEffect(
                          // logic: Chặn sự kiện tap nếu slot đã hết hạn
                          onTap: isExpired ? () {} : () => interactor.onSlotTapped(slot),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: DiagonalStripesWidget(
                              width: 100,
                              height: 52,
                              borderRadius: BorderRadius.circular(8),
                              backgroundColor: isSelected
                                  ? TMLabsColor.primary
                                  : (isBooked ? TMLabsColor.bgLight : Colors.white),
                              stripeColor: isBooked && !isSelected
                                  ? TMLabsColor.lightGrey.withValues(alpha: 0.5)
                                  : Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected ? TMLabsColor.primary : TMLabsColor.bgLight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    // logic: Hiển thị nhãn "Đã qua" cho slot hết hạn, "Đã hết" cho slot đã đặt
                                    isExpired ? "Đã qua" : (isBooked ? "Hết chỗ" : priceText),
                                    style: TMLabsTextStyle.caption.copyWith(
                                      color: isSelected ? Colors.white : TMLabsColor.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesSection() {
    final rulesHtml = state.venueDetail?.venueRules;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quy định đặt chỗ", style: TMLabsTextStyle.title),
          if (rulesHtml != null && rulesHtml.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Html(
                data: rulesHtml,
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(14),
                    color: TMLabsColor.grey,
                  ),
                },
              ),
            ),
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
