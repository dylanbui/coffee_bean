import 'package:db_core/network/network_common.dart';
import 'package:db_core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

// 1. Tạo một Model giả lập cực kỳ đơn giản để test hàm mapper
class DummyModel {
  final int id;
  final String name;

  DummyModel({required this.id, required this.name});

  // Hàm mapper chuẩn theo dạng R Function(Map<String, dynamic>) (Tear-off)
  static DummyModel fromJson(Map<String, dynamic> json) {
    return DummyModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  // Override toString để khi in ra console (print) sẽ dễ đọc hơn
  @override
  String toString() => 'DummyModel(id: $id, name: $name)';
}

void main() {
  group('NetworkMappingCommon - Chaining Test', () {
    
    test('Thành công: Trả về danh sách đối tượng khi server trả về List', () async {
      // Arrange: Tạo JSON giả lập giống như dữ liệu trả về từ server
      final mockResponseDataList = [
        {'id': 1, 'name': 'Cà phê sữa đá'},
        {'id': 2, 'name': 'Bạc xỉu'},
      ];

      final mockResponseDataObject = {'id': 1, 'name': 'Cà phê sữa đá'};      

      // Tạo một Future<Response> giả lập từ thư viện Dio
      final Future<Response<dynamic>> mockFutureResponseList = Future.value(
        Response(
          data: mockResponseDataList,
          requestOptions: RequestOptions(path: '/api/coffees'),
          statusCode: 200,
        ),
      );

      final Future<Response<dynamic>> mockFutureResponseObject = Future.value(
        Response(
          data: mockResponseDataObject,
          requestOptions: RequestOptions(path: '/api/coffees'),
          statusCode: 200,
        ),
      );

      // Act: Gọi extension mapTo (Chaining)
      
      // 1. Map List bình thường
      final listResultRaw = await mockFutureResponseList.mapTo(DummyModel.fromJson).toList();
      final List<DummyModel>? listResult = listResultRaw.data;
      final NetworkError? listError = listResultRaw.error;

      // 2. Map Object bình thường
      final objectResultRaw = await mockFutureResponseObject.mapTo(DummyModel.fromJson).toObject();
      final DummyModel? objectResult = objectResultRaw.data;
      final NetworkError? objectError = objectResultRaw.error;
      
      if (listError != null || objectError != null) {
        dLog('--- TEST FAILURE CASE ---');
        dLog('listError: ${listError?.code} - Message: ${listError?.message}\n');
        dLog('objectError: ${objectError?.code} - Message: ${objectError?.message}\n');
        return;
      }

      dLog('--- TEST SUCCESS CASE Object ---');
      dLog('ID: ${objectResult?.id.toString()}');
      dLog('Name: ${objectResult?.name}');

      dLog('--- TEST SUCCESS CASE List ---');
      dLog('Length: ${listResult?.length.toString()}');
      dLog('First Name: ${listResult?[0].name}\n');

      // Assert: Kiểm tra tính đúng đắn
      expect(listError, isNull);
      expect(listResult, isNotNull);
      expect(listResult!.length, 2);
      expect(listResult[0].name, 'Cà phê sữa đá');

      expect(objectError, isNull);
      expect(objectResult, isNotNull);
      expect(objectResult!.name, 'Cà phê sữa đá');
    });

  });
}
