import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

class CustomSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String hintText;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const CustomSearchAppBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.hintText = 'Search keyword',
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  State<CustomSearchAppBar> createState() => _CustomSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: widget.showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
              onPressed: widget.onBackPressed ?? () => Navigator.maybePop(context),
            )
          : null,
      titleSpacing: widget.showBackButton ? 10 : 16,
      title: Container(
        height: 36,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(color: AppColor.basicSearchBg, borderRadius: BorderRadius.circular(18)),
        child: TextField(
          controller: widget.controller,
          onChanged: (value) {
            // Cập nhật giao diện ngay lập tức để ẩn/hiện nút xóa (cancel icon)
            setState(() {});
            // Debounce sự kiện tìm kiếm để tránh spam API
            EasyDebounce.debounce('custom-search-app-bar-debounce', const Duration(milliseconds: 500), () => widget.onChanged(value));
          },
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: AppColor.basicSecondaryText, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: AppColor.basicSecondaryText, size: 30),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.cancel, color: AppColor.basicSecondaryText, size: 16),
                    onPressed: () {
                      widget.onClear();
                      setState(() {}); // Cập nhật lại UI khi xóa
                    },
                  )
                : null,
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ),
    );
  }
}
