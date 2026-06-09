/*
 * Created with IntelliJ IDEA
 * Package: widget
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 21/06/2022 - 17:41
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';

/// FadeIndexedStack: Một phiên bản nâng cấp của IndexedStack tích hợp hiệu ứng chuyển cảnh Fade.
///
/// Chức năng:
/// - Thay đổi giữa các widget con dựa trên index mà không làm mất trạng thái (State) của chúng.
/// - Thêm hiệu ứng mờ dần (Fade transition) khi chuyển đổi giữa các index để tạo cảm giác mượt mà.
///
/// Ứng dụng:
/// - Sử dụng chủ yếu cho Bottom TabBar (như MainTabbarPage) để chuyển đổi giữa các màn hình chính.
/// - Dùng cho các thành phần UI có nhiều View con cần chuyển đổi qua lại nhanh chóng mà vẫn muốn giữ trạng thái
///   (ví dụ: các bước trong một quy trình, switch giữa các chế độ xem danh sách/bản đồ).
///
/// Cách dùng tương tự:
/// - Có thể thay thế cho IndexedStack ở bất kỳ đâu trong dự án khi muốn tăng trải nghiệm UX với hiệu ứng chuyển động nhẹ nhàng.
class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 300,),
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );
  }
}
