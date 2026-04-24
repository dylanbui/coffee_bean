import 'package:coffee_bean/widget/cached_image_widget.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/top_image_panel.dart';

class HomePage extends StatefulWidget with ViewControllable {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopImagePanel(parentContext: context),
            const _QuickActionsRow(),
            const _AnnouncementBar(),
            const _PromoBanner(),
            const _FeaturedCourses(),
            const SizedBox(height: 100), // Khoảng trống cuối trang
          ],
        ),
      ),
    );
  }
}

// --- Phần 2: Hàng nút chức năng ---
class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.assignment_turned_in_outlined, 'label': 'Đặt chỗ'},
      {'icon': Icons.sync_alt, 'label': 'Đổi điểm'},
      {'icon': Icons.school_outlined, 'label': 'Tất cả khóa học'},
      {'icon': Icons.business_center_outlined, 'label': 'Trung tâm sk'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                child: Icon(item['icon'], color: const Color(0xFF0D1B3E)),
              ),
              const SizedBox(height: 8),
              Text(item['label'], style: const TextStyle(fontSize: 11)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// --- Phần 3: Announcement Bar ---
class _AnnouncementBar extends StatelessWidget {
  const _AnnouncementBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFF0D1B3E), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: const [
          Icon(Icons.volume_up, color: Colors.white, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Menu mới với combo trader health các món ăn giàu dinh dườ...",
              style: TextStyle(color: Colors.white, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}

// --- Phần 4: Banner quảng cáo ---
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Banner quảng cáo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("Hiển thị banner dạng nhỏ nhấn vào sẽ đến trang...", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D1B3E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("Xem thêm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// --- Phần 5: Khóa học nổi bật (Scroll ngang) ---
class _FeaturedCourses extends StatelessWidget {
  const _FeaturedCourses();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Khóa học nổi bật", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {},
                child: const Text("Xem thêm", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedImageWidget(
                        imageUrl: 'https://images.unsplash.com/photo-1541167760496-162955ed8a9f?q=80&w=400&auto=format&fit=crop',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          index == 0 ? "INNER CIRCLE TRADER" : "QUẢN TRỊ TÀI SẢN TRONG GIAO DỊCH",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
