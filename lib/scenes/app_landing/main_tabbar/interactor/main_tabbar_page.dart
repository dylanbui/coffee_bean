import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/app_landing/home/home_builder.dart';
import 'package:coffee_bean/scenes/app_landing/community/community_builder.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/interactor/main_tabbar_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/interactor/main_tabbar_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/my_profile/my_profile_builder.dart';
import 'package:coffee_bean/scenes/shopping_features/shopping/shopping_builder.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/widget/fade_indexed_stack.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class MainTabbarPage extends AppCubitStateFulWidget<MainTabbarInteractor, MainTabbarState> {
  MainTabbarPage({super.key, required super.interactor});

  @override
  State<StatefulWidget> createState() => _MainTabbarPageState();
}

class _MainTabbarPageState extends AppCubitState<MainTabbarPage, MainTabbarInteractor, MainTabbarState> {
  final List<_TabItem> _pages = [];

  @override
  void initState() {
    super.initState();
    // Initialize the first tab (Home)
    _ensurePageLoaded(0);
  }

  void _ensurePageLoaded(int index) {
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
  }

  int _indexInStack(int selectedIndex) => _pages.indexWhere((element) => element.index == selectedIndex);

  @override
  String? getTitle() => null;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<MainTabbarInteractor, MainTabbarState>(
      builder: (context, state) {
        _ensurePageLoaded(state.selectedIndex);
        return FadeIndexedStack(
          index: _indexInStack(state.selectedIndex),
          children: _pages.map((e) => e.widget).toList(),
        );
      },
    );
  }

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return BlocBuilder<MainTabbarInteractor, MainTabbarState>(
      buildWhen: (p, c) => p.selectedIndex != c.selectedIndex,
      builder: (context, state) {
        return Scaffold(
          body: body, // 'body' lúc này chính là kết quả của hàm getBody trên kia
          bottomNavigationBar: _buildBottomNavigationBar(state.selectedIndex),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(int selectedIndex) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 90,
      decoration: const BoxDecoration(
        color: TMLabsColor.white,
        border: Border(top: BorderSide(color: TMLabsColor.grey , width: 0.1)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: TMLabsColor.primary.withValues(alpha: 0.16),
                highlightColor: TMLabsColor.primary.withValues(alpha: 0.02),
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  interactor.selectTab(index);
                },
                currentIndex: selectedIndex,
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
