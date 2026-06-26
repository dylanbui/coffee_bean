import 'package:coffee_bean/data/network/network_response.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';

class PromotionRepository extends BaseRepository {
  PromotionRepository({super.client});

  /// Lấy số lượng coupon chưa sử dụng
  Future<ResultType<int>> getUnusedCouponCount() async {
    return await networkClient
        .request('/app-api/promotion/coupon/get-unused-count', type: NetworkType.get)
        .mapResponse()
        .toValue<int>();
  }
}
