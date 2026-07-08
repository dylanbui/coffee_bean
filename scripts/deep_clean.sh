#!/bin/bash

# Script dọn dẹp sâu (Deep Clean) cho dự án Coffee Bean
# Giúp sửa các lỗi xung đột version, lỗi cached Gradle/Java plugins

echo "🧹 Bắt đầu dọn dẹp hệ thống..."

# 1. Flutter Clean dự án chính
echo "--- [1/5] Flutter Clean ---"
flutter clean

# 2. Xóa cache cấu hình Dart & Pub
echo "--- [2/5] Removing Dart & Pub cache files ---"
rm -rf .dart_tool
rm -f pubspec.lock

# 3. Xóa cache của các local packages
echo "--- [3/5] Cleaning Local Packages ---"
PACKAGES_DIR="./packages"
if [ -d "$PACKAGES_DIR" ]; then
    for dir in "$PACKAGES_DIR"/*/; do
        if [ -d "$dir" ]; then
            echo "   -> Cleaning ${dir}"
            rm -rf "${dir}.dart_tool"
            rm -f "${dir}pubspec.lock"
            rm -f "${dir}.pubspec_checksum"
        fi
    done
fi

# 4. Dọn dẹp Gradle (Android)
echo "--- [4/5] Cleaning Android Gradle ---"
if [ -d "android" ]; then
    cd android || exit
    ./gradlew clean
    cd .. || exit
else
    echo "   ⚠️ Không tìm thấy thư mục android, bỏ qua."
fi

# 5. Chạy lại script build để đồng bộ
echo "--- [5/5] Rebuilding system ---"
if [ -f "./scripts/auto_build_package.sh" ]; then
    chmod +x ./scripts/auto_build_package.sh
    ./scripts/auto_build_package.sh
else
    echo "   ⚠️ Không tìm thấy scripts/auto_build_package.sh, chạy flutter pub get gốc."
    flutter pub get
fi

echo "✅ Đã dọn dẹp xong! Bây giờ bạn có thể chạy 'flutter run' để build lại ứng dụng."
