// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// Author: dylanbui
// Create Date: 2026-06-05
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/scenes/exchange_point/interactor/exchange_point_event_state.dart';
import 'package:coffee_bean/scenes/exchange_point/interactor/exchange_point_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class ExchangePointPage extends AppCubitStateFulWidget<ExchangePointInteractor, ExchangePointState> {
  ExchangePointPage({super.key, required super.interactor});

  @override
  State<ExchangePointPage> createState() => _ExchangePointPageState();
}

class _ExchangePointPageState extends AppCubitState<ExchangePointPage, ExchangePointInteractor, ExchangePointState> {

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ExchangePointInteractor, ExchangePointState>(
      builder: (context, state) {
        if (state is ExchangePointLoading) {
          return getLoadingView();
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              stretch: true,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: () => interactor.router?.pop(),
              ),
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final double appBarHeight = constraints.biggest.height;
                  final double statusBarHeight = MediaQuery.paddingOf(context).top;
                  final double expandedHeight = 250.0 + statusBarHeight;
                  
                  // Tính toán độ cuộn (scrollOffset > 0 khi cuộn lên)
                  final double scrollOffset = expandedHeight - appBarHeight;
                  
                  // 1. Hiệu ứng Parallax khi cuộn lên: di chuyển ảnh lên chậm hơn tốc độ cuộn
                  // Dùng giá trị nhỏ (0.3) để ảnh không bị đẩy đi quá xa
                  final double parallaxOffset = scrollOffset > 0 ? -scrollOffset * 0.3 : 0.0;

                  // 2. Hiệu ứng Stretch khi kéo xuống (overscroll)
                  final double scale = appBarHeight > expandedHeight 
                      ? appBarHeight / expandedHeight 
                      : 1.0;

                  return Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      // Image layer sử dụng Positioned để đảm bảo ảnh luôn che phủ kín diện tích AppBar
                      Positioned(
                        top: parallaxOffset,
                        left: 0,
                        right: 0,
                        // Chiều cao ảnh luôn giữ ở mức expandedHeight (nhân thêm scale khi stretch)
                        // Điều này đảm bảo khi cuộn lên, phần dưới của ảnh vẫn che phủ vùng Toolbar
                        height: expandedHeight * scale,
                        child: const DbCachedImageWidget(
                          imageUrl: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&q=80&w=1000",
                          fit: BoxFit.cover,
                          borderRadius: 0,
                        ),
                      ),
                      // Overlay mờ để đảm bảo icon/text luôn rõ nét
                      Container(
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  );
                },
              ),
            ),


            // Danh sách nội dung
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = state.items[index];
                    return _buildListItem(item);
                  },
                  childCount: state.items.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListItem(ExchangePointItem item) {
    return Container(
      height: 65,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: TMLabsColor.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: TMLabsTextStyle.body.copyWith(
                    color: TMLabsColor.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.caption,
                  style: TMLabsTextStyle.small.copyWith(
                    color: TMLabsColor.grey,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: item.buttonText,
            onPressed: () {
              interactor.chooseExchangePointItem(item);
            },
            width: 90,
            height: 28,
            style: TMLabsButtonStyle.primary.copyWith(
              borderRadius: 14,
              textStyle: TMLabsTextStyle.small.copyWith(
                color: TMLabsColor.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
