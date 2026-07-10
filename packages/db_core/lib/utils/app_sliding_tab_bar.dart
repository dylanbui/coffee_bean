import 'package:flutter/material.dart';
import 'package:db_core/utils/common_style.dart';

/// Model cho từng Tab Item
class AppTabItem<T> {
  final T value;
  final String label;
  final Widget? leftIcon;
  final Widget? rightIcon;

  AppTabItem({
    required this.value,
    required this.label,
    this.leftIcon,
    this.rightIcon,
  });
}

/// Widget TabBar chính hỗ trợ Sliding Underline hoặc Background
class AppSlidingTabBar<T> extends StatefulWidget {
  final List<AppTabItem<T>> items;
  final T currentItem;
  final TabIndicatorMode mode;
  final ValueChanged<T> onTabChanged;
  final AppSlidingTabBarStyle style;

  const AppSlidingTabBar({
    super.key,
    required this.items,
    required this.currentItem,
    required this.onTabChanged,
    this.mode = TabIndicatorMode.underline,
    this.style = AppSlidingTabBarStyle.defaultStyle,
  });

  @override
  State<AppSlidingTabBar<T>> createState() => _AppSlidingTabBarState<T>();
}

class _AppSlidingTabBarState<T> extends State<AppSlidingTabBar<T>> {
  final Map<T, GlobalKey> _itemKeys = {};
  final GlobalKey _containerKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  double _indicatorLeft = 0;
  double _indicatorWidth = 0;
  double _indicatorHeight = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _generateKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicator(animate: false));
  }

  @override
  void didUpdateWidget(covariant AppSlidingTabBar<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentItem != widget.currentItem || oldWidget.items.length != widget.items.length) {
      if (oldWidget.items.length != widget.items.length) {
        _generateKeys();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicator());
    }
  }

  void _generateKeys() {
    for (var item in widget.items) {
      _itemKeys[item.value] = GlobalKey();
    }
  }

  void _updateIndicator({bool animate = true}) {
    final selectedKey = _itemKeys[widget.currentItem];
    final containerCtx = _containerKey.currentContext;
    final selectedCtx = selectedKey?.currentContext;

    if (selectedCtx != null && containerCtx != null) {
      final box = selectedCtx.findRenderObject() as RenderBox;
      final containerBox = containerCtx.findRenderObject() as RenderBox;

      final position = box.localToGlobal(Offset.zero, ancestor: containerBox);

      setState(() {
        _indicatorLeft = position.dx;
        _indicatorWidth = box.size.width;
        _indicatorHeight = box.size.height;
      });

      // TỰ TÍNH TOÁN VÀ CUỘN NGANG (Chỉ tác động đến thanh TabBar)
      if (_scrollController.hasClients) {
        final viewportWidth = _scrollController.position.viewportDimension;
        final maxScroll = _scrollController.position.maxScrollExtent;
        
        // Tính toán offset để đưa tab vào giữa thanh cuộn ngang
        double targetOffset = _indicatorLeft - (viewportWidth / 2) + (_indicatorWidth / 2);
        targetOffset = targetOffset.clamp(0.0, maxScroll);

        _scrollController.animateTo(
          targetOffset,
          duration: animate ? const Duration(milliseconds: 300) : Duration.zero,
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Stack(
        key: _containerKey,
        children: [
          // LỚP 1: Indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _indicatorLeft,
            width: _indicatorWidth,
            top: widget.mode == TabIndicatorMode.underline ? _indicatorHeight - widget.style.indicatorHeight : 0,
            height: widget.mode == TabIndicatorMode.underline ? widget.style.indicatorHeight : _indicatorHeight,
            child: Container(
              decoration: BoxDecoration(
                color: widget.style.activeColor,
                borderRadius: BorderRadius.circular(
                  widget.mode == TabIndicatorMode.background ? widget.style.indicatorRadius : 0,
                ),
              ),
            ),
          ),

          // LỚP 2: Các Tab Items
          Row(
            children: widget.items.map((item) {
              final isSelected = item.value == widget.currentItem;

              return Padding(
                padding: EdgeInsets.only(right: item == widget.items.last ? 0 : widget.style.spacing),
                child: GestureDetector(
                  key: _itemKeys[item.value],
                  onTap: () => widget.onTabChanged(item.value),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: widget.style.itemPadding,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.leftIcon != null) ...[
                          _buildIcon(item.leftIcon!, isSelected),
                          const SizedBox(width: 6),
                        ],
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: ((isSelected ? widget.style.activeStyle : widget.style.inactiveStyle) ??
                                  TextStyle(
                                    color: isSelected ? widget.style.activeColor : widget.style.inactiveColor,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 14,
                                  ))
                              .copyWith(
                            color: (widget.mode == TabIndicatorMode.background && isSelected)
                                ? (widget.style.activeTextColor ?? Colors.white)
                                : (isSelected ? widget.style.activeColor : widget.style.inactiveColor),
                          ),
                          child: Text(item.label),
                        ),
                        if (item.rightIcon != null) ...[
                          const SizedBox(width: 6),
                          _buildIcon(item.rightIcon!, isSelected),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(Widget icon, bool isSelected) {
    if (icon is Icon) {
      return Icon(
        icon.icon,
        size: icon.size ?? 18,
        color: (widget.mode == TabIndicatorMode.background && isSelected)
            ? (widget.style.activeTextColor ?? Colors.white)
            : (isSelected ? widget.style.activeColor : widget.style.inactiveColor),
      );
    }
    return icon;
  }
}
