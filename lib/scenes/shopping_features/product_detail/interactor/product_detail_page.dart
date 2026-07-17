import 'package:coffee_bean/scenes/comment_list/comment_constant.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_event_state.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/widget/product_detail_content.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/widget/product_detail_footer.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/widget/product_detail_suggested_section.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_sliver_app_bar.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/fade_switcher.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class ProductDetailPage extends AppCubitStateFulWidget<ProductDetailInteractor, ProductDetailState> {
  ProductDetailPage({super.key, required super.interactor});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends AppCubitState<ProductDetailPage, ProductDetailInteractor, ProductDetailState> {
  Widget? _commentPlugin;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  String? getTitle() => null;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ProductDetailInteractor, ProductDetailState>(
      builder: (context, state) {
        return FadeSwitcher.binary(
          duration: const Duration(milliseconds: 300),
          showFirst: state.isLoading,
          first: const Center(child: LoadingView(width: 150, height: 150)),
          second: _buildMainContent(state),
        );
      },
    );
  }

  Widget _buildMainContent(ProductDetailState state) {
    if (state.product == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("Không tìm thấy thông tin sản phẩm", style: TMLabsTextStyle.h2),
            const SizedBox(height: 24),
            AppButton(
              onPressed: () => interactor.router?.pop(),
              text: "Quay lại",
              width: 120,
            ),
          ],
        ),
      );
    }

    _commentPlugin ??= CommentListBuilder(
      resourceId: state.product!.id,
      source: CommentSource.product,
      type: 0,
    ).buildPlugin(10, interactor.commentController);

    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(state),
            SliverToBoxAdapter(child: ProductDetailContent(interactor: interactor)),
            SliverToBoxAdapter(child: ProductDetailSuggestedSection(interactor: interactor)),
            SliverToBoxAdapter(child: _commentPlugin!),
            const SliverToBoxAdapter(child: SizedBox(height: 500)), // Thêm khoảng trống lớn bên dưới để hỗ trợ cuộn lên thoải mái
          ],
        ),
        ProductDetailFooter(interactor: interactor),
      ],
    );
  }

  Widget _buildSliverAppBar(ProductDetailState state) {
    final sliderImages = state.product?.sliderPicUrls ?? [];
    // Nếu có SKU image thì ưu tiên hiện nó hoặc chèn vào đầu slider
    final images = sliderImages.isEmpty ? [state.displayImage] : sliderImages;

    return CoffeeSliverAppBar(
      expandedHeight: 380,
      pinned: false,
      style: TmLabAppBarStyle.whiteStyle.copyWith(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      onBackTap: interactor.router?.pop,
      background: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemCount: images.isEmpty ? 1 : images.length,
            itemBuilder: (context, index) {
              final imageUrl = images.isEmpty ? (state.product?.picUrl ?? "") : images[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  DbCachedImageWidget(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    borderRadius: 0,
                    errorWidget: Image.asset(AppAssets.images.imgNoImage, fit: BoxFit.cover),
                  ),
                  _buildGradientOverlay(),
                ],
              );
            },
          ),
          if (images.length > 1)
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentImageIndex == index ? 24 : 8,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white.withValues(alpha: _currentImageIndex == index ? 1.0 : 0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.3),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.4),
          ],
        ),
      ),
    );
  }
}
