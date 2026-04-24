import 'package:coffee_bean/commons/utils/logger.dart';
import 'package:coffee_bean/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- Phần 1: Panel hình ảnh scroll ngang phía trên ---
class TopImagePanel extends StatefulWidget {
  final BuildContext parentContext;
  const TopImagePanel({super.key, required this.parentContext});

  @override
  State<TopImagePanel> createState() => _TopImagePanelState();
}

class _TopImagePanelState extends State<TopImagePanel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSearchFocused = false;
  final FocusNode _searchFocusNode = FocusNode();

  final List<String> _images = [
    'https://images.unsplash.com/photo-1501339819358-ee5969a1f18c?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=800&auto=format&fit=crop',
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
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
    // 1. Làm cho Status Bar trong suốt để hình ảnh có thể tràn lên phía sau
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Chữ trắng cho thanh trạng thái
    ));

    // 2. Lấy độ cao của status bar (phần tai thỏ)
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // 3. Cách truy cập parentContext từ widget cha:
    // Sử dụng từ khóa 'widget.parentContext'
    // Ví dụ: final interactor = BlocProvider.of<HomeInteractor>(widget.parentContext);

    return Stack(
      children: [
        // Background Image PageView - Tràn viền
        SizedBox(
          height: 420,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  CachedImageWidget(
                    imageUrl: _images[index],
                    width: double.infinity,
                    height: 420,
                    borderRadius: 0,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.7)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Bullets (Indicators)
        Positioned(
          bottom: 25,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_images.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 4,
                width: _currentPage == index ? 18 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),

        // Overlay: Location & Expanding Search
        Positioned(
          top: statusBarHeight + 10, // Cộng thêm độ cao của tai thỏ
          left: 16,
          right: 16,
          height: 44, // Cố định chiều cao cho vùng tương tác này
          child: Stack(
            children: [
              // 1. Location Button - Sẽ thu nhỏ và biến mất khi Search focus
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                left: 0,
                top: 0,
                bottom: 0,
                // Tự động lấy tối đa không gian trừ đi Search Bar (110) và khoảng cách (8)
                width: _isSearchFocused ? 0 : (MediaQuery.of(context).size.width - 32 - 110 - 8).clamp(0.0, 500.0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isSearchFocused ? 0 : 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Container(
                      // Để width thoải mái bên trong SingleChildScrollView để tránh lỗi overflow khi đang animation
                      width: MediaQuery.of(context).size.width - 150, 
                      padding: const EdgeInsets.only(right: 8),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        child: InkWell(
                          onTap: () {
                            iLog("Chọn cửa hàng...");
                          },
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
                                    style: TextStyle(fontSize: 13, color: Color(0xFF0D1B3E), fontWeight: FontWeight.w600),
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
              ),

              // 2. Expanding Search Bar - Animation mở rộng từ phải qua trái
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                right: 0,
                top: 0,
                bottom: 0,
                // Khi focus: chiếm hết chiều rộng (left=0)
                // Khi không focus: ngắn lại còn 110px tính từ bên phải
                left: _isSearchFocused ? 0 : (MediaQuery.of(context).size.width - 32 - 110),
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
                      const Padding(
                        padding: EdgeInsets.only(right: 12, left: 8),
                        child: Icon(Icons.search, color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Chào mừng text
        if (!_isSearchFocused)
        Positioned(
          bottom: 60,
          left: 20,
          child: IgnorePointer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Chào buổi sáng Gigi", style: TextStyle(color: Colors.white, fontSize: 15)),
                SizedBox(height: 10),
                Text(
                  "Chào mừng bạn\nđã quay trở lại",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
