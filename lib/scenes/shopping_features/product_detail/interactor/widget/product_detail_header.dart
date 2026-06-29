import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_event_state.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailHeader extends StatefulWidget {
  final ProductDetailInteractor interactor;

  const ProductDetailHeader({super.key, required this.interactor});

  @override
  State<ProductDetailHeader> createState() => _ProductDetailHeaderState();
}

class _ProductDetailHeaderState extends State<ProductDetailHeader> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailInteractor, ProductDetailState>(
      buildWhen: (p, c) => p.product?.sliderPicUrls != c.product?.sliderPicUrls || p.displayImage != c.displayImage,
      builder: (context, state) {
        final sliderImages = state.product?.sliderPicUrls ?? [];
        // Nếu có SKU image thì ưu tiên hiện nó hoặc chèn vào đầu slider
        final images = sliderImages.isEmpty ? [state.displayImage] : sliderImages;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          child: SizedBox(
            height: 380,
            child: Stack(
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
                Positioned(
                  left: 16,
                  top: Utils.getSafeAreaTop(context) + 10,
                  child: GestureDetector(
                    onTap: () => widget.interactor.router?.pop(),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
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
          ),
        );
      },
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
