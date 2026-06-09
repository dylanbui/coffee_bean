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
