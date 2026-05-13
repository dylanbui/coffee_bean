/*
 * Created with IntelliJ IDEA
 * Package:
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 17/4/26 - 00:49
 * To change this template use File | Settings | File Templates.
 */


import 'package:coffee_bean/core/network/network_client.dart';
import 'package:coffee_bean/core/network/network_common.dart';

abstract class BaseRepository {
  late final NetworkClient networkClient;

  BaseRepository({NetworkClient? client}) {
    networkClient = client ?? NetworkServiceProvider.client;
  }
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
