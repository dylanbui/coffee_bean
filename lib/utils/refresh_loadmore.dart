import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Các trạng thái của quá trình load-more
enum LoadStatus { idle, loading, error, completed }

class RefreshLoadmore extends StatefulWidget {
  /// Callback khi kéo xuống để refresh
  final Future<void> Function()? onRefresh;

  /// Callback khi cuộn xuống để load thêm
  final Future<void> Function()? onLoadmore;

  /// Callback riêng cho việc thử lại refresh khi bị lỗi
  final Future<void> Function()? onRetryRefresh;

  /// Đã hết dữ liệu chưa
  final bool isLastPage;

  /// Danh sách dữ liệu hiện tại có trống không
  final bool isEmpty;

  /// Danh sách các slivers để hiển thị (SliverList, SliverGrid, v.v.)
  final List<Widget> slivers;

  /// Widget hiển thị khi không có dữ liệu
  final Widget? emptyWidget;

  /// Widget hiển thị khi đã load hết dữ liệu
  final Widget? noMoreWidget;

  /// Widget hiển thị khi đang load thêm
  final Widget? loadingWidget;

  /// Widget hiển thị khi lỗi load thêm
  final Widget? errorWidget;

  /// Ngưỡng cách đáy để kích hoạt load-more
  final double loadMoreThreshold;

  /// ScrollController để điều khiển cuộn từ bên ngoài
  final ScrollController? controller;

  const RefreshLoadmore({
    super.key,
    required this.slivers,
    required this.isLastPage,
    this.isEmpty = false,
    this.onRefresh,
    this.onLoadmore,
    this.onRetryRefresh,
    this.emptyWidget,
    this.noMoreWidget,
    this.loadingWidget,
    this.errorWidget,
    this.loadMoreThreshold = 200,
    this.controller,
  });

  @override
  State<RefreshLoadmore> createState() => _RefreshLoadmoreState();
}

class _RefreshLoadmoreState extends State<RefreshLoadmore> {
  LoadStatus _loadMoreStatus = LoadStatus.idle;
  bool _refreshError = false;

  @override
  void didUpdateWidget(covariant RefreshLoadmore oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cập nhật trạng thái completed dựa trên isLastPage từ widget cha
    if (widget.isLastPage) {
      _loadMoreStatus = LoadStatus.completed;
    } else if (_loadMoreStatus == LoadStatus.completed) {
      _loadMoreStatus = LoadStatus.idle;
    }
  }

  /// Xử lý refresh dữ liệu
  Future<void> _handleRefresh() async {
    try {
      if (mounted) {
        setState(() {
          _refreshError = false;
          _loadMoreStatus = LoadStatus.idle;
        });
      }
      if (widget.onRefresh != null) {
        await widget.onRefresh!();
      }
    } catch (_) {
      if (mounted) setState(() => _refreshError = true);
    }
  }

  /// Xử lý retry khi refresh lỗi
  Future<void> _handleRetryRefresh() async {
    if (widget.onRetryRefresh != null) {
      try {
        if (mounted) setState(() => _refreshError = false);
        await widget.onRetryRefresh!();
      } catch (_) {
        if (mounted) setState(() => _refreshError = true);
      }
    } else {
      await _handleRefresh();
    }
  }

  /// Xử lý load thêm dữ liệu
  void _triggerLoadMore() async {
    if (_loadMoreStatus == LoadStatus.loading ||
        _loadMoreStatus == LoadStatus.completed ||
        widget.isLastPage ||
        widget.onLoadmore == null) {
      return;
    }

    if (mounted) {
      setState(() {
        _loadMoreStatus = LoadStatus.loading;
      });
    }

    try {
      await widget.onLoadmore!();
      if (mounted) {
        setState(() {
          _loadMoreStatus = widget.isLastPage ? LoadStatus.completed : LoadStatus.idle;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadMoreStatus = LoadStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Trường hợp: Lỗi khi refresh và danh sách đang trống
    if (_refreshError && widget.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.errorWidget ??
                  const Text(
                    "Đã có lỗi xảy ra khi tải dữ liệu",
                    textAlign: TextAlign.center,
                  ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _handleRetryRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text("Thử lại"),
              ),
            ],
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        // Chỉ kích hoạt load more khi cuộn tới ngưỡng ở danh sách chính
        if (scrollInfo.depth == 0 &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - widget.loadMoreThreshold) {
          _triggerLoadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          controller: widget.controller,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 2. Trường hợp: Danh sách trống
            if (widget.isEmpty && widget.emptyWidget != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: widget.emptyWidget),
              )
            else ...[
              // 3. Danh sách dữ liệu chính
              ...widget.slivers,

              // 4. Trạng thái dưới cùng (Loading/Error/Completed)
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: _buildBottomWidget(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomWidget() {
    switch (_loadMoreStatus) {
      case LoadStatus.loading:
        return widget.loadingWidget ?? const CupertinoActivityIndicator();
      case LoadStatus.error:
        return Column(
          children: [
            const Text("Không thể tải thêm dữ liệu"),
            TextButton(
              onPressed: _triggerLoadMore,
              child: const Text("Thử lại"),
            ),
          ],
        );
      case LoadStatus.completed:
        // Chỉ hiển thị "No more data" nếu không phải là trang đầu tiên trống
        if (widget.isEmpty) return const SizedBox.shrink();
        return widget.noMoreWidget ??
            Text(
              "Đã xem hết danh sách",
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            );
      case LoadStatus.idle:
        return const SizedBox.shrink();
    }
  }
}
