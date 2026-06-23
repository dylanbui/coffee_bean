import 'dart:io';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/network/network_upload_response.dart';
import 'package:coffee_bean/data/network/network_response.dart';

class InfraRepository extends BaseRepository {
  InfraRepository({super.client});

  /// Upload file to server
  /// API: POST /app-api/infra/file/upload
  Future<ResultType<String>> uploadFile(File file, {String directory = 'avatar'}) async {
    final uploadData = UploadData(
      fieldName: 'file',
      filePath: file.path,
      extraData: {'directory': directory},
    );

    return await networkClient
        .doUpload(
          '/app-api/infra/file/upload',
          uploadData,
        )
        .mapResponse()
        .toValue<String>();
  }
}
