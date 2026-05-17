import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/state_management/lib_provider/base_provider_statefull_widget.dart';
import 'package:coffee_bean/scenes/app_landing/home/home_builder.dart';
import 'package:coffee_bean/scenes/app_landing/community/community_builder.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_provider.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/my_profile_builder.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/shopping_builder.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/widget/fade_indexed_stack.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MainTabbarPage extends BaseProviderStateFulWidget {
  MainTabbarPage({super.key}) {
    showAppBar = false;
  }

  @override
  State<StatefulWidget> createState() => _MainTabbarPageState();
}

class _MainTabbarPageState extends BaseProviderState<MainTabbarPage, MainTabbarProvider> {
  int _selectedIndexPage = 0;
  final List<_TabItem> _pages = [];

  @override
  void initState() {
    super.initState();
    // Initialize the first tab (Home)
    _navigateToPage(0);
  }

  void _navigateToPage(int index) {
    if (_pages.indexWhere((element) => element.index == index) == -1) {
      DbNoteRouter? router;
      Widget? widget;

      switch (index) {
        case 0:
          router = HomeBuilder().build();
          widget = router.viewController;
          break;
        case 1:
          router = ShoppingBuilder().build();
          widget = router.viewController;
          break;
        case 2:
          router = CommunityBuilder().build();
          widget = router.viewController;
          break;
        case 3:
          router = MyProfileBuilder().build();
          widget = router.viewController;
          break;
      }

      if (widget != null) {
        _pages.add(_TabItem(index: index, router: router, widget: widget));
        // Re-sort the list by index for FadeIndexedStack to work correctly
        _pages.sort((a, b) => a.index.compareTo(b.index));
      }
    }

    setState(() {
      _selectedIndexPage = index;
    });
  }

  int get _indexInStack => _pages.indexWhere((element) => element.index == _selectedIndexPage);

  @override
  Widget? getLayout(BuildContext context) {
    return Scaffold(
      body: FadeIndexedStack(
        index: _indexInStack,
        children: _pages.map((e) => e.widget).toList(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: TMLabsColor.grey  , width: 0.5)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                onTap: _navigateToPage,
                currentIndex: _selectedIndexPage,
                selectedItemColor: TMLabsColor.primary,
                unselectedItemColor: TMLabsColor.navy,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
                unselectedLabelStyle: const TextStyle(fontSize: 9),
                selectedFontSize: 9,
                unselectedFontSize: 9,
                showUnselectedLabels: true,
                items: [
                  BottomNavigationBarItem(
                    icon: AppIcon(AppAssets.icons.icHome, size: 26),
                    activeIcon: AppIcon(AppAssets.icons.icHomeActive, size: 26),
                    label: AppStrings.home,
                  ),
                  BottomNavigationBarItem(
                    icon: AppIcon(AppAssets.icons.icShopping, size: 26),
                    activeIcon: AppIcon(AppAssets.icons.icShoppingActive, size: 26),
                    label: AppStrings.shopping,
                  ),
                  BottomNavigationBarItem(
                    icon: AppIcon(AppAssets.icons.icCommunication, size: 26),
                    activeIcon: AppIcon(AppAssets.icons.icCommunicationActive, size: 26),
                    label: AppStrings.community,
                  ),
                  BottomNavigationBarItem(
                    icon: AppIcon(AppAssets.icons.icMy, size: 26),
                    activeIcon: AppIcon(AppAssets.icons.icMyActive, size: 26),
                    label: AppStrings.profile,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}

class _TabItem {
  final int index;
  final DbNoteRouter? router;
  final Widget widget;

  _TabItem({required this.index, this.router, required this.widget});
}
