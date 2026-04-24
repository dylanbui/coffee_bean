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
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: _navigateToPage,
      currentIndex: _selectedIndexPage,
      selectedItemColor: const Color(0xFF0D1B3E),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Trang chủ",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          activeIcon: Icon(Icons.shopping_bag),
          label: "Mua sắm",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: "Cộng đồng",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Tôi",
        ),
      ],
    );
  }
}

class _TabItem {
  final int index;
  final DbNoteBuilder? builder;
  final Widget widget;

  _TabItem({required this.index, this.builder, required this.widget});
}
