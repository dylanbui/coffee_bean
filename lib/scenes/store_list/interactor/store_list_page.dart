import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/scenes/store_list/interactor/store_list_event_state.dart';
import 'package:coffee_bean/scenes/store_list/interactor/store_list_interactor.dart';
import 'package:coffee_bean/core/utils/tap_effect.dart';
import 'package:coffee_bean/core/utils/app_button.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar_ext.dart';
import 'package:coffee_bean/shared/widget/search_bar.dart';

//ignore: must_be_immutable
class StoreListPage extends CubitStateFulWidget<StoreListInteractor, StoreListState> {
  StoreListPage({super.key, required super.interactor});

  @override
  State<StoreListPage> createState() => _StoreListPageState();
}

class _StoreListPageState extends CubitState<StoreListPage, StoreListInteractor, StoreListState> {
  @override
  dynamic getAppBar(BuildContext context) => whiteCoffeeAppBar("Select Store");

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<StoreListInteractor, StoreListState>(
      builder: (context, state) {
        bool showLocationView = !state.isLocationAuthorized && !state.isManualSelection;

        return Column(
          children: [
            AbsorbPointer(
              absorbing: showLocationView,
              child: Opacity(opacity: showLocationView ? 0.5 : 1.0, child: _buildSearchBar()),
            ),
            Expanded(child: showLocationView ? _buildLocationRequiredView(state) : _buildStoreList(state)),
          ],
        );
      },
    );
  }

  Widget _buildLocationRequiredView(StoreListState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Placeholder for the map icon in the screenshot
          AppIcon(AppAssets.icons.icEmptyLocation, size: 160),
          const SizedBox(height: 20),
          const Text(
            "Không thể xác định vị trí, không tìm thấy cửa hàng gần bạn.\nVui lòng bật định vị hoặc chọn thủ công.",
            textAlign: TextAlign.center,
            style: TMLabsStyle.regular,
          ),
          const SizedBox(height: 48),
          AppButton(
            text: "Bật định vị",
            style: TMLabsStyle.primaryButton,
            isLoading: state.isLocating,
            onPressed: interactor.requestLocationPermission,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: "Chọn thủ công",
            style: TMLabsStyle.outlineButton,
            onPressed: interactor.enableManualSelection,
          ),
        ],
      ),    
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: SizedBox(
        height: 50,
        child: AppSearchBar(
          hintText: "Search store name",
          backgroundColor: AppColor.basicSearchBg,
          rightIcon: AppAssets.icons.icSearch, // Đưa icon sang bên phải
          minLength: 5,
          onSearch: interactor.onSearchChanged,
        ),
      ),
    );
  }

  Widget _buildStoreList(StoreListState state) {
    if (state is StoreListLoading && state.stores.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.stores.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      itemCount: state.stores.length + 1,
      itemBuilder: (context, index) {
        if (index == state.stores.length) {
          return _buildFooter();
        }
        return _buildStoreCard(state.stores[index]);
      },
    );
  }

  Widget _buildStoreCard(Store store) {
    return TapEffect(
      enableSound: false,
      onTap: () => interactor.onStoreSelected(store),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    store.name,
                    style: TMLabsStyle.semibold.copyWith(fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text("${store.distance} away", style: TMLabsStyle.regular.copyWith(color: Colors.blue, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: AppColor.basicSecondaryText),
                const SizedBox(width: 4),
                Expanded(child: Text(store.address, style: TMLabsStyle.regular.copyWith(color: AppColor.basicSecondaryText))),
                const SizedBox(width: 16),
                const Icon(Icons.near_me, size: 24, color: Colors.black),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: AppColor.basicSecondaryText),
                const SizedBox(width: 4),
                Text(store.hours, style: TMLabsStyle.regular.copyWith(color: AppColor.basicSecondaryText)),
                if (!store.isOpen) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColor.grayF0, borderRadius: BorderRadius.circular(4)),
                    child: Text("Closed", style: TMLabsStyle.regular.copyWith(color: AppColor.basicSecondaryText, fontSize: 12)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(child: Text("No more stores", style: TMLabsStyle.regular.copyWith(color: AppColor.basicSecondaryText, fontSize: 12))),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.store_outlined, size: 64, color: AppColor.basicSecondaryText),
          const SizedBox(height: 16),
          Text("No stores found", style: TMLabsStyle.regular.copyWith(color: AppColor.basicSecondaryText)),
        ],
      ),
    );
  }
}
