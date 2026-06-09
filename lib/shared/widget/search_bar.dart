import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearch;
  final int minLength;
  final Color? backgroundColor;
  final dynamic leftIcon; // Supports IconData or String (SVG)
  final dynamic rightIcon; // Supports IconData or String (SVG)
  final dynamic clearIcon;
  final double borderRadius;
  final double? height;

  const AppSearchBar({
    super.key,
    required this.onSearch,
    this.hintText = 'Tìm kiếm...',
    this.minLength = 5,
    this.backgroundColor,
    this.leftIcon,
    this.rightIcon,
    this.clearIcon = Icons.cancel,
    this.borderRadius = 25.0, // Default to capsule shape
    this.height,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _onChanged(String value) {
    if (value.length >= widget.minLength || value.isEmpty) {
      EasyDebounce.debounce(
        'search-debouncer',
        const Duration(milliseconds: 500),
        () => widget.onSearch(value),
      );
    }
    setState(() {}); // To update clear icon
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Center(
        child: TextField(
          controller: _controller,
          onChanged: _onChanged,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: widget.leftIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AppIcon(widget.leftIcon, color: Colors.grey, size: 18),
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(minWidth: 32, maxHeight: 32),
            suffixIcon: _buildSuffixIcon(),
            suffixIconConstraints: const BoxConstraints(minWidth: 32, maxHeight: 32),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    // If there is text, show clear icon
    if (_controller.text.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          _controller.clear();
          widget.onSearch('');
          FocusScope.of(context).unfocus();
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: AppIcon(widget.clearIcon, color: Colors.black, size: 20),
        ),
      );
    }

    // If no text, show rightIcon if provided
    if (widget.rightIcon != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AppIcon(widget.rightIcon, color: Colors.grey, size: 18),
      );
    }

    return null;
  }
}
