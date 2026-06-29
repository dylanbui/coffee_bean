import 'package:coffee_bean/data/model/response/promotion/coupon_model.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';

class PromotionRepository extends BaseRepository {
  PromotionRepository({super.client});

  /// Lấy số lượng coupon chưa sử dụng
  Future<DbResult<int>> getUnusedCouponCount() async {
    return await networkClient
        .request('/app-api/promotion/coupon/get-unused-count', type: NetworkType.get)
        .mapResponse()
        .toValue<int>();
  }

  /// Lấy danh sách coupon phân trang
  Future<DbResult<List<CouponModel>>> getCouponPage({int pageNo = 1, int pageSize = 10, int? status}) async {
    final result = await networkClient
        .request('/app-api/promotion/coupon/page', 
            type: NetworkType.get,
            queryParameters: {
              'pageNo': pageNo,
              'pageSize': pageSize,
              if (status != null) 'status': status,
            })
        .mapResponseTo((json) => PageResult<CouponModel>.fromJson(json, (j) => CouponModel.fromJson(j as Map<String, dynamic>)))
        .toObject();

    if (result case DbSuccess(:final data)) {
      if (data.list.isEmpty) {
        return DbSuccess(_getMockCoupons());
      }
      return DbSuccess(data.list);
    }
    
    // Nếu lỗi hoặc empty từ server (tùy logic xử lý lỗi map)
    return DbSuccess(_getMockCoupons());
  }

  /// Lấy chi tiết coupon
  Future<DbResult<CouponModel>> getCouponDetail(int id) async {
    return await networkClient
        .request('/app-api/promotion/coupon/get', 
            type: NetworkType.get,
            queryParameters: {'id': id})
        .mapResponseTo(CouponModel.fromJson)
        .toObject();
  }

  List<CouponModel> _getMockCoupons() {
    final now = DateTime.now();
    return [
      CouponModel(
        id: 1,
        name: 'Product Voucher Name Long Product Voucher Name',
        status: 1,
        usePrice: 10000,
        productScope: 1,
        validStartTime: now.millisecondsSinceEpoch,
        validEndTime: now.add(const Duration(days: 365)).millisecondsSinceEpoch,
        discountType: 1,
        discountPrice: 5600,
        description: 'Applicable scope: Specific product AAA, Specific product BBB, Specific product CCC',
      ),
      CouponModel(
        id: 2,
        name: 'Product Voucher Name Long Product Voucher Name',
        status: 1,
        usePrice: 0,
        productScope: 1,
        validStartTime: now.millisecondsSinceEpoch,
        validEndTime: now.add(const Duration(days: 365)).millisecondsSinceEpoch,
        discountType: 2,
        discountPercent: 85,
      ),
      CouponModel(
        id: 3,
        name: 'Product Voucher Name Long Product Voucher Name',
        status: 1,
        usePrice: 100000,
        productScope: 1,
        validStartTime: now.millisecondsSinceEpoch,
        validEndTime: now.add(const Duration(days: 365)).millisecondsSinceEpoch,
        discountType: 1,
        discountPrice: 10000,
      ),
    ];
  }
}
