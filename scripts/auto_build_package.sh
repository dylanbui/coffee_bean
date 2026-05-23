#!/bin/bash

# Script auto build cho local package và source chính
# Lưu tại scripts/auto_build.sh
# Cấp quyền thực thi: chmod +x scripts/auto_build.sh

# Đường dẫn tới local package
LOCAL_PACKAGE="./packages/coffee_bean_db"
ROOT_PROJECT="."

# File lưu checksum để so sánh
CHECKSUM_FILE=".pubspec_checksum"

function check_and_pubget() {
  local dir=$1
  cd $dir || exit

  local checksum=$(md5sum pubspec.yaml | awk '{print $1}')
  local old_checksum=""

  if [ -f $CHECKSUM_FILE ]; then
    old_checksum=$(cat $CHECKSUM_FILE)
  fi

  if [ "$checksum" != "$old_checksum" ]; then
    echo "📦 pubspec.yaml thay đổi trong $dir → chạy flutter pub get"
    flutter pub get
    echo $checksum > $CHECKSUM_FILE
  else
    echo "✅ pubspec.yaml không thay đổi trong $dir → bỏ qua flutter pub get"
  fi

  cd - >/dev/null || exit
}

echo "🔄 Auto build bắt đầu..."

# Bước 1: Kiểm tra và pub get cho local package
check_and_pubget $LOCAL_PACKAGE
cd $LOCAL_PACKAGE || exit
dart run build_runner build
cd - >/dev/null || exit

# Bước 2: Kiểm tra và pub get cho source chính
check_and_pubget $ROOT_PROJECT
dart run build_runner build

echo "✅ Hoàn tất auto build!"