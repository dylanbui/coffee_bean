import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_interactor.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:db_core/utils/flash_utils/flash_dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';

// ignore: must_be_immutable
class DialogDemoPage extends CubitStateFulWidget<DialogDemoInteractor, DialogDemoState> {
  DialogDemoPage({super.key, required super.interactor});

  @override
  State<DialogDemoPage> createState() => _DialogDemoPageState();
}

class _DialogDemoPageState extends CubitState<DialogDemoPage, DialogDemoInteractor, DialogDemoState> {
  @override
  void initState() {
    super.initState();
    // Khởi tạo Style Provider cho dự án Coffee Bean
    DbFlashDialogHelper.init(CoffeeDialogStyleProvider());
  }

  @override
  dynamic getAppBar(BuildContext context) => "Flash Dialog Demo";

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<DialogDemoInteractor, DialogDemoState>(
      listener: (context, state) {
        if (state is DialogDemoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle("1. Shorthand Dialogs (Hàm nhanh)"),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () => DbFlashDialogHelper.success(context, "Đã lưu thông tin thành công!"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: const Text("Success"),
                  ),
                  ElevatedButton(
                    onPressed: () => DbFlashDialogHelper.error(context, "Không thể kết nối tới máy chủ."),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: const Text("Error"),
                  ),
                  ElevatedButton(
                    onPressed: () => DbFlashDialogHelper.info(context, "Hệ thống sẽ bảo trì vào 12h đêm nay."),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    child: const Text("Info"),
                  ),
                  ElevatedButton(
                    onPressed: () => DbFlashDialogHelper.warning(context, "Dung lượng bộ nhớ sắp đầy."),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                    child: const Text("Warning"),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle("2. Confirmation (2 Buttons)"),
              ElevatedButton(
                onPressed: () => _showConfirmDialog(),
                child: const Text("Xác nhận xóa tài khoản"),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle("3. Vertical Layout (3+ Buttons)"),
              ElevatedButton(
                onPressed: () => _showMultiActionsDialog(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
                child: const Text("Tùy chọn đăng bài"),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle("4. Custom Body (Form Dialog)"),
              ElevatedButton(
                onPressed: () => _showFeedbackForm(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                child: const Text("Gửi phản hồi khách hàng"),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle("5. Persistent Dialog (Bắt buộc chọn)"),
              ElevatedButton(
                onPressed: () => _showPersistentDialog(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                child: const Text("Cập nhật phần mềm"),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle("6. Full Screen Form (Custom Size)"),
              ElevatedButton(
                onPressed: () => _showRegisterForm(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade900, foregroundColor: Colors.white),
                child: const Text("Đăng ký tài khoản mới"),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle("7. AppLabel Showcase (AutoSizeText)"),
              const Text("Dưới đây là các ví dụ về AppLabel với khả năng tự co giãn font:", 
                style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // 1. Basic Badge
                  const AppLabel(
                    "HOT",
                    backgroundColor: Colors.red,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),

                  // 2. Rounded with Border
                  const AppLabel(
                    "Premium Member",
                    backgroundColor: Colors.amberAccent,
                    borderColor: Colors.orange,
                    borderRadius: 20,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    style: TextStyle(color: Colors.black87, fontSize: 12),
                  ),

                  // 3. AUTO-RESIZE: Cố định rộng 120px, text rất dài
                  // Bạn sẽ thấy chữ tự thu nhỏ lại để vừa khít 120px
                  const AppLabel(
                    "Văn bản này quá dài cho một nhãn nhỏ",
                    width: 120,
                    height: 32,
                    backgroundColor: Colors.blue,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    minFontSize: 8,
                  ),

                  // 4. Fixed size with alignment
                  const AppLabel(
                    "Align Left",
                    width: 100,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colors.teal,
                    style: TextStyle(color: Colors.white),
                  ),

                  // 5. MaxLines = 2 với AutoSize
                  const AppLabel(
                    "Dòng 1 dài và dòng 2 cũng rất dài nên phải thu nhỏ",
                    width: 150,
                    height: 50,
                    maxLines: 2,
                    backgroundColor: Colors.purple,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    minFontSize: 9,
                  ),

                  // 6. Sử dụng Config để tạo Style đồng bộ
                  const AppLabel(
                    "DÙNG CONFIG",
                    config: AppLabelStyleConfig(
                      backgroundColor: Colors.black87,
                      borderRadius: 0,
                      padding: EdgeInsets.all(8),
                      minFontSize: 10,
                    ),
                    style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                  ),

                  // 7. NEW: Leading Icon & Theme Integration
                  // Sẽ tự lấy màu Primary của App nếu không set background
                  const AppLabel(
                    "Verified",
                    leadingIcon: Icon(Icons.verified, color: Colors.white, size: 14),
                    borderRadius: 8,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),

                  // 8. NEW: Gradient & Shadow (Premium Look)
                  const AppLabel(
                    "PREMIUM PLAN",
                    gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
                    shadows: [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                    borderRadius: 12,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),

                  // 9. NEW: MainAxisSize.max (Dãn hết chiều ngang)
                  const AppLabel(
                    "STATUS: ĐANG CHỜ XỬ LÝ (FULL WIDTH)",
                    mainAxisSize: MainAxisSize.max,
                    backgroundColor: Colors.orangeAccent,
                    padding: EdgeInsets.all(10),
                    borderRadius: 0,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)),
    );
  }

  // --- LOGIC XỬ LÝ ---

  void _showConfirmDialog() async {
    final result = await DbFlashDialogHelper.show<bool>(
      context: context,
      title: "Xác nhận",
      content: "Bạn có chắc chắn muốn xóa tài khoản này không? Hành động này không thể hoàn tác.",
      actions: [
        const DbFlashDialogAction(label: "HỦY", value: false, color: Colors.grey),
        const DbFlashDialogAction(label: "XÓA NGAY", value: true, color: Colors.red),
      ],
    );

    if (result == true) {
      _showResultSnackBar("Đã thực hiện lệnh xóa!");
    }
  }

  void _showMultiActionsDialog() async {
    final result = await DbFlashDialogHelper.show<String>(
      context: context,
      title: "Lưu thay đổi",
      content: "Bạn muốn làm gì với nội dung vừa chỉnh sửa?",
      actions: [
        const DbFlashDialogAction(label: "Đăng công khai", value: "publish"),
        const DbFlashDialogAction(label: "Lưu bản nháp", value: "draft"),
        const DbFlashDialogAction(label: "Hủy bỏ", value: "cancel", color: Colors.red),
      ],
    );

    if (result != null) _showResultSnackBar("Bạn đã chọn: $result");
  }

  void _showFeedbackForm() {
    final controller = TextEditingController();
    DbFlashDialogHelper.show<String>(
      context: context,
      title: "Ý kiến của bạn",
      content: "Vui lòng cho Coffee Bean biết trải nghiệm của bạn.",
      persistent: true,
      body: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: "Nhập nội dung tại đây...",
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
      actions: [
        DbFlashDialogAction(
          label: "GỬI PHẢN HỒI",
          value: "send",
          onPressed: () => _showResultSnackBar("Nội dung: ${controller.text}"),
        ),
      ],
    );
  }

  void _showPersistentDialog() {
    DbFlashDialogHelper.show(
      context: context,
      persistent: true,
      barrierDismissible: false, // Bắt buộc tương tác, không thể đóng bằng cách chạm vùng đen
      title: "Phiên bản mới",
      content: "Đã có phiên bản 2.0. Vui lòng cập nhật để tiếp tục sử dụng dịch vụ.",
      actions: [
        const DbFlashDialogAction(label: "CẬP NHẬT NGAY", value: "update"),
      ],
    );
  }

  void _showRegisterForm() {
    DbFlashDialogHelper.show(
      context: context,
      title: "ĐĂNG KÝ THÀNH VIÊN",
      content: "Vui lòng nhập đầy đủ thông tin bên dưới",
      barrierDismissible: false, // Chỉ cho phép đóng bằng nút bấm
      body: SingleChildScrollView( // Bọc nội dung để đẩy lên khi có bàn phím
        child: Column(
          children: [
            _buildTextField("Tên đăng nhập", Icons.person),
            const SizedBox(height: 12),
            _buildTextField("Mật khẩu", Icons.lock, obscure: true),
            const SizedBox(height: 12),
            _buildTextField("Họ và tên", Icons.badge),
            const SizedBox(height: 12),
            _buildTextField("Email", Icons.badge),
            const SizedBox(height: 12),
            _buildTextField("Địa chỉ", Icons.home, maxLines: 2),
          ],
        ),
      ),
      actions: [
        DbFlashDialogAction(label: "ĐÓNG", value: "close", color: Colors.grey),
        DbFlashDialogAction(label: "ĐĂNG KÝ NGAY", value: "register", color: Colors.brown),
      ],
    ).then((res) {
      if (res == "register") _showResultSnackBar("Đã gửi yêu cầu đăng ký!");
    });
  }

  Widget _buildTextField(String label, IconData icon, {bool obscure = false, int maxLines = 1}) {
    return TextField(
      obscureText: obscure,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _showResultSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}

/// Style Provider đặc trưng cho Coffee Bean Project
class CoffeeDialogStyleProvider extends DbFlashDialogStyleProvider {
  @override
  DbFlashDialogStyle getStyle() {
    return const DbFlashDialogStyle(
      borderRadius: 24.0,
      primaryActionColor: Colors.brown,
      padding: EdgeInsets.fromLTRB(24, 30, 24, 20),
    );
  }

  @override
  Widget? getIcon(DbFlashDialogType type) {
    switch (type) {
      case DbFlashDialogType.info:
        return const Icon(Icons.info_outline, color: Colors.blue, size: 44);
      case DbFlashDialogType.success:
        return const Icon(Icons.check_circle_outline, color: Colors.green, size: 44);
      case DbFlashDialogType.error:
        return const Icon(Icons.highlight_off, color: Colors.red, size: 44);
      case DbFlashDialogType.warning:
        return const Icon(Icons.error_outline, color: Colors.orange, size: 44);
    }
  }

  @override
  String getDefaultTitle(DbFlashDialogType type) {
    switch (type) {
      case DbFlashDialogType.info:
        return "Thông báo";
      case DbFlashDialogType.success:
        return "Thành công";
      case DbFlashDialogType.error:
        return "Lỗi hệ thống";
      case DbFlashDialogType.warning:
        return "Lưu ý";
    }
  }
}
