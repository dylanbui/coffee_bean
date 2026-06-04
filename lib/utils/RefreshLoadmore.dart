import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshLoadmore extends StatefulWidget {
  /// Callback function on pull down to refresh
  final Future<void> Function()? onRefresh;

  /// Callback function on pull up to load more data
  final Future<void> Function()? onLoadmore;

  /// Whether it is the last page, if it is true, you can not load more
  final bool isLastPage;

  /// Child widget | 子组件
  final Widget child;

  /// Prompt text widget when there is no more data at the bottom
  final Widget? noMoreWidget;

  /// Prompt widget when loading new data at the bottom
  final Widget? loadingWidget;

  /// Prompt padding for body if needed
  final EdgeInsetsGeometry? padding;

  /// You can use your custom scrollController, or not
  final ScrollController? scrollController;

  const RefreshLoadmore({
    super.key,
    required this.child,
    required this.isLastPage,
    this.onRefresh,
    this.onLoadmore,
    this.noMoreWidget,
    this.loadingWidget,
    this.padding,
    this.scrollController,
  });

  @override
  _RefreshLoadmoreState createState() => _RefreshLoadmoreState();
}

class _RefreshLoadmoreState extends State<RefreshLoadmore> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  ScrollController? _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController!.addListener(() async {
      if (_scrollController!.position.pixels >=
          _scrollController!.position.maxScrollExtent) {
        if (_isLoading) {
          return;
        }

        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }

        if (!widget.isLastPage && widget.onLoadmore != null) {
          await widget.onLoadmore!();
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    if (widget.scrollController == null) _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainWiget = ListView(
      /// Solve the problem that there are too few items to pull down and refresh | 解决item太少，无法下拉刷新的问题
      physics: AlwaysScrollableScrollPhysics(),
      padding: widget.padding,
      controller: _scrollController,
      children: <Widget>[
        widget.child,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: _isLoading
                  ? widget.loadingWidget ?? CupertinoActivityIndicator()
                  : widget.isLastPage
                  ? widget.noMoreWidget ??
                  Text(
                    'No more data',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                  )
                  : Container(),
            ),
          ],
        )
      ],
    );

    if (widget.onRefresh == null) {
      return Scrollbar(child: mainWiget);
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        if (_isLoading) return;
        await widget.onRefresh!();
      },
      child: mainWiget,
    );
  }
}