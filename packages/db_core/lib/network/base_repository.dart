/*
 * Created with IntelliJ IDEA
 * Package: db_core/network
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 17/4/26 - 00:49
 * To change this template use File | Settings | File Templates.
 */


import 'package:db_core/network/network_client.dart';
import 'package:db_core/network/network_common.dart';

// Export các định nghĩa liên quan đến Smart Fetch để các lớp kế thừa sử dụng trực tiếp nếu cần
export 'package:db_core/network/smart_fetch_mixin.dart' show DataOrigin, SmartResult, SmartLoading, SmartFetchMixin;

/// Lớp cơ sở cho các Repository trong ứng dụng.
/// Cung cấp NetworkClient để thực hiện các yêu cầu API.
/// 
/// Lưu ý: Nếu Repository cần cơ chế Cache thông minh (SWR), hãy sử dụng:
/// `extends BaseRepository with SmartFetchMixin`
abstract class BaseRepository {
  late final NetworkClient networkClient;

  BaseRepository({NetworkClient? client}) {
    networkClient = client ?? NetworkServiceProvider.client;
  }
}
