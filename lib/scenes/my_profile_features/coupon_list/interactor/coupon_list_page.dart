import 'package:coffee_bean/scenes/my_profile_features/coupon_list/interactor/coupon_list_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/coupon_list/interactor/widget/coupon_card_widget.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class CouponListPage extends AppCubitStateFulWidget<CouponListInteractor, CouponListState> {
  CouponListPage({super.key, required super.interactor});

  @override
  State<CouponListPage> createState() => _CouponListPageState();
}

class _CouponListPageState extends AppCubitState<CouponListPage, CouponListInteractor, CouponListState> {
  @override
  String? getTitle() => 'Chọn Coupon';

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    return CoffeeAppBar(
      title: getTitle(),
      style: getAppBarStyle(),
      onBackTap: () => interactor.router?.pop(),
    );
  }

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      backgroundColor: TMLabsColor.bgMain,
      appBar: appBar,
      body: body,
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<CouponListInteractor, CouponListState>(
      builder: (context, state) {
        if (state is CouponListLoading || state is CouponListInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is CouponListError && state.coupons.isEmpty) {
          return Center(child: Text(state.message));
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 120),
              itemCount: state.coupons.length + 1,
              itemBuilder: (context, index) {
                if (index < state.coupons.length) {
                  final coupon = state.coupons[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CouponCardWidget(
                      coupon: coupon,
                      onTap: () => interactor.selectCoupon(index),
                      onToggleExpand: () => interactor.toggleExpand(index),
                    ),
                  );
                } else {
                  // "Unused Button" at the bottom of the list
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AppButton(
                      text: 'Không sử dụng coupon',
                      style: TMLabsButtonStyle.white.copyWith(
                        backgroundColor: state.isNoCouponSelected ? TMLabsColor.primary.withValues(alpha: 0.1) : Colors.white,
                        textColor: TMLabsColor.primary,
                      ),
                      onPressed: () => interactor.selectNoCoupon(),
                    ),
                  );
                }
              },
            ),
            // Fixed "Confirm" button at the bottom
            Positioned(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              child: AppButton(
                text: 'Xác nhận',
                style: TMLabsButtonStyle.primary,
                onPressed: () => interactor.confirmSelection(),
              ),
            ),
          ],
        );
      },
    );
  }
}
