import 'package:coffee_bean/scenes/checkout_order/checkout_order_common.dart';
import 'package:db_core/commons_constants.dart';
import 'package:flutter/material.dart';

class CourseCheckoutItem implements CheckoutItemContract {
  final int courseId;
  final String courseTitle;
  final String instructorName;
  final String? courseImageUrl;
  final double coursePrice;

  CourseCheckoutItem({
    required this.courseId,
    required this.courseTitle,
    required this.instructorName,
    this.courseImageUrl,
    required this.coursePrice,
  });

  @override
  double get baseAmount => coursePrice;

  @override
  Widget? buildSummaryWidget(BuildContext context) {
    // Trả về null để sử dụng giao diện mặc định của Checkout module
    return null;
  }

  @override
  String get category => "COURSE";

  @override
  Dictionary get extraData => {
        "course_id": courseId,
      };

  @override
  String? get imageUrl => courseImageUrl;

  @override
  String get subTitle => "Giảng viên: $instructorName";

  @override
  String get title => courseTitle;
}
