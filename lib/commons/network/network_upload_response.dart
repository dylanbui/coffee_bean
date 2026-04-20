
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
    return UploadResult(
        json['link']?.toString() ?? "",
        json['file_name']?.toString() ?? ""
    );
  }

  // Function nay khong can, nen xoa di
  factory UploadResult.fromJson(Map<String, dynamic > json) {
    // return UploadResult(link: json['link'] as String, fileName: json['file_name'] as String,);
    return UploadResult(json['link'] as String, json['file_name'] as String);
  }

}

// class UploadResult {
//
//   String link;
//   String fileName;
//
//   UploadResult(this.link, this.fileName);
//
//   factory UploadResult.fromJson(Map < String, dynamic > json) {
//     // return UploadResult(link: json['link'] as String, fileName: json['file_name'] as String,);
//     return UploadResult(json['link'] as String, json['file_name'] as String);
//   }
// }