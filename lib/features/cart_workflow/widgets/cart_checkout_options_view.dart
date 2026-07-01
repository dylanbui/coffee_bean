import 'package:coffee_bean/data/model/payment_domain.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/note_picker_modal.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class CartCheckoutOptionsView extends StatelessWidget {
  final ValueNotifier<DeliveryMethod> deliveryMethodNotifier;
  final ValueNotifier<String> noteNotifier;

  const CartCheckoutOptionsView({
    super.key, 
    required this.deliveryMethodNotifier, 
    required this.noteNotifier
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildDeliveryOption(context),
          const SizedBox(height: 20),
          _buildNoteOption(context),
        ],
      ),
    );
  }

  Widget _buildDeliveryOption(BuildContext context) {
    return Row(
      children: [
        Text("Hình thức nhận hàng", style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        ValueListenableBuilder(
          valueListenable: deliveryMethodNotifier,
          builder: (context, value, _) {
            return GroupButton<DeliveryMethod>(
              isRadio: true,
              onSelected: (val, index, isSelected) => deliveryMethodNotifier.value = val,
              buttons: const [DeliveryMethod.dineIn, DeliveryMethod.takeAway],
              controller: GroupButtonController(selectedIndex: value == DeliveryMethod.dineIn ? 0 : 1),
              buttonBuilder: (selected, val, context) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      selected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: selected ? TMLabsColor.primary : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 2),
                    Text(val == DeliveryMethod.dineIn ? "Dùng tại quán" : "Mang đi", style: TMLabsTextStyle.caption.copyWith(fontWeight: FontWeight.bold)),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildNoteOption(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await NotePickerModal.show(context: context, title: "Ghi chú", initialValue: noteNotifier.value);
        if (result != null) noteNotifier.value = result;
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Ghi chú", style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: noteNotifier,
                    builder: (context, value, _) {
                      return Text(
                        value.isEmpty ? "Nhập ghi chú" : value,
                        style: TMLabsTextStyle.body.copyWith(
                          color: value.isEmpty ? Colors.grey : TMLabsColor.deepNavy,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
