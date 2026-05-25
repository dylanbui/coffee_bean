import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/common_style.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopImagePanel extends StatefulWidget {
  final HomeInteractor interactor;
  const TopImagePanel({super.key, required this.interactor});

  @override
  State<TopImagePanel> createState() => _TopImagePanelState();
}

class _TopImagePanelState extends State<TopImagePanel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return BlocBuilder<HomeInteractor, HomeState>(
      buildWhen: (previous, current) => previous.topImageData != current.topImageData,
      builder: (context, state) {
        final data = state.topImageData;
        final images = data?.images ?? [];
        final userName = data?.userName ?? "";

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          child: Stack(
            children: [
              _buildImageSlider(images),
              _buildPageIndicators(images.length),
              _buildHeader(statusBarHeight),
              _buildWelcomeText(userName),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSlider(List<String> images) {
    const double sliderHeight = 420;
    // Lấy chiều rộng màn hình thực tế để tránh dùng double.infinity
    final double screenWidth = MediaQuery.of(context).size.width;

    if (images.isEmpty) return const SizedBox(height: sliderHeight);
    
    return SizedBox(
      height: sliderHeight,
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) => Stack(
          fit: StackFit.expand,
          children: [
            CachedImageWidget(
              imageUrl: images[index],
              width: screenWidth, // Concrete size (FHD/HD standard)
              height: sliderHeight,
              borderRadius: 0,
              fit: BoxFit.cover,
            ),
            _buildGradientOverlay(),
          ],
        ),
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
            TMLabsColor.white.withValues(alpha: 0),
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicators(int count) {
    if (count <= 1) return const SizedBox.shrink();
    return Positioned(
      bottom: 25,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          final isSelected = _currentPage == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 4,
            width: isSelected ? 18 : 8,
            decoration: BoxDecoration(
              color: isSelected ? TMLabsColor.white : TMLabsColor.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader(double statusBarHeight) {
    return Positioned(
      top: statusBarHeight + 10,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLocationButton(),
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _buildLocationButton() {
    const Color navyColor = TMLabsColor.primary;

    return AppButton(
      text: AppStrings.selectStore,
      onPressed: () {
        widget.interactor.openSelectStore();
        },
      mainAxisSize: MainAxisSize.min,
      leftIcon: const AppIcon(Icons.location_on_outlined, size: 20, color: navyColor),
      rightIcon: const AppIcon(Icons.chevron_right, size: 20, color: navyColor),
      style: AppButtonStyleConfig(
        backgroundColor: TMLabsColor.white,
        textColor: navyColor,
        borderRadius: 25,
        height: 38,
        textStyle: const TextStyle(
          fontSize: 14,
          color: navyColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildSearchButton() {
    const Color navyColor = TMLabsColor.primary;

    return AppButton(
      text: AppStrings.searchHint,
      onPressed: () {
        widget.interactor.openGlobalSearch();
      },
      mainAxisSize: MainAxisSize.min,
      rightIcon: AppIcon(AppAssets.icons.icSearch, color: TMLabsColor.white, size: 22),
      style: AppButtonStyleConfig(
        backgroundColor: navyColor.withValues(alpha: 0.85),
        textColor: TMLabsColor.white,
        borderRadius: 25,
        height: 38,
        textStyle: const TextStyle(
          color: TMLabsColor.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildWelcomeText(String name) {
    return Positioned(
      bottom: 60,
      left: 20,
      child: IgnorePointer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppStrings.morningWelcome} $name", 
              style: TMLabsTextStyle.title.copyWith(color: TMLabsColor.white),
            ),
            const SizedBox(height: 10),
            Text(
              AppStrings.welcomeBack,
              style: TMLabsTextStyle.h1.copyWith(
                color: TMLabsColor.white,
                fontSize: 28,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
