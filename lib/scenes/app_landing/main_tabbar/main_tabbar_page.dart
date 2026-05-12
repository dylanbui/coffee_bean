import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/state_management/lib_provider/base_provider_statefull_widget.dart';
import 'package:coffee_bean/scenes/app_landing/home/home_builder.dart';
import 'package:coffee_bean/scenes/app_landing/community/community_builder.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_provider.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/my_profile_builder.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/shopping_builder.dart';
import 'package:coffee_bean/widget/fade_indexed_stack.dart';
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
    // Khởi tạo tab đầu tiên (Trang chủ)
    _navigateToPage(0);
  }

  void _navigateToPage(int index) {
    if (_pages.indexWhere((element) => element.index == index) == -1) {
      DbNoteBuilder? builder;
      Widget? widget;

      switch (index) {
        case 0:
          builder = HomeBuilder();
          widget = (builder as HomeBuildable).build();
          break;
        case 1:
          builder = ShoppingBuilder();
          widget = (builder as ShoppingBuildable).build();
          break;
        case 2:
          builder = CommunityBuilder();
          widget = (builder as CommunityBuildable).build();
          break;
        case 3:
          builder = MyProfileBuilder();
          widget = (builder as MyProfileBuildable).build();
          break;
      }

      if (widget != null) {
        _pages.add(_TabItem(index: index, builder: builder, widget: widget));
        // Sắp xếp lại list theo index để FadeIndexedStack hoạt động đúng
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
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 0.5)),
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
                selectedItemColor: const Color(0xFF0D1B3E),
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
                unselectedLabelStyle: const TextStyle(fontSize: 9),
                selectedFontSize: 9,
                unselectedFontSize: 9,
                showUnselectedLabels: true,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home_outlined, size: 40),
                    activeIcon: const Icon(Icons.home, size: 40),
                    label: "Trang chủ",
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.shopping_bag_outlined, size: 40),
                    activeIcon: const Icon(Icons.shopping_bag, size: 40),
                    label: "Mua sắm",
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.people_outline, size: 40),
                    activeIcon: const Icon(Icons.people, size: 40),
                    label: "Cộng đồng",
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person_outline, size: 40),
                    activeIcon: const Icon(Icons.person, size: 40),
                    label: "Tôi",
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
  final DbNoteBuilder? builder;
  final Widget widget;

  _TabItem({required this.index, this.builder, required this.widget});
}
