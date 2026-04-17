/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 17/4/26 - 00:49
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';

import 'network_client.dart';
import 'network_common.dart';

abstract class BaseRepository {
  // Các lớp con sẽ dùng biến này để gọi API
  final NetworkClient networkClient = NetworkServiceProvider.client;

  // Bạn có thể thêm các hàm bổ trợ dùng chung ở đây
  // Ví dụ: xử lý lỗi chung, log nghiệp vụ...
}

/*
*
class CoffeeRepository extends BaseRepository {
  Future<List<Coffee>?> getInternationalPrices() async {
    final response = await networkClient.request<List>(
      '/market/prices',
      type: NetworkType.get
    );

    if (response.item1 != null) {
      // Logic parse từ JsonSerializable của bạn ở đây
      return response.item1!.map((e) => Coffee.fromJson(e)).toList();
    }
    return null;
  }
}
* */
