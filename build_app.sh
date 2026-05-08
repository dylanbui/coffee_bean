#!/bin/bash
set -e

# Parse arguments: -e (env), -o (os)
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -e|--env) ENV="$2"; shift ;;
        -o|--os) OS="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

ENV=${ENV:-dev}
OS=${OS:-all}

# --- 2. Cập nhật Code và Thông tin Build ---
echo "🔄 Đang cập nhật code từ Git..."
# git pull # Dont use
BRANCH_NAME=$(git branch --show-current)

# 1. Lấy toàn bộ chuỗi version (ví dụ: 1.0.2+5)
FULL_VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //' | xargs)

# 2. Tách Version Name (lấy phần trước dấu +)
VERSION_NAME=$(echo $FULL_VERSION | cut -d'+' -f1)

# 3. Tách Build Number (lấy phần sau dấu +)
BUILD_NUMBER=$(echo $FULL_VERSION | cut -d'+' -f2)

# Ghi vào file release-notes.txt
# Tạo nội dung release notes
echo "--------------------------------" > release-notes.txt
echo "🚀 NEW BUILD INFORMATION" >> release-notes.txt
echo "Branch: $BRANCH_NAME" >> release-notes.txt
echo "Version: $VERSION_NAME" >> release-notes.txt
echo "Build: $BUILD_NUMBER" >> release-notes.txt
echo "Time: $(date '+%Y-%m-%d %H:%M:%S')" >> release-notes.txt
echo "--------------------------------" >> release-notes.txt

# --- 3. Flutter Setup ---
echo "🧹 Executing flutter clean..."
# flutter clean

echo "📦 Executing flutter pub get..."
# flutter pub get

# Chỉ chạy build_runner nếu dự án của bạn sử dụng code generation (như Bloc hoặc RIBs)
echo "🛠 Executing build_runner..."
# flutter packages pub run build_runner build --delete-conflicting-outputs

# Lưu lại một bản log release notes riêng theo môi trường (tùy chọn)
cp release-notes.txt "${ENV}.release-notes.txt"


# --- 4. Thực thi Fastlane ---
build_android() {
    echo "🤖 Đang build Android cho môi trường $ENV..."
    # Đảm bảo file release-notes.txt có sẵn trong thư mục android để Fastlane đọc được qua '../' [cite: 1, 5]
    cp release-notes.txt android/release-notes.txt
    cd android
    bundle exec fastlane deploy env:$ENV
    cd ..
}

build_ios() {
    echo "🍏 Đang build iOS cho môi trường $ENV..."
    cp release-notes.txt ios/release-notes.txt
    cd ios
    bundle exec fastlane deploy env:$ENV
    cd ..
}


# Điều phối build theo tham số OS
if [ "$OS" == "android" ]; then
    build_android
elif [ "$OS" == "ios" ]; then
    build_ios
elif [ "$OS" == "all" ]; then
    build_android
    build_ios
else
    echo "Hệ điều hành không hợp lệ (chọn android, ios, hoặc all)."
    exit 1
fi

echo "✅ Quy trình build hoàn tất thành công!"