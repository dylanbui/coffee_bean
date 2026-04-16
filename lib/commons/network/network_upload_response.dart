
typedef UploadProgressCallback = void Function(int count, int total);

// Only upload each file
class UploadData {

  String fieldName;

  String filePath;

  UploadProgressCallback? progressCallback;

  UploadData(this.fieldName, this.filePath, {this.progressCallback});

}

class UploadResult {

  String link;
  String fileName;

  UploadResult(this.link, this.fileName);

  factory UploadResult.fromJson(Map < String, dynamic > json) {
    // return UploadResult(link: json['link'] as String, fileName: json['file_name'] as String,);
    return UploadResult(json['link'] as String, json['file_name'] as String);
  }
}