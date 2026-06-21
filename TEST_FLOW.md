# Coffee Bean - Testing Strategy & Flow Document

Tài liệu này tổng hợp các phương pháp kiểm thử đã được triển khai cho module `Change Mobile`, các vấn đề gặp phải và hướng giải quyết.

---

## 1. Phương pháp 1: Unit & Widget Testing (Mocked)
- **Vị trí**: `test/change_mobile/change_mobile_page_test.dart`
- **Cơ chế**: Sử dụng thư viện `mocktail` để giả lập (Mock) toàn bộ Interactor và Router.
- **Mục tiêu**: Kiểm tra logic hiển thị UI, validate đầu vào và phản ứng của UI với các trạng thái State (Loading, Success, Error).
- **Kết quả**: **Thành công (7/7 pass)**. 
- **Ưu điểm**: Chạy cực nhanh (5s), không cần máy thật, độ tin cậy logic cao.
- **Hạn chế**: Không kiểm tra được kết nối mạng thật và sự tương thích với phần cứng device.

## 2. Phương pháp 2: Full UI Integration Test (Direct Flow)
- **Vị trí**: `integration_test/change_mobile_integration_test.dart` (Bản đầu tiên)
- **Cơ chế**: Chạy từ `main()` -> Splash -> Login UI -> Profile -> Change Mobile.
- **Vấn đề gặp phải**: 
    - App bị treo (hang) tại Splash Screen do cơ chế Refresh Token gặp lỗi mạng trong môi trường test.
    - Lớp Overlay "Test starting..." của Flutter che khuất màn hình khiến người dùng không thể can thiệp manual.

## 3. Phương pháp 3: Hybrid Integration Test (Signal-based)
- **Cơ chế**: Đợi App khởi chạy và "lắng nghe" tín hiệu UI (Ví dụ: Tìm chữ "Trang chủ" hoặc `MainTabbarPage`).
- **Cải tiến**: 
    - Thêm thời gian chờ (30s) để người dùng hỗ trợ manual.
    - Tắt Overlay "Test starting" bằng code can thiệp vào `binding`.
- **Kết quả**: App vẫn bị kẹt tại Splash do logic `AppInteractor` thực hiện Logout khi Token cũ expire, dẫn đến vòng lặp không vào được Home.

## 4. Phương pháp 4: Pre-authenticated Injection (Advanced)
- **Cơ chế**: Chiến lược "Bơm session ngầm".
    1. Gọi `app.initializeApp()` để setup hệ thống.
    2. Gọi trực tiếp API `AuthRepository.login()` và `UserRepository.getUserInfo()` bằng code.
    3. Lưu session vào `UserManager` ngay lập tức.
    4. Khởi chạy UI (`pumpWidget`).
- **Mục tiêu**: Bỏ qua màn hình Splash bị treo và màn hình Login rắc rối, nhảy thẳng vào trạng thái "Đã Đăng Nhập".
- **Kết quả**: 
    - API gọi thành công, nạp dữ liệu vào RAM thành công.
    - **Điểm nghẽn**: App vẫn kẹt ở Splash hoặc không nhận diện được `MainTabbarPage` trong môi trường Integration Test dù log báo đã render.

---

## 5. Các vấn đề kỹ thuật cần giải quyết (Backlog)
1. **Gradle & Flavors**: Việc chạy lệnh test cần chỉ định chính xác `--flavor dev` để tránh lỗi không tìm thấy file APK.
2. **Network Test Isolation**: Lỗi `DioExceptionType.unknown` xảy ra thường xuyên khi chạy Integration Test trên máy thật, cần kiểm tra lại cấu hình `network_security_config` hoặc Proxy.
3. **Splash Logic**: Hàm `bootstrap()` trong `AppInteractor` cần một cơ chế "Test Mode" để không bị chặn bởi các lệnh xóa `SecureStorage` vốn hay gây treo trên Android Native Channel.
4. **Finder Reliability**: Tìm kiếm Widget theo `Type` trong Integration Test kém ổn định hơn tìm theo `Key` hoặc `Text` khi App có cây Widget phức tạp.

---

## Lệnh chạy tham chiếu (Environment: Dev)
```bash
flutter drive \
  --driver test_driver/integration_test.dart \
  --target integration_test/change_mobile_integration_test.dart \
  --flavor dev \
  -d LMV600VM1775e945
```
