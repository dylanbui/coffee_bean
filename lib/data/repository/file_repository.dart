import 'package:coffee_bean/core/network/base_repository.dart';
import 'package:coffee_bean/core/network/network_upload_response.dart';
import 'package:coffee_bean/data/model/file_upload_response.dart';
import 'package:dio/dio.dart';

class FileRepository extends BaseRepository {
  
  Future<FileUploadResponse?> uploadFile(String filePath) async {
    try {
      final uploadData = UploadData(
        fieldName: 'file',
        filePath: filePath,
      );
      
      final response = await networkClient.doUpload<Map<String, dynamic>>(
        '/files/upload',
        uploadData,
      );

      if (response.data != null) {
        return FileUploadResponse.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
