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

// 2. Model thật ánh xạ với dữ liệu từ https://api.escuelajs.co/api/v1/products
class ProductModel {
  final int id;
  final String title;
  final int price;

  ProductModel({required this.id, required this.title, required this.price});

  static ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      price: json['price'] as int? ?? 0,
    );
  }

  @override
  String toString() => 'Product(id: $id, title: $title, price: $price)';
}

void main() {
  group('NetworkMappingCommon - mapToObjectList', () {
    
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

      // Act: Gọi extension mapToObjectList
      // (List<Product>?, NetworkError?)
      // final (List<DummyModel>? result, NetworkError? error) = await mockFutureResponse.mapToObjectList(DummyModel.fromJson);
      // CÁCH SỬ DỤNG MỚI (FLUENT INTERFACE)
      // 1. Map List bình thường
      final (listResult, listError) = await mockFutureResponseList.mapTo(DummyModel.fromJson).toList();
      // 2. Map Object bình thường
      final (objectResult, objectError) = await mockFutureResponseObject.mapTo(DummyModel.fromJson).toObject();
      
      // 3. ĐẶC BIỆT: Server trả về List nhưng cố tình gọi toObject() -> Sẽ tự lấy item đầu tiên!
      // final (fallbackObj, fallbackError) = await mockFutureResponseList.mapTo(DummyModel.fromJson).toObject();
      
      // 4. ĐẶC BIỆT: Server trả về Object (Map) nhưng cố tình gọi toList() -> Tự bọc Object thành mảng 1 phần tử
      // final (fallbackList, fallbackListErr) = await mockFutureResponseObject.mapTo(DummyModel.fromJson).toList();

      // Nếu Server trả về JSON là một List: [ {id: 1}, {id: 2} ]
      // Generic M = ProductModel, Generic R = List<ProductModel>
      // final (List<DummyModel>? result, NetworkError? error) = await mockFutureResponseList.superMapToObject<List<DummyModel>, DummyModel>(DummyModel.fromJson);
      // final (DummyModel? resulttt, NetworkError? erroree) = await mockFutureResponseObject.superMapToObject<DummyModel, DummyModel>(DummyModel.fromJson);
      // final (result, error) = await mockFutureResponseObject.superMapToObject<DummyModel, DummyModel>(DummyModel.fromJson);

      // Hiển thị dữ liệu response ra console như bạn yêu cầu
      // expect(error, isNotNull, reason: 'Error call server');

      if (listError != null || objectError != null) {
        dLog('--- TEST FAILURE CASE ---');
        dLog('listError: ${listError?.code} - Message: ${listError?.message}\n');
        dLog('objectError: ${objectError?.code} - Message: ${objectError?.message}\n');
        return;
      }

      dLog('--- TEST SUCCESS CASE Object ---');
      dLog('ID: ${objectResult?.id.toString()}');
      dLog('Name: ${objectResult?.name}');

      // dLog('--- TEST SUCCESS CASE List ---');
      dLog('Length: ${listResult?.length.toString()}'); // Sử dụng record syntax $1 cho data
      dLog('First Name: ${listResult?[0].name}\n'); // Sử dụng record syntax $2 cho error

      // Assert: Kiểm tra tính đúng đắn
      // expect(result.$2, isNull, reason: 'Error phải là null khi thành công');
      // expect(result.$1, isNotNull, reason: 'Data không được null');
      // expect(result.$1!.length, 2);
      // expect(result.$1![0].name, 'Cà phê sữa đá');
      // dLog('--- TEST SUCCESS CASE Lấy phần tử đầu tiên từ List ---');
      // dLog('ID: ${fallbackObj?.id.toString()}'); 
      // dLog('Name: ${fallbackObj?.name}'); 
      
      // expect(fallbackObj?.name, 'Cà phê sữa đá', reason: 'Phải lấy phần tử đầu tiên của mảng mockResponseDataList');

      // dLog('--- TEST SUCCESS CASE Lấy List từ phần tử Map (Object) ---');
      // dLog('Length: ${fallbackList?.length.toString()}'); 
      // dLog('First Name in List: ${fallbackList?.first.name}'); 
      
      // expect(fallbackList?.length, 1, reason: 'Phải tự động bọc Object vào List có 1 phần tử');
    });

    // test('Thất bại: Trả về lỗi khi server trả về Map thay vì List', () async {
    //   // Arrange: Server trả về Map {} thay vì List []
    //   final mockResponseData = {'id': 1, 'name': 'Cà phê sữa đá'};

    //   final Future<Response<dynamic>> mockFutureResponse = Future.value(
    //     Response(
    //       data: mockResponseData,
    //       requestOptions: RequestOptions(path: '/api/coffees'),
    //       statusCode: 200,
    //     ),
    //   );

    //   // Act
    //   final result = await mockFutureResponse.mapToObjectList(DummyModel.fromJson);

    //   print('--- TEST FAILURE CASE (NOT A LIST) ---');
    //   print('Data: ${result.$1}');
    //   print('Error: Code ${result.$2?.code} - Message: ${result.$2?.messenger}\n');

    //   // Assert
    //   expect(result.$1, isNull);
    //   expect(result.$2, isNotNull);
    //   expect(result.$2?.messenger, "Server không trả về List");
    // });

    // Bạn có thể viết thêm test cho trường hợp bắt DioException tại đây...
    // Bằng cách trả về Future.error(DioException(...));

  });

  // group('NetworkMappingCommon - Real API Test', () {
    
  //   test('Gọi Fake API thành công và parse dữ liệu bằng mapToObjectList', () async {
  //     final dio = Dio();
  //     const url = 'https://api.escuelajs.co/api/v1/products';

  //     print('--- BẮT ĐẦU TEST FAKE API ---');
  //     print('Đang gọi API: $url');

  //     // Thực hiện gọi HTTP Request thật bằng Dio và nối trực tiếp với extension
  //     final result = await dio.get(url).mapToObjectList(ProductModel.fromJson);

  //     print('Số lượng sản phẩm lấy được: ${result.$1?.length}');
  //     if (result.$1 != null && result.$1!.isNotEmpty) {
  //       print('Sản phẩm đầu tiên: ${result.$1!.first}');
  //     }
  //     print('Error (nếu có): ${result.$2}\n');

  //     // Assertions
  //     expect(result.$2, isNull, reason: 'Phải không có lỗi trả về');
  //     expect(result.$1, isNotNull, reason: 'Data không được null');
  //     expect(result.$1!.isNotEmpty, true, reason: 'Danh sách trả về phải có ít nhất 1 phần tử');
  //   });

  //   test('Gọi Fake API thất bại (404) để test bắt lỗi mạng', () async {
  //     final dio = Dio();
  //     // Cố tình ghi sai URL để tạo lỗi 404
  //     const url = 'https://api.escuelajs.co/api/v1/products_error_url';

  //     final result = await dio.get(url).mapToObjectList(ProductModel.fromJson);

  //     print('--- TEST FAKE API (LỖI 404) ---');
  //     print('Mã lỗi: ${result.$2?.code} - Tin nhắn: ${result.$2?.messenger}\n');

  //     // Assertions
  //     expect(result.$1, isNull, reason: 'Data phải null vì gọi API lỗi');
  //     expect(result.$2, isNotNull, reason: 'Extension phải bắt được lỗi mạng (NetworkError)');
  //   });

  // });
}