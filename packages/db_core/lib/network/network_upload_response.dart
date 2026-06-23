
typedef UploadProgressCallback = void Function(int count, int total);

// Only upload each file
class UploadData {
  final String fieldName; // Ví dụ: "avatar", "file"
  final String filePath;
  final Map<String, dynamic>? extraData; // Ví dụ: {"user_id": 123}
  final UploadProgressCallback? progressCallback;

  UploadData({
    required this.fieldName,
    required this.filePath,
    this.extraData,
    this.progressCallback,
  });
}

class UploadResult {
  final String link;
  final String fileName;

  UploadResult(this.link, this.fileName);

  factory UploadResult.fromMap(dynamic json) {
    if (json is String) {
      return UploadResult(json, ""); // data trả về là string path
    }
    return UploadResult(
        json['link']?.toString() ?? "",
        json['file_name']?.toString() ?? ""
    );
  }
}