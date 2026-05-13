/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 17/4/26 - 01:39
 * To change this template use File | Settings | File Templates.
 */

import 'dart:developer';
import 'package:coffee_bean/core/commons_constants.dart';

abstract interface class BaseRequest {
    Dictionary getRequestParams();
}

mixin JsonRequest on BaseRequest {
    // Một helper mixin để tự động hóa việc convert nếu class có toJson
    // Chuyển đổi một object bất kỳ thành Map một cách an toàn
    Dictionary toMap(dynamic object) {
        if (object == null) return {}; // Tránh lỗi nếu object bị null

        try {
            // Tận dụng tính năng của JsonSerializable
            // Nếu object có hàm toJson(), nó sẽ thực thi
            return object.toJson();
        } catch (e) {
            // Nếu không có hàm toJson (ví dụ truyền nhầm một String hoặc int)
            // Nó sẽ trả về Map rỗng thay vì làm dừng ứng dụng
            log("JsonRequest Error: Đối tượng ${object.runtimeType} không có hàm toJson()");
            return {};
        }
    }
}

/* Demo class
class CreateOrderRequest with JsonRequest implements BaseRequest {
  final User user;
  final List<CartItem> items;
  final String? couponCode;
  final String note;

  CreateOrderRequest({
    required this.user,
    required this.items,
    this.couponCode,
    this.note = "Giao hàng giờ hành chính",
  });

  @override
  Map<String, dynamic> getRequestParams() {
    // Gom nhóm dữ liệu từ nhiều nguồn vào đúng định dạng Server yêu cầu
    return {
        // Sử dụng toMap để lấy dữ liệu từ User Model
      "customer": toMap(user),
      "customer_id": user.id,
      "shipping_address": user.address,
      "products": items.map((item) => {
        "id": item.productId,
        "qty": item.quantity,
      }).toList(),
      "promotion_code": couponCode ?? "",
      "customer_note": note,
      "order_date": DateTime.now().toIso8601String(),
    };
  }
}
* * */