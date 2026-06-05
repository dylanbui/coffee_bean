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
import 'package:db_core/utils/parallax_sliver_app_bar.dart';
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
            ParallaxSliverAppBar(
              imageUrl: "https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=1080&auto=format&fit=crop",
              onBackTap: () => interactor.router?.pop(),
            ),

            // Danh sách nội dung
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = state.items[index];
                  return _buildListItem(item);
                }, childCount: state.items.length),
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
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
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
                  style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.grey, fontSize: 11),
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
