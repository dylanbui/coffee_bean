import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/data/local/store_manager/store_manager.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/scenes/store_list/interactor/store_list_event_state.dart';
import 'package:coffee_bean/scenes/store_list/interactor/store_list_interactor.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/fade_switcher.dart';
import 'package:coffee_bean/shared/widget/search_bar.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';

//ignore: must_be_immutable
class StoreListPage extends AppCubitStateFulWidget<StoreListInteractor, StoreListState> {
  StoreListPage({super.key, required super.interactor});

  @override
  State<StoreListPage> createState() => _StoreListPageState();
}

class _StoreListPageState extends AppCubitState<StoreListPage, StoreListInteractor, StoreListState> {
  @override
  String? getTitle() => "Chọn cửa hàng";

  void _onStoreCardTap(StoreDisplayModel model) async {
    final newStore = model.store;
    final currentStore = StoreManager().selectedStore;

    if (currentStore?.id == newStore.id) {
      interactor.router?.pop();
      return;
    }

    bool proceed = true;
    if (interactor.cartService.currentItems.isNotEmpty) {
      proceed = await FlashDialogHelper.show<bool>(
            context: context,
            title: "Đổi cửa hàng?",
            content: "Giỏ hàng của bạn tại cửa hàng cũ sẽ bị xóa. Bạn có muốn tiếp tục?",
            actions: [
              FlashDialogAction(label: "Hủy", value: false, color: Colors.grey),
              FlashDialogAction(label: "Đồng ý", value: true, color: TMLabsColor.navy),
            ],
          ) ??
          false;
    }

    if (proceed) {
      interactor.performChangeStore(newStore);
    }
  }

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    return CoffeeAppBar(
      title: getTitle(),
      actions: getActions(),
      style: getAppBarStyle(),
      onBackTap: () => interactor.router?.pop(),
    );
  }

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<StoreListInteractor, StoreListState>(
      builder: (context, state) {
        Widget bodyContent;
        String stateKey;
        bool showLocationView = !state.isLocationAuthorized && !state.isManualSelection;

        // 1. Xác định widget hiển thị dựa trên state
        if (showLocationView) {
          bodyContent = _buildLocationRequiredView(state);
          stateKey = '_buildLocationRequiredView';
        } else if (state is StoreListLoading && state.stores.isEmpty) {
          bodyContent = const Center(
            child: LoadingView(width: 150, height: 150),
          );
          stateKey = 'LoadingView';
        } else if (state.stores.isEmpty && state.searchQuery.isEmpty) {
          bodyContent = _buildEmptyState();
          stateKey = '_buildEmptyState';
        } else {
          bodyContent = Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    if (state.stores.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyState(),
                      )
                    else
                      _buildSliverStoreList(state),
                  ],
                ),
              ),
            ],
          );
          stateKey = '_buildMainContent';
        }

        // 2. Sử dụng FadeSwitcher với stateKey để tự động quản lý chuyển cảnh
        return FadeSwitcher(
          stateKey: stateKey,
          child: bodyContent,
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
          AppIcon(AppAssets.icons.icEmptyLocation, size: 160),
          const SizedBox(height: 20),
          const Text(
            "Không thể xác định vị trí, không tìm thấy cửa hàng gần bạn.\nVui lòng bật định vị hoặc chọn thủ công.",
            textAlign: TextAlign.center,
            style: TMLabsTextStyle.body,
          ),
          const SizedBox(height: 48),
          AppButton(
            text: "Bật định vị",
            style: TMLabsButtonStyle.primary,
            isLoading: state.isLocating,
            onPressed: interactor.requestLocationPermission,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: "Chọn thủ công",
            style: TMLabsButtonStyle.outline,
            onPressed: interactor.enableManualSelection,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: TMLabsColor.white,
      child: SizedBox(
        height: 40,
        child: AppSearchBar(
          hintText: "Tìm kiếm tên cửa hàng hoặc địa chỉ",
          backgroundColor: AppColor.basicSearchBg,
          leftIcon: AppAssets.icons.icSearch,
          minLength: 2,
          onSearch: interactor.onSearchChanged,
        ),
      ),
    );
  }

  Widget _buildSliverStoreList(StoreListState state) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildStoreCard(state.stores[index]),
          childCount: state.stores.length,
        ),
      ),
    );
  }

  Widget _buildStoreCard(StoreDisplayModel model) {
    final store = model.store;
    final hoursStr = "${store.openingTime ?? '--:--'} - ${store.closingTime ?? '--:--'}";

    return TapEffect(
      enableSound: false,
      onTap: () => _onStoreCardTap(model),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(minHeight: 140),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              constraints: const BoxConstraints(minHeight: 125),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DbCachedImageWidget(
                        imageUrl: store.mainImage ?? "",
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 25,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.black.withValues(alpha: 0.8), Colors.black.withValues(alpha: 0.2)],
                          ),
                        ),
                      ),
                    ),
                    // Content - Phần này sẽ quyết định chiều cao của card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Cực kỳ quan trọng để card co giãn theo text
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            store.name,
                            style: TMLabsTextStyle.h2.copyWith(color: TMLabsColor.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(Icons.location_on, color: TMLabsColor.error, size: 20),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  store.address ?? "",
                                  style: TMLabsTextStyle.title.copyWith(color: TMLabsColor.white, height: 1.2),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time_filled, color: TMLabsColor.white, size: 19),
                              const SizedBox(width: 6),
                              Text(hoursStr, style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.white)),
                              const SizedBox(width: 12),
                              _buildStatusBadge(model.isOpen),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Distance Label with Slanted Edge
            Positioned(
              top: 3, // Nhích lên một chút để hiện bóng đổ phía trên
              right: -7, // Nhích sang phải một chút để hiện bóng đổ bên phải
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  AppIcon(AppAssets.images.imgBgKhoangCach),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
                    child: Text(
                      "Cách bạn ${model.distance}",
                      style: TMLabsTextStyle.caption.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isOpen) {
    return AppLabel(
      isOpen ? "Đang mở cửa" : "Đóng cửa",
      backgroundColor: isOpen ? TMLabsColor.success : TMLabsColor.grey,
      borderRadius: 12,
      style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.white, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.store_outlined, size: 64, color: AppColor.basicSecondaryText),
          const SizedBox(height: 16),
          Text("Không tìm thấy cửa hàng", style: TMLabsTextStyle.body.copyWith(color: AppColor.basicSecondaryText)),
        ],
      ),
    );
  }
}
