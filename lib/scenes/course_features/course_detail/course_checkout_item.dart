import 'package:coffee_bean/features/checkout_order/checkout_order_common.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/phone_input_field.dart';
import 'package:db_core/commons_constants.dart';
import 'package:flutter/material.dart';

class CourseCheckoutItem extends CheckoutItemContract {
  final int courseId;
  final String courseTitle;
  final String instructorName;
  final String? courseImageUrl;
  final double coursePrice;

  // --- STATE DỮ LIỆU ---
  String _studentName;
  String _phoneNumber;
  String _address = "";
  bool _isPhoneValid = false;

  CourseCheckoutItem({
    required this.courseId,
    required this.courseTitle,
    required this.instructorName,
    required this.coursePrice,
    this.courseImageUrl,
    String initialNickname = "",
    String initialPhone = "",
  })  : _studentName = initialNickname,
        _phoneNumber = initialPhone {
    _isPhoneValid = _phoneNumber.isNotEmpty;
    _validate();
  }

  @override
  double get baseAmount => coursePrice;

  @override
  String get category => "COURSE";

  @override
  Dictionary get extraData => {
        "course_id": courseId,
        "student_name": _studentName,
        "contact_phone": _phoneNumber,
        "delivery_address": _address,
      };

  @override
  String? get imageUrl => courseImageUrl;

  @override
  String get subTitle => "Giảng viên: $instructorName";

  @override
  String get title => courseTitle;

  @override
  Widget? buildSummaryWidget(BuildContext context) => null;

  // --- LOGIC OPTIONS ---

  @override
  Widget? buildOptionsWidget(BuildContext context) {
    return _CourseOptionsWidget(item: this);
  }

  void _validate() {
    // Yêu cầu nhập đầy đủ các trường
    final bool isNameOk = _studentName.trim().isNotEmpty;
    final bool isAddressOk = _address.trim().isNotEmpty;

    isValidNotifier.value = isNameOk && isAddressOk && _isPhoneValid;
  }
}

// --- UI COMPONENT (Dùng trong cùng file) ---

class _CourseOptionsWidget extends StatefulWidget {
  final CourseCheckoutItem item;
  const _CourseOptionsWidget({required this.item});

  @override
  State<_CourseOptionsWidget> createState() => _CourseOptionsWidgetState();
}

class _CourseOptionsWidgetState extends State<_CourseOptionsWidget> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item._studentName);
    _addressController = TextEditingController(text: widget.item._address);
    _phoneController = TextEditingController(text: widget.item._phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "THÔNG TIN NHẬN KHÓA HỌC",
            style: TMLabsTextStyle.title,
          ),
          const SizedBox(height: 24),

          // 1. Tên học viên
          TextField(
            controller: _nameController,
            style: TMLabsTextStyle.body,
            decoration: InputDecoration(
              labelText: "Tên học viên *",
              labelStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
              hintText: "Nhập họ và tên",
              hintStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.lightGrey),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: TMLabsColor.lightGrey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: TMLabsColor.primary),
              ),
            ),
            onChanged: (val) {
              widget.item._studentName = val;
              widget.item._validate();
            },
          ),
          const SizedBox(height: 24),

          // 2. Số điện thoại
          const Text(
            "Số điện thoại liên lạc *",
            style: TMLabsTextStyle.caption,
          ),
          PhoneInputField(
            countryCodes: const ["+84", "+65", "+1", "+86"], // Cung cấp danh sách mã vùng
            initialCountryCode: "+84",
            controller: _phoneController,
            style: TMLabsTextStyle.body,
            underlineColor: TMLabsColor.lightGrey,
            activeUnderlineColor: TMLabsColor.primary,
            onChanged: (phoneValue) {
              widget.item._phoneNumber = phoneValue.fullNumber;
              widget.item._isPhoneValid = phoneValue.isValid;
              widget.item._validate();
            },
            underlineWidth: 1.0,
          ),
          const SizedBox(height: 24),

          // 3. Địa chỉ
          TextField(
            controller: _addressController,
            maxLines: null,
            style: TMLabsTextStyle.body,
            decoration: InputDecoration(
              labelText: "Địa chỉ nhận tài liệu/thông tin *",
              labelStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
              hintText: "Số nhà, tên đường, phường/xã...",
              hintStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.lightGrey),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: TMLabsColor.lightGrey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: TMLabsColor.primary),
              ),
            ),
            onChanged: (val) {
              widget.item._address = val;
              widget.item._validate();
            },
          ),
        ],
      ),
    );
  }
}
