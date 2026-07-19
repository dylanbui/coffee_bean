import 'package:flutter/material.dart';

class CommunityPageTest extends StatefulWidget {
  const CommunityPageTest({super.key});

  @override
  _CommunityPageTestState createState() => _CommunityPageTestState();
}

class _CommunityPageTestState extends State<CommunityPageTest>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.paddingOf(context).top;
    const double sliderHeight = 210.0;
    const double hotTopicsHeight = 180.0;
    const double tabBarHeight = 64.0;
    const double spacing = 12.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: _CommunityHeaderDelegate(
                statusBarHeight: statusBarHeight,
                sliderHeight: sliderHeight,
                hotTopicsHeight: hotTopicsHeight,
                tabBarHeight: tabBarHeight,
                spacing: spacing,
                tabBar: Container(
                  color: Colors.blue,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: "Tab 1"),
                          Tab(text: "Tab 2"),
                          Tab(text: "Tab 3"),
                        ],
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        indicatorColor: Colors.white,
                        indicatorWeight: 3,
                      ),
                      Divider(height: 1, thickness: 1, color: Colors.blue.shade300),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildList("Tab 1"),
            _buildList("Tab 2"),
            _buildList("Tab 3"),
          ],
        ),
      ),
    );
  }

  Widget _buildList(String label) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 30,
      itemBuilder: (context, index) {
        return ListTile(title: Text("$label Item $index"));
      },
    );
  }
}

class _CommunityHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double statusBarHeight;
  final double sliderHeight;
  final double hotTopicsHeight;
  final double tabBarHeight;
  final double spacing;
  final Widget tabBar;

  _CommunityHeaderDelegate({
    required this.statusBarHeight,
    required this.sliderHeight,
    required this.hotTopicsHeight,
    required this.tabBarHeight,
    required this.spacing,
    required this.tabBar,
  });

  @override
  double get maxExtent => statusBarHeight + sliderHeight + spacing + hotTopicsHeight + spacing + tabBarHeight;

  @override
  double get minExtent => statusBarHeight + tabBarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Tỷ lệ cuộn (0.0 -> 1.0)
    final double shrinkPercentage = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Toàn bộ nội dung nội dung (Slider + Hot Topics)
          Positioned(
            top: -shrinkOffset,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Slider (Xử lý tràn viền)
                Container(
                  height: sliderHeight + statusBarHeight,
                  color: Colors.blueGrey,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: statusBarHeight),
                      child: const Text("Image Container (Pro Solution)", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: spacing),
                // Hot Topics
                Container(
                  height: hotTopicsHeight,
                  color: Colors.orangeAccent,
                  child: const Center(child: Text("Hot Topics")),
                ),
                SizedBox(height: spacing),
                // placeholder cho TabBar (Để giữ đúng maxExtent)
                SizedBox(height: tabBarHeight),
              ],
            ),
          ),

          // 2. Background color cho vùng Status Bar (Cố định ở Top)
          // Hiện dần lên khi cuộn
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: statusBarHeight,
            child: Container(
              color: Colors.blue.withValues(alpha: shrinkPercentage),
            ),
          ),

          // 3. TabBar "ghim" (Sticky Layer)
          // Chỉ có DUY NHẤT một TabBar này được render
          Positioned(
            // Vị trí: max(statusBarHeight, vị_trí_thực_tế_khi_cuộn)
            top: (maxExtent - tabBarHeight - shrinkOffset).clamp(statusBarHeight, maxExtent),
            left: 0,
            right: 0,
            height: tabBarHeight,
            child: Material( // Material giúp TabBar có background đặc hoàn toàn
              elevation: 0,
              color: Colors.blue,
              child: tabBar,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _CommunityHeaderDelegate oldDelegate) => true;
}
