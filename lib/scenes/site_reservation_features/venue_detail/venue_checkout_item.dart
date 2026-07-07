import 'package:coffee_bean/data/model/response/hub/venue_schedule.dart';
import 'package:coffee_bean/scenes/checkout_order/checkout_order_common.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/note_picker_modal.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:db_core/commons_constants.dart';
import 'package:db_core/utils/ui_control/selection_row.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';

class VenueCheckoutItem extends CheckoutItemContract {
  final int venueId;
  final String venueName;
  final String venueLocation;
  final String venueOpeningHours;
  final String venueTypeName;
  final String? venueImageUrl;
  final List<VenueSlot> selectedSlots;

  // --- STATE DỮ LIỆU ---
  String _note = "";

  VenueCheckoutItem({
    required this.venueId,
    required this.venueName,
    required this.venueLocation,
    required this.venueOpeningHours,
    required this.venueTypeName,
    required this.selectedSlots,
    this.venueImageUrl,
  }) {
    isValidNotifier.value = true; // Luôn hợp lệ vì chỉ có note tùy chọn
  }

  @override
  double get baseAmount => selectedSlots.fold(0, (sum, slot) => sum + (slot.slotPrice ?? 0));

  @override
  String get category => "VENUE";

  @override
  Dictionary get extraData => {
    "venue_id": venueId,
    "venue_type_name": venueTypeName,
    "note": _note,
    "slots": selectedSlots
        .map(
          (s) => {
            "space_id": s.spaceId,
            "slot_date": s.slotDate,
            "slot_start_time": s.slotStartTime,
            "slot_price": s.slotPrice,
          },
        )
        .toList(),
  };

  @override
  String? get imageUrl => venueImageUrl;

  @override
  String get subTitle => venueLocation;

  @override
  String get title => venueName;

  @override
  Widget? buildSummaryWidget(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        // 1. Thông tin địa điểm
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                DbCachedImageWidget(
                  imageUrl: imageUrl!,
                  width: 100,
                  height: 70,
                  borderRadius: 8,
                )
              else
                Container(
                  width: 100,
                  height: 70,
                  decoration: BoxDecoration(
                    color: TMLabsColor.bgLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image_outlined, color: Colors.grey),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TMLabsTextStyle.bodyBold.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.red),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            subTitle,
                            style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: TMLabsColor.grey),
                        const SizedBox(width: 4),
                        Text(
                          venueOpeningHours,
                          style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // 2. Chi tiết đặt lịch (Giống VenuePaymentSlotsCard)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("CHI TIẾT ĐẶT LỊCH", style: TMLabsTextStyle.title),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text("Khung giờ", style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey)),
                  ),
                  Expanded(
                    child: Center(
                      child: Text("Loại hình", style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey)),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("Giá", style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: TMLabsColor.bgLight),
              const SizedBox(height: 12),
              ...selectedSlots.map((slot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(slot.slotDate ?? "", style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.grey)),
                            Text(slot.slotStartTime ?? "", style: TMLabsTextStyle.bodyBold),
                          ],
                        ),
                      ),
                      Expanded(child: Text(slot.spaceName ?? "---", style: TMLabsTextStyle.body)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(slot.slotPrice.toFormatPrice(), style: TMLabsTextStyle.bodyBold),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget? buildOptionsWidget(BuildContext context) {
    return Column(
      children: [
        _VenueOptionsWidget(item: this),
        _VenueRulesWidget(),
      ],
    );
  }
}

class _VenueOptionsWidget extends StatefulWidget {
  final VenueCheckoutItem item;
  const _VenueOptionsWidget({required this.item});

  @override
  State<_VenueOptionsWidget> createState() => _VenueOptionsWidgetState();
}

class _VenueOptionsWidgetState extends State<_VenueOptionsWidget> {
  @override
  Widget build(BuildContext context) {
    return DbSelectionRow(
      title: "Ghi chú",
      titleStyle: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold),
      value: widget.item._note.isEmpty ? "..........." : widget.item._note,
      valueStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      borderRadius: BorderRadius.circular(26),
      onTap: () async {
        final result = await NotePickerModal.show(
          context: context,
          title: "Ghi chú thêm",
          initialValue: widget.item._note,
        );
        if (result != null) {
          setState(() {
            widget.item._note = result;
          });
        }
      },
    );
  }
}

class _VenueRulesWidget extends StatelessWidget {
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
