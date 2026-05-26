import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean/utils/flash_utils/date_time_ext.dart';
import 'package:coffee_bean/utils/flash_utils/flash_calendar_config.dart';
import 'package:coffee_bean/utils/flash_utils/flash_calendar_helper.dart';
import 'package:coffee_bean/utils/flash_utils/flash_date_helper.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flash/flash.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/interactor/flash_demo_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/interactor/flash_demo_event_state.dart';

//ignore: must_be_immutable
class FlashDemoPage extends CubitStateFulWidget<FlashDemoInteractor, FlashDemoState> {
  FlashDemoPage({super.key, required super.interactor});

  @override
  State<FlashDemoPage> createState() => _FlashDemoPageState();
}

class _FlashDemoPageState extends CubitState<FlashDemoPage, FlashDemoInteractor, FlashDemoState> {
  
  @override
  dynamic getAppBar(BuildContext context) => "Flash Library Demo";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<FlashDemoInteractor, FlashDemoState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // 1. Hiển thị giá trị đang chọn
              Card(
                color: Colors.brown.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Selected Value: ${state.selectedValue.isEmpty ? 'None' : state.selectedValue}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- PHẦN 1: FLASH DIALOG ---
              _buildSectionTitle("Flash Dialogs"),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () => context.showFlashSuccess("Lưu đơn hàng thành công!"),
                    child: const Text("Success"),
                  ),
                  ElevatedButton(
                    onPressed: () => context.showFlashError("Lỗi kết nối máy chủ!"),
                    child: const Text("Error"),
                  ),
                  ElevatedButton(
                    onPressed: () => _demoConfirmDialog(context),
                    child: const Text("Confirm Form"),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- PHẦN 2: FLASH MODAL ---
              _buildSectionTitle("Flash Modals"),
              ElevatedButton(
                onPressed: () => _demoBottomModal(context),
                child: const Text("Show Bottom Selection"),
              ),
              const SizedBox(height: 24),

              // --- PHẦN 3: FLASH CALENDAR & DATE ---
              _buildSectionTitle("Calendar & Date Time"),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white),
                    onPressed: () => _demoDateTimePicker(context),
                    child: const Text("Date & Time"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800, foregroundColor: Colors.white),
                    onPressed: () => _demoDatePickerOnly(context),
                    child: const Text("Date Only"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800, foregroundColor: Colors.white),
                    onPressed: () => _demoTimePickerOnly(context),
                    child: const Text("Time Only"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade800, foregroundColor: Colors.white),
                    onPressed: () => _demoDateRangePicker(context),
                    child: const Text("Range Date"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade800, foregroundColor: Colors.white),
                    onPressed: () => _demoDateMultiPicker(context),
                    child: const Text("Multi Date"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text("Timeline Preview (EasyDate):"),
              const SizedBox(height: 8),
              FlashDateHelper.buildTimeline(
                context,
                initialDate: DateTime.now(),
                onDateChange: (date) => dLog("Timeline: ${date.toStr()}"), //interactor.updateSelectedValue("Timeline: ${date.toStr()}"),
              ),
              const SizedBox(height: 24),

              // --- PHẦN 4: FLASH IMAGE GALLERY ---
              _buildSectionTitle("Image Gallery"),
              GestureDetector(
                onTap: () => context.showPhotoGallery(
                  imageUrls: [
                    "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085",
                    "https://images.unsplash.com/photo-1509042239860-f550ce710b93",
                  ],
                  heroPrefix: "demo_img",
                ),
                child: Hero(
                  tag: "demo_img_0",
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage("https://images.unsplash.com/photo-1495474472287-4d71bcdd2085"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(child: Icon(Icons.zoom_in, color: Colors.white, size: 40)),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                "Selected Value: ${state.selectedValue.isEmpty ? 'None' : state.selectedValue}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _showTopModal(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                child: const Text("Show Top Modal (Selector)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showTopModalScrollItem(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                child: const Text("Show Top Modal (Scroll Arrow)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showBottomModal(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                child: const Text("Show Bottom Modal (Keyboard Test)"),
              ),
            ],
          ),
        ),
      );
    },
    );
  }

  void _showTopModal(BuildContext context) {
    showFlash(
      context: context,
      persistent: true, // Quan trọng: Modal cần persistent = true để không bị tự đóng
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          position: FlashPosition.top,
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              // Đảm bảo chiều ngang chiếm toàn bộ màn hình
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // Giới hạn chiều cao để kích hoạt scroll (ví dụ 45% màn hình)
                    maxHeight: MediaQuery.of(context).size.height * 0.45,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Select Category", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              _buildSelectorItem(context, controller, "Cà phê Arabica"),
                              _buildSelectorItem(context, controller, "Cà phê Robusta"),
                              _buildSelectorItem(context, controller, "Cà phê Moka"),
                              _buildSelectorItem(context, controller, "Cà phê Culi"),
                              _buildSelectorItem(context, controller, "Cà phê Arabica 2"),
                              _buildSelectorItem(context, controller, "Cà phê Robusta 2"),
                              _buildSelectorItem(context, controller, "Cà phê Moka 2"),
                              _buildSelectorItem(context, controller, "Cà phê Culi 2"),
                              _buildSelectorItem(context, controller, "Cà phê Robusta cuối"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTopModalScrollItem(BuildContext context) {
    showFlash(
      context: context,
      persistent: true,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context, controller) {
        bool showArrow = false; 

        return StatefulBuilder(
          builder: (context, setState) {
            return Flash(
              controller: controller,
              position: FlashPosition.top,
              child: Align(
                alignment: Alignment.topCenter,
                child: Material(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.45,
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("Scroll down for more", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Flexible(
                              child: NotificationListener<Notification>(
                                onNotification: (notification) {
                                  // Lắng nghe cả ScrollMetricsNotification (cho lần đầu) 
                                  // và ScrollNotification (khi đang scroll)
                                  if (notification is ScrollMetricsNotification || notification is ScrollNotification) {
                                    final metrics = (notification is ScrollMetricsNotification) 
                                        ? notification.metrics 
                                        : (notification as ScrollNotification).metrics;

                                    final bool canScroll = metrics.maxScrollExtent > 0;
                                    final bool isAtBottom = metrics.pixels >= metrics.maxScrollExtent - 10;
                                    
                                    final shouldShow = canScroll && !isAtBottom;
                                    if (showArrow != shouldShow) {
                                      // Sử dụng Future.microtask để tránh lỗi setState khi đang build
                                      Future.microtask(() => setState(() => showArrow = shouldShow));
                                    }
                                  }
                                  return false;
                                },
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  children: [
                                    _buildSelectorItem(context, controller, "Item 1 - Scroll test"),
                                    _buildSelectorItem(context, controller, "Item 2"),
                                    _buildSelectorItem(context, controller, "Item 3"),
                                    _buildSelectorItem(context, controller, "Item 4"),
                                    _buildSelectorItem(context, controller, "Item 5"),
                                    _buildSelectorItem(context, controller, "Item 6"),
                                    _buildSelectorItem(context, controller, "Item 7"),
                                    _buildSelectorItem(context, controller, "Item 8"),
                                    _buildSelectorItem(context, controller, "Item 9"),
                                    _buildSelectorItem(context, controller, "Item 10 - End"),
                                  ],
                                ),
                              ),
                            ),
                            if (showArrow)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 24),
                              ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBottomModal(BuildContext context) {
    showFlash(
      context: context,
      persistent: true,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          position: FlashPosition.bottom,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              // Đẩy nội dung lên khi bàn phím xuất hiện
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Material(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: SizedBox(
                  // SỬ DỤNG CHIỀU RỘNG MÀN HÌNH CỤ THỂ THAY CHO INFINITY
                  width: MediaQuery.of(context).size.width,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      // Giới hạn đúng 50% chiều cao màn hình theo yêu cầu
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Feedback Form (50% Height)",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    hintText: "Nhập nội dung phản hồi...",
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity, // Ở đây dùng được vì đã có SizedBox cha giới hạn
                                  child: ElevatedButton(
                                    onPressed: () => controller.dismiss(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: const Text("Submit"),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectorItem(BuildContext context, FlashController controller, String value) {
    return ListTile(
      title: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        interactor.onValueSelected(value);
        controller.dismiss();
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  // --- LOGIC XỬ LÝ DEMO ---

  void _demoConfirmDialog(BuildContext context) {
    final nameController = TextEditingController();
    final noteController = TextEditingController();

    context.showFlashConfirm<String>(
      title: "Thông tin góp ý",
      content: "Vui lòng nhập phản hồi cho Coffee Bean",
      persistent: true,
      body: Column(
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(hintText: "Tên của bạn")),
          const SizedBox(height: 10),
          TextField(controller: noteController, maxLines: 3, decoration: const InputDecoration(hintText: "Nội dung...")),
        ],
      ),
      actions: [
        FlashDialogAction(label: "Gửi", value: "send", color: Colors.brown),
      ],
    ).then((res) {
      if (res == "send") {
        dLog("Feedback: ${nameController.text}");
      }
        //interactor.updateSelectedValue("Feedback: ${nameController.text}");
    });
  }

  void _demoBottomModal(BuildContext context) {
    context.showFlashModal<String>(
      title: "Chọn loại cà phê",
      child: Builder(
        builder: (innerContext) => Column(
          children: ["Arabica", "Robusta", "Moka"].map((e) => ListTile(
            title: Text(e),
            onTap: () => Navigator.pop(innerContext, e),
          )).toList(),
        ),
      ),
    ).then((val) {
      // if (val != null) interactor.updateSelectedValue(val);
    });
  }

  void _demoDateTimePicker(BuildContext context) async {
    final res = await FlashCalendarHelper.showPicker(
      context: context,
      title: "Đặt lịch hẹn",
      mode: FlashDateTimePickerMode.dateTime,
    );
    if (res != null) {
      String dateStr = res.selectedDates.first.toStr();
      String timeStr = res.selectedTime?.format(context) ?? "";
      interactor.updateSelectedValue("Lịch: $dateStr - $timeStr");
    }
  }

  void _demoDatePickerOnly(BuildContext context) async {
    final res = await FlashCalendarHelper.showPicker(
      context: context,
      title: "Chọn ngày",
      mode: FlashDateTimePickerMode.dateOnly,
    );
    if (res != null) {
      String dateStr = res.selectedDates.first.toStr();
      interactor.updateSelectedValue("Ngày: $dateStr");
    }
  }

  void _demoTimePickerOnly(BuildContext context) async {
    final res = await FlashCalendarHelper.showPicker(
      context: context,
      title: "Chọn giờ",
      mode: FlashDateTimePickerMode.timeOnly,
    );
    if (res != null) {
      String timeStr = res.selectedTime?.format(context) ?? "";
      interactor.updateSelectedValue("Giờ: $timeStr");
    }
  }

  void _demoDateRangePicker(BuildContext context) async {
    final res = await FlashCalendarHelper.showPicker(
      context: context,
      title: "Chọn khoảng ngày",
      mode: FlashDateTimePickerMode.dateOnly,
      selectionType: CalendarSelectionType.range,
    );
    if (res != null) {
      String rangeStr = "${res.rangeStart?.toStr() ?? "..."} - ${res.rangeEnd?.toStr() ?? "..."}";
      interactor.updateSelectedValue("Khoảng: $rangeStr");
    }
  }

  void _demoDateMultiPicker(BuildContext context) async {
    final res = await FlashCalendarHelper.showPicker(
      context: context,
      title: "Chọn nhiều ngày",
      mode: FlashDateTimePickerMode.dateOnly,
      selectionType: CalendarSelectionType.multi,
    );
    if (res != null) {
      interactor.updateSelectedValue("Đã chọn: ${res.selectedDates.length} ngày");
    }
  }

}
