import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearch;
  final int minLength;
  final Color? backgroundColor;
  final IconData? searchIcon;
  final IconData? clearIcon;
  final double borderRadius;

  const SearchBar({
    super.key,
    required this.onSearch,
    this.hintText = 'Tìm kiếm...',
    this.minLength = 3, // Độ dài định trước để thực thi search
    this.backgroundColor,
    this.searchIcon = Icons.search,
    this.clearIcon = Icons.cancel,
    this.borderRadius = 20.0,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _onChanged(String value) {
    if (value.length >= 3) {
      // minLength của bạn
      EasyDebounce.debounce(
        'search-debouncer', // ID định danh
        Duration(milliseconds: 500), // Thời gian chờ
        () => widget.onSearch(value), // Hành động search
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: widget.backgroundColor ?? Colors.grey[200], borderRadius: BorderRadius.circular(widget.borderRadius)),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(widget.searchIcon, color: Colors.grey),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(widget.clearIcon, color: Colors.grey),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearch('');
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
