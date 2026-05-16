import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_interactor.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class CommunityPage extends CubitStateFulWidget<CommunityInteractor, CommunityState> {
  CommunityPage({super.key, required super.interactor});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends CubitState<CommunityPage, CommunityInteractor, CommunityState> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  dynamic getAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Cộng đồng",
        style: TextStyle(color: Color(0xFF0D1B3E), fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF0D1B3E),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF0D1B3E),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: "Tin tức"),
          Tab(text: "Hoạt động"),
        ],
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildNewsList(),
        _buildActivityList(),
      ],
    );
  }

  Widget _buildNewsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedImageWidget(
                  imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=800&auto=format&fit=crop',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Khám phá hương vị cà phê mới từ vùng cao nguyên",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Chúng tôi vừa cập nhật danh sách các loại hạt cà phê đặc sản từ Đà Lạt và Đắk Lắk...",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("24/05/2024", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                        const Spacer(),
                        const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("1.2k", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=coffee'),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        children: [
                          TextSpan(text: "Người dùng $index", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: " vừa đăng một bài viết mới về cách pha Cold Brew tại nhà."),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("10 phút trước", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                    if (index % 2 == 0) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedImageWidget(
                          imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=400&auto=format&fit=crop',
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
