#!/bin/bash

# 1. Tạo file Dart tạm để xử lý gộp JSON
cat << 'EOF' > temp_i18n_merge.dart
import 'dart:convert';
import 'dart:io';

void main() {
  final baseDir = Directory('assets/translations');
  if (!baseDir.existsSync()) {
    print('Error: assets/translations directory not found');
    exit(1);
  }

  for (var entity in baseDir.listSync()) {
    if (entity is Directory) {
      final langCode = entity.path.split(Platform.pathSeparator).last;
      if (langCode.startsWith('.')) continue; // Bỏ qua thư mục ẩn như .DS_Store

      final Map<String, dynamic> merged = {};
      final files = entity.listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'));

      for (var file in files) {
        try {
          final content = json.decode(file.readAsStringSync());
          merged.addAll(content);
        } catch (e) {
          print('Error parsing ${file.path}: $e');
        }
      }

      if (merged.isNotEmpty) {
        final outputFile = File('assets/translations/$langCode.json');
        outputFile.writeAsStringSync(JsonEncoder.withIndent('  ').convert(merged));
        print('✅ Merged $langCode translations');
      }
    }
  }
}
EOF

# 2. Chạy logic gộp và xóa file tạm
echo "Step 1: Merging module JSON files..."
dart temp_i18n_merge.dart
rm temp_i18n_merge.dart

# 3. Sinh mã LocaleKeys
echo "Step 2: Generating LocaleKeys..."
dart run easy_localization:generate -S assets/translations -O lib/shared/i18n -f keys -o locale_keys.g.dart

# 4. Dọn dẹp các file JSON tổng (chỉ giữ lại cấu thư mục module)
echo "Step 3: Cleaning up temporary files..."
find assets/translations -maxdepth 1 -name "*.json" -delete

echo "🚀 DONE! i18n system updated successfully."
