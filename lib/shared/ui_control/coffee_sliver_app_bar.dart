import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// CoffeeSliverAppBar: Một phiên bản tối ưu của SliverAppBar dành riêng cho Coffee Bean App.
/// 
/// Widget này được thiết kế để sử dụng trong [CustomScrollView], hỗ trợ hiển thị
/// hình ảnh nền (background image) và tiêu đề có khả năng thu phóng (FlexibleSpace).
/// Được tối ưu hóa cho hiệu suất cao (High-performance) bằng cách sử dụng các widget tiêu chuẩn của Flutter.
class CoffeeSliverAppBar extends StatelessWidget {
  /// Văn bản hiển thị trên thanh tiêu đề.
  final String? title;

  /// Widget tùy chỉnh thay thế cho tiêu đề văn bản. Nếu được cung cấp, [title] sẽ bị bỏ qua.
  final Widget? titleWidget;

  /// Danh sách các widget hiển thị ở góc phải thanh tiêu đề (ví dụ: Icon tìm kiếm, thông báo).
  final List<Widget>? actions;

  /// Widget hiển thị ở góc trái thanh tiêu đề (thường là nút quay lại).
  final Widget? leading;

  /// Nếu đặt là `true`, nút quay lại mặc định sẽ bị ẩn đi.
  final bool hideBackButton;

  /// Đường dẫn hình ảnh nền (hỗ trợ cả URL mạng hoặc đường dẫn asset cục bộ).
  /// Nếu có giá trị, AppBar sẽ mở rộng theo chiều cao [expandedHeight].
  final String? imageUrl;

  /// Chiều cao tối đa khi thanh AppBar được mở rộng (chỉ áp dụng khi có [imageUrl]).
  final double expandedHeight;

  /// Cấu hình phong cách hiển thị (màu nền, màu chữ, icon quay lại, v.v.).
  final CoffeeAppBarStyleConfig style;

  /// Hàm gọi lại khi nhấn vào nút quay lại mặc định.
  final VoidCallback? onBackTap;
  
  /// Nếu `true`, thanh AppBar sẽ luôn hiển thị ở đầu danh sách cuộn ngay cả khi cuộn xuống.
  final bool pinned;

  /// Nếu `true`, thanh AppBar sẽ xuất hiện ngay khi người dùng bắt đầu cuộn ngược lên.
  final bool floating;

  /// Widget hiển thị ở dưới cùng của AppBar (thường là [TabBar]).
  final PreferredSizeWidget? bottom;

  /// Cấu hình hiển thị của thanh trạng thái hệ thống (Status bar color, icon brightness).
  final SystemUiOverlayStyle? systemOverlayStyle;

  const CoffeeSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.hideBackButton = false,
    this.imageUrl,
    this.expandedHeight = 200.0,
    this.style = const CoffeeAppBarStyleConfig(),
    this.onBackTap,
    this.pinned = true,
    this.floating = false,
    this.bottom,
    this.systemOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Kiểm tra trạng thái trong suốt của AppBar
    final isTransparent = style.backgroundColor == Colors.transparent;
    // Kiểm tra xem có cung cấp hình ảnh hay không
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return SliverAppBar(
      // Nếu có ảnh thì mở rộng chiều cao, nếu không thì dùng chiều cao mặc định
      expandedHeight: hasImage ? expandedHeight : null,
      pinned: pinned,
      floating: floating,
      elevation: style.elevation,
      backgroundColor: style.backgroundColor,
      surfaceTintColor: Colors.transparent, // Ngăn chặn việc tự động đổi màu khi cuộn trên Android (Material 3)
      leadingWidth: style.leadingWidth,
      
      // Tự động điều chỉnh màu sắc icon trên Status Bar dựa theo màu nền của AppBar
      systemOverlayStyle: systemOverlayStyle ??
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: (style.backgroundColor == Colors.white || isTransparent)
                ? Brightness.dark
                : Brightness.light,
            statusBarBrightness: (style.backgroundColor == Colors.white || isTransparent)
                ? Brightness.light
                : Brightness.dark,
          ),
          
      // Xử lý logic hiển thị nút Leading (Back button)
      leading: hideBackButton
          ? leading
          : (leading ??
              IconButton(
                icon: Icon(style.backIcon, size: 20),
                color: style.foregroundColor,
                onPressed: onBackTap ?? () => Navigator.maybePop(context),
              )),
      automaticallyImplyLeading: !hideBackButton,
      actions: actions,
      bottom: bottom,
      
      // FlexibleSpaceBar xử lý hiệu ứng thu phóng tiêu đề và hiển thị hình ảnh background
      flexibleSpace: hasImage
          ? FlexibleSpaceBar(
              title: titleWidget ?? (title != null
                  ? Text(
                      title!,
                      style: style.titleTextStyle ??
                          TextStyle(color: style.foregroundColor, fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  : null),
              centerTitle: style.centerTitle,
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              background: imageUrl!.startsWith('http')
                  ? DbCachedImageWidget(imageUrl: imageUrl!, fit: BoxFit.cover, borderRadius: 0)
                  : Image.asset(imageUrl!, fit: BoxFit.cover),
            )
          : (title != null || titleWidget != null
              ? FlexibleSpaceBar(
                  title: titleWidget ?? Text(
                    title!,
                    style: style.titleTextStyle ??
                        TextStyle(color: style.foregroundColor, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  centerTitle: style.centerTitle,
                )
              : null),
    );
  }
}
