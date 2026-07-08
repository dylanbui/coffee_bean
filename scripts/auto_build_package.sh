#!/bin/bash

# Script auto build cho local package và source chính
# Lưu tại scripts/auto_build_package.sh

# Đường dẫn tới các local packages
DB_CORE="./packages/db_core"
COFFEE_DB="./packages/coffee_bean_db"
APP_VIDEO_PLAYER="./packages/app_video_player"
ROOT_PROJECT="."

# File lưu checksum để so sánh
CHECKSUM_FILE=".pubspec_checksum"

function check_and_pubget() {
  local dir=$1
  if [ ! -d "$dir" ]; then
    echo "⚠️ Thư mục $dir không tồn tại, bỏ qua."
    return
  fi

  cd "$dir" || exit

  # Hỗ trợ cả md5sum (Linux) và md5 (macOS)
  local checksum=""
  if command -v md5sum >/dev/null 2>&1; then
    checksum=$(md5sum pubspec.yaml | awk '{print $1}')
  else
    checksum=$(md5 -q pubspec.yaml)
  fi

  local old_checksum=""

  if [ -f $CHECKSUM_FILE ]; then
    old_checksum=$(cat $CHECKSUM_FILE)
  fi

  if [ "$checksum" != "$old_checksum" ]; then
    echo "📦 pubspec.yaml thay đổi trong $dir → chạy flutter pub get"
    flutter pub get
    echo "$checksum" > $CHECKSUM_FILE
  else
    echo "✅ pubspec.yaml không thay đổi trong $dir → bỏ qua flutter pub get"
  fi

  cd - >/dev/null || exit
}

echo "🔄 Auto build hệ thống module bắt đầu..."

# Bước 1: Build db_core (Nền tảng)
echo "--- [1/4] Processing db_core ---"
check_and_pubget $DB_CORE

# Bước 2: Build coffee_bean_db (Phụ thuộc vào db_core)
echo "--- [2/4] Processing coffee_bean_db ---"
check_and_pubget $COFFEE_DB
cd $COFFEE_DB || exit
if grep -q "build_runner" pubspec.yaml; then
    dart run build_runner build
fi
cd - >/dev/null || exit

# Bước 3: Build app_video_player
echo "--- [3/4] Processing app_video_player ---"
check_and_pubget $APP_VIDEO_PLAYER

# Bước 4: Build source chính
echo "--- [4/4] Processing Root Project ---"
check_and_pubget $ROOT_PROJECT
dart run build_runner build

echo "✅ Hoàn tất auto build!"
