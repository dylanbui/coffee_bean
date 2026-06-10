# Template Chuẩn 1: Search & List Page (Fixed Header)

Sử dụng cho các trang danh sách có thanh tìm kiếm, bộ lọc hoặc các công cụ điều khiển cố định ở phía trên cùng (ngay dưới AppBar) và phần nội dung danh sách có thể cuộn bên dưới.

## 1. Cấu trúc Layout (Architecture)
- **Root Widget**: Luôn sử dụng `Column`.
- **Header Layer**: `_buildFilterHeader` (Chứa SearchBar, Category Picker, v.v.).
- **Content Layer**: Bọc trong `Expanded` để chiếm trọn phần diện tích còn lại.
- **Animation Layer**: Sử dụng `FadeSwitcher` trực tiếp bên trong `Expanded` để xử lý hiệu ứng chuyển đổi trạng thái (Loading <-> Empty <-> Data).

## 2. Các thành phần chính (Core Components)

### **A. Header cố định (`_buildFilterHeader`)**
- **Trình bày**: `Container` với `color: Colors.white`.
- **Ranh giới**: Bắt buộc có `border: Border(bottom: BorderSide(color: TMLabsColor.bgLight, width: 1))` để tạo ranh giới phẳng khi danh sách cuộn lên.
- **Độ cao**: Thường dùng `height: 32` cho các input bên trong và padding dọc khoảng `8px`.

### **B. Điều phối nội dung (`_buildContent`)**
Sử dụng logic rẽ nhánh rõ ràng dựa trên `state`:
1. **Loading**: Nếu `isLoading` và danh sách rỗng -> `FadeSwitcher(stateKey: "loading", child: getLoadingView())`.
2. **Empty**: Nếu danh sách rỗng -> `FadeSwitcher(stateKey: "empty", child: getEmptyItemView())`.
3. **Data**: Trả về `_buildListView(state)` bọc trong `FadeSwitcher(stateKey: "data_list")`.

### **C. Danh sách dữ liệu (`_buildListView`)**
- **Widget**: `ListView.separated`.
- **Cấu hình**:
  - `padding: EdgeInsets.all(16)` (Chuẩn lề của app).
  - `separatorBuilder: (context, index) => SizedBox(height: 12)`.
  - `itemBuilder`: Gọi hàm build item riêng biệt (ví dụ: `_buildReservationItem`).
- **Tối ưu**: Có thể thêm `PageStorageKey` nếu cần giữ vị trí cuộn khi chuyển tab.

## 3. Nguyên tắc về Hiệu ứng (Animation Rules)
- Luôn sử dụng `stateKey` định danh (ví dụ: `"loading"`, `"empty"`, `"data_list"`) để `FadeSwitcher` nhận diện sự thay đổi.
- **Duration**: Mặc định `300ms` để đảm bảo cảm giác nhanh nhẹn (Snappy UI).
- **Type**: `FadeSwitcherType.fade` là lựa chọn ưu tiên cho các trang danh sách "phẳng".

## 4. Mã nguồn mẫu (Code Reference)
```dart
@override
Widget getBody(BuildContext context) {
  return BlocBuilder<MyInteractor, MyState>(
    builder: (context, state) {
      return Column(
        children: [
          _buildFilterHeader(context, state),
          Expanded(
            child: FadeSwitcher(
              stateKey: _getContentStateKey(state),
              child: _buildContent(context, state),
            ),
          ),
        ],
      );
    },
  );
}

String _getContentStateKey(MyState state) {
  if (state.isLoading && state.items.isEmpty) return "loading";
  if (state.items.isEmpty) return "empty";
  return "data_list";
}

Widget _buildContent(BuildContext context, MyState state) {
  if (state.isLoading && state.items.isEmpty) return getLoadingView();
  if (state.items.isEmpty) return getEmptyItemView();
  return _buildListView(state);
}

Widget _buildFilterHeader(BuildContext context, MyState state) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: TMLabsColor.bgLight, width: 1)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    child: Row( ... ),
  );
}
```

# Flutter Sliver Template Refactor (Chuẩn 2)

## Mục tiêu
- Tạo template màn hình danh sách với **SliverPersistentHeader**.
- Header có thể **co giãn chiều cao khi cuộn**.
- Chuẩn bị sẵn **delegate tái sử dụng (FixedHeaderDelegate)** để dễ mở rộng.

---

## Code: ReservationListPage với SliverPersistentHeader co giãn

```dart
class ReservationListPage extends AppCubitStateFulWidget<ReservationListInteractor, ReservationListState> {
  ReservationListPage({super.key, required super.interactor});

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState
    extends AppCubitState<ReservationListPage, ReservationListInteractor, ReservationListState> {
  @override
  String? getTitle() => "ĐẶT CHỖ";

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ReservationListInteractor, ReservationListState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async => interactor.onRefresh(),
          child: CustomScrollView(
            slivers: [
              // Header co giãn khi cuộn
              SliverPersistentHeader(
                pinned: true,
                delegate: FixedHeaderDelegate(
                  minHeight: 40,
                  maxHeight: 80,
                  childBuilder: (shrinkOffset, overlapsContent) {
                    final t = (shrinkOffset / (80 - 40)).clamp(0.0, 1.0);
                    final scale = 1.0 - 0.2 * t; // thu nhỏ nhẹ khi cuộn
                    return Transform.scale(
                      scale: scale,
                      alignment: Alignment.centerLeft,
                      child: _buildFilterHeader(context, state),
                    );
                  },
                ),
              ),

              // Loading view
              if (state.isLoading && state.reservations.isEmpty)
                SliverFillRemaining(
                  child: FadeSwitcher(
                    stateKey: "getLoadingView",
                    child: getLoadingView(),
                  ),
                ),

              // Empty state
              if (!state.isLoading && state.reservations.isEmpty)
                SliverFillRemaining(
                  child: FadeSwitcher(
                    stateKey: "getEmptyItemView",
                    child: getEmptyItemView(),
                  ),
                ),

              // Content list
              if (state.reservations.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildReservationItem(context, state.reservations[index])
                            .animate()
                            .fade(duration: 200.ms)
                            .slide(begin: const Offset(0, 0.1));
                      },
                      childCount: state.reservations.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterHeader(BuildContext context, ReservationListState state) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: TMLabsColor.bgLight, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: () => _showCategoryModal(context, state),
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: TMLabsColor.bgLight, borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.selectedCategory?.name ?? "Tất cả các loại",
                        style: TMLabsTextStyle.bodyBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: TMLabsColor.primary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 6,
            child: SizedBox(
              height: 32,
              child: AppSearchBar(
                hintText: "Tìm kiếm tên địa điểm",
                onSearch: interactor.onSearchChanged,
                backgroundColor: TMLabsColor.bgLight,
                borderRadius: 22,
                leftIcon: AppAssets.icons.icSearch,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Delegate tái sử dụng: FixedHeaderDelegate

```dart
/// Delegate tái sử dụng cho SliverPersistentHeader
class FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget Function(double shrinkOffset, bool overlapsContent) childBuilder;

  FixedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.childBuilder,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return childBuilder(shrinkOffset, overlapsContent);
  }

  @override
  bool shouldRebuild(FixedHeaderDelegate oldDelegate) {
    return minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        childBuilder != oldDelegate.childBuilder;
  }
}
```

---

## Ví dụ mở rộng: Hiệu ứng fade (opacity giảm khi cuộn)

```dart
SliverPersistentHeader(
  pinned: true,
  delegate: FixedHeaderDelegate(
    minHeight: 40,
    maxHeight: 80,
    childBuilder: (shrinkOffset, overlapsContent) {
      final t = (shrinkOffset / (80 - 40)).clamp(0.0, 1.0);
      final opacity = 1.0 - 0.5 * t; // giảm opacity khi cuộn
      return Opacity(
        opacity: opacity,
        child: _buildFilterHeader(context, state),
      );
    },
  ),
),
```

---

## Hướng dẫn sử dụng
1. **Dùng SliverPersistentHeader** khi bạn muốn header dính top và có hiệu ứng co giãn.
2. **FixedHeaderDelegate** giúp bạn tái sử dụng logic, chỉ cần truyền `minHeight`, `maxHeight` và `childBuilder`.
3. Bạn có thể dễ dàng mở rộng childBuilder để thêm hiệu ứng:
- **Scale**: thu nhỏ widget.
- **Opacity**: làm mờ dần khi cuộn.
- **Color transform**: đổi màu nền khi cuộn.

---