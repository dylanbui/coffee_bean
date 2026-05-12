import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopImagePanel extends StatefulWidget {
  const TopImagePanel({super.key});

  @override
  State<TopImagePanel> createState() => _TopImagePanelState();
}

class _TopImagePanelState extends State<TopImagePanel> {
  final PageController _pageController = PageController();
  final FocusNode _searchFocusNode = FocusNode();
  int _currentPage = 0;
  bool _isSearchFocused = false;

  // Interactor variable
  late HomeInteractor _interactor;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() => _isSearchFocused = _searchFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access interactor from context
    _interactor = context.read<HomeInteractor>();
    
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<HomeInteractor, HomeState>(
      // Only rebuild if topImageData changes
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
              _buildHeader(statusBarHeight, screenWidth),
              _buildWelcomeText(userName),
            ],
          ),
        );
      },
    );
  }

  // --- Widget Components ---

  Widget _buildImageSlider(List<String> images) {
    if (images.isEmpty) return const SizedBox(height: 420);
    
    return SizedBox(
      height: 420,
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) => Stack(
          fit: StackFit.expand,
          children: [
            CachedImageWidget(
              imageUrl: images[index],
              width: double.infinity,
              height: 420,
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
            Colors.black.withOpacity(0.3),
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicators(int count) {
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
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader(double statusBarHeight, double screenWidth) {
    const double paddingHorizontal = 16.0;
    const double searchWidthNormal = 110.0;
    final double availableWidth = screenWidth - (paddingHorizontal * 2);

    return Positioned(
      top: statusBarHeight + 10,
      left: paddingHorizontal,
      right: paddingHorizontal,
      height: 44,
      child: Stack(
        children: [
          _buildLocationButton(availableWidth, searchWidthNormal),
          _buildSearchBar(availableWidth, searchWidthNormal),
        ],
      ),
    );
  }

  Widget _buildLocationButton(double availableWidth, double searchWidthNormal) {
    const double locationWidth = 220;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      left: 0,
      top: 0,
      bottom: 0,
      width: _isSearchFocused ? 0 : locationWidth.clamp(0.0, 500.0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _isSearchFocused ? 0 : 1,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            width: locationWidth,
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                onTap: () => _interactor.selectStore(),
                borderRadius: BorderRadius.circular(25),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: const [
                      Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF0D1B3E)),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Cửa hàng tp.HCM",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF0D1B3E),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 18, color: Color(0xFF0D1B3E)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(double availableWidth, double searchWidthNormal) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      right: 0,
      top: 0,
      bottom: 0,
      left: _isSearchFocused ? 0 : (availableWidth - searchWidthNormal),
      child: TapRegion(
        onTapOutside: (event) {
          if (_isSearchFocused) {
            _searchFocusNode.unfocus();
          }
        },
        child: GestureDetector(
          onTap: () {
            if (!_isSearchFocused) {
              _searchFocusNode.requestFocus();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B3E).withOpacity(0.85),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _searchFocusNode,
                    onSubmitted: (value) => _interactor.openSearch(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Tìm kiếm...",
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.only(left: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12, left: 8),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white, size: 22),
                    onPressed: () {
                      if (_isSearchFocused) {
                        _interactor.openSearch();
                      } else {
                        _searchFocusNode.requestFocus();
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(String name) {
    if (_isSearchFocused) return const SizedBox.shrink();
    return Positioned(
      bottom: 60,
      left: 20,
      child: IgnorePointer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Chào buổi sáng $name", style: const TextStyle(color: Colors.white, fontSize: 15)),
            const SizedBox(height: 10),
            const Text(
              "Chào mừng bạn\nđã quay trở lại",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
