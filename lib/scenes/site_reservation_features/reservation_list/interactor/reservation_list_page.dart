import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/interactor/reservation_list_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/interactor/reservation_list_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/interactor/widget/reservation_category_picker.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/search_bar.dart';
import 'package:coffee_bean/utils/flash_utils/flash_modal_helper.dart';
import 'package:coffee_bean/utils/flash_utils/flash_toast_helper.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ReservationListPage extends AppCubitStateFulWidget<ReservationListInteractor, ReservationListState> {
  ReservationListPage({super.key, required super.interactor});

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState
    extends AppCubitState<ReservationListPage, ReservationListInteractor, ReservationListState> {
  @override
  String? getTitle() => "ĐẶT CHỖ";

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ReservationListInteractor, ReservationListState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildFilterHeader(context, state),
            Expanded(child: _buildContent(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildFilterHeader(BuildContext context, ReservationListState state) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: TMLabsColor.bgLight, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: () => _showCategoryModal(context, state),
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: TMLabsColor.bgLight, borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.selectedCategory?.name ?? "Tất cả các loại",
                        style: TMLabsTextStyle.bodyBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: TMLabsColor.primary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 6,
            child: SizedBox(
              height: 32,
              child: AppSearchBar(
                hintText: "Tìm kiếm tên địa điểm",
                onSearch: interactor.onSearchChanged,
                backgroundColor: TMLabsColor.bgLight,
                borderRadius: 22,
                leftIcon: AppAssets.icons.icSearch,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ReservationListState state) {
    if (state.isLoading && state.reservations.isEmpty) {
      return FadeSwitcher(stateKey: "getLoadingView", child: getLoadingView());
    }

    if (state.reservations.isEmpty) {
      return FadeSwitcher(stateKey: "getEmptyItemView", child: getEmptyItemView());
    }

    final content =  ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.reservations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildReservationItem(context, state.reservations[index]);
      },
    );
    // Nếu bạn muốn mỗi lần search kết quả mới đều có hiệu ứng mờ nhẹ
    // bạn nên dùng key động (ví dụ: "content_${state.reservations.length}" hoặc dựa trên query).
    return FadeSwitcher(stateKey: "content_${state.reservations.length}", child: content);
  }

  Widget _buildReservationItem(BuildContext context, TblReservation item) {
    return TapEffect(
      onTap: () {
        FlashToastHelper.info(context, "ID: ${item.serverId}", title: item.name, position: FlashPosition.bottom);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with distance overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.mainImage ?? "",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Cách 189m", // Demo distance
                      style: TMLabsTextStyle.small.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TMLabsTextStyle.title.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(Icons.location_on, size: 14, color: TMLabsColor.error),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: AppLabel(
                          item.address,
                          style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
                          maxLines: 2,
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.topLeft,
                          mainAxisSize: MainAxisSize.max,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: TMLabsColor.grey),
                      const SizedBox(width: 4),
                      Text(
                        "${item.openingTime} - ${item.closingTime}",
                        style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryModal(BuildContext context, ReservationListState state) {
    FlashModalHelper.showSmartModal<TblCategory?>(
      context: context,
      title: "Chọn loại",
      position: FlashModalPosition.top,
      childBuilder: (ctx, controller) {
        return ReservationCategoryPicker(
          categories: state.categories,
          selectedCategory: state.selectedCategory,
          controller: controller,
        );
      },
    ).then((selected) {
      if (selected != null || (selected == null && state.selectedCategory != null)) {
        interactor.onCategorySelected(selected);
      }
    });
  }
}
