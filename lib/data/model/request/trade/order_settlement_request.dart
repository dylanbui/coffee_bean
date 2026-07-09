import 'package:json_annotation/json_annotation.dart';
import 'package:db_core/commons_constants.dart';

part 'order_settlement_request.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderSettlementRequest {
  final List<OrderItemRequest> items;
  final bool pointStatus;
  final int deliveryType;
  final int? couponId;
  final int? addressId;
  final int? pickUpStoreId;
  final String? receiverName;
  final String? receiverMobile;
  final int? seckillActivityId;
  final int? combinationActivityId;
  final int? combinationHeadId;
  final int? bargainRecordId;
  final int? pointActivityId;

  OrderSettlementRequest({
    required this.items,
    this.pointStatus = false,
    this.deliveryType = 2, 
    this.couponId,
    this.addressId,
    this.pickUpStoreId,
    this.receiverName,
    this.receiverMobile,
    this.seckillActivityId,
    this.combinationActivityId,
    this.combinationHeadId,
    this.bargainRecordId,
    this.pointActivityId,
  });

  /// Phẳng hóa dữ liệu theo chuẩn Spring MVC / Java để bind List<Object> từ Query Params.
  /// Kết quả: items[0].skuId=90052&items[0].count=1&pointStatus=false...
  Dictionary toQueryParameters() {
    final Map<String, dynamic> data = _$OrderSettlementRequestToJson(this);
    final Dictionary result = {};

    data.forEach((key, value) {
      if (key == 'items' && value is List) {
        // Xử lý danh sách items
        for (int i = 0; i < value.length; i++) {
          final item = value[i] as Map<String, dynamic>;
          item.forEach((itemKey, itemValue) {
            if (itemValue != null) {
              // Quan trọng: Định dạng items[0].skuId
              result['items[$i].$itemKey'] = itemValue.toString();
            }
          });
        }
      } else if (value != null) {
        // Các tham số đơn lẻ khác
        result[key] = value.toString();
      }
    });

    return result;
  }

  OrderSettlementRequest copyWith({
    List<OrderItemRequest>? items,
    bool? pointStatus,
    int? deliveryType,
    int? couponId,
    int? addressId,
    int? pickUpStoreId,
    String? receiverName,
    String? receiverMobile,
    int? seckillActivityId,
    int? combinationActivityId,
    int? combinationHeadId,
    int? bargainRecordId,
    int? pointActivityId,
  }) {
    return OrderSettlementRequest(
      items: items ?? this.items,
      pointStatus: pointStatus ?? this.pointStatus,
      deliveryType: deliveryType ?? this.deliveryType,
      couponId: couponId,
      addressId: addressId ?? this.addressId,
      pickUpStoreId: pickUpStoreId ?? this.pickUpStoreId,
      receiverName: receiverName ?? this.receiverName,
      receiverMobile: receiverMobile ?? this.receiverMobile,
      seckillActivityId: seckillActivityId ?? this.seckillActivityId,
      combinationActivityId: combinationActivityId ?? this.combinationActivityId,
      combinationHeadId: combinationHeadId ?? this.combinationHeadId,
      bargainRecordId: bargainRecordId ?? this.bargainRecordId,
      pointActivityId: pointActivityId ?? this.pointActivityId,
    );
  }

  factory OrderSettlementRequest.fromJson(Dictionary json) => _$OrderSettlementRequestFromJson(json);
  Dictionary toJson() => _$OrderSettlementRequestToJson(this);
}

@JsonSerializable()
class OrderItemRequest {
  final int skuId;
  final int count;
  final int? cartId;

  OrderItemRequest({required this.skuId, required this.count, this.cartId});

  factory OrderItemRequest.fromJson(Dictionary json) => _$OrderItemRequestFromJson(json);
  Dictionary toJson() => _$OrderItemRequestToJson(this);
}
