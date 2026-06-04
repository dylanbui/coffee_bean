

import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:coffee_bean/utils/refresh_loadmore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppUi {

  // --- REFRESH & LOAD MORE ---

  /// Default widget for pull-to-refresh (Mostly used for iOS style)
  static Widget? getRefreshTopWidget(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    if (isIOS) {
      return const CupertinoActivityIndicator();
    }
    return null;
  }

  /// Default widget for loading more at bottom
  static Widget? getLoadingBottomWidget(BuildContext context, {Color? color}) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    if (isIOS) {
      return const CupertinoActivityIndicator();
    }
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: color != null ? AlwaysStoppedAnimation<Color>(color) : null,
      ),
    );
  }

  // Default style for RefreshLoadmore
  static RefreshLoadmoreStyle getDefaultRefreshLoadmoreStyle(BuildContext context) {
    return RefreshLoadmoreStyle(
      color: TMLabsColor.primary,
      loadingWidget: AppUi.getLoadingBottomWidget(context, color: TMLabsColor.primary),
    );
  }

  /// Default widget for no more data at bottom
  static Widget? getNoMoreWidget() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(
      'Đã hiển thị tất cả lịch sử',
      style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
    ),
  );


  static Widget getLoadingView() {
    return const Center(child: LoadingView(width: 150, height: 150));
  }

  static Widget getEmptyItemWidget({String? imgNoneItem, String title = "Không tìm thấy nội dung liên quan" }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imgNoneItem ?? AppAssets.images.imgNoneItem,
            width: 160,
          ),
          const SizedBox(height: 16),
          Text(title, style: TMLabsTextStyle.body,),
        ],
      ),
    );
  }

}