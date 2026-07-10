import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_countdown_timer.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:intl/intl.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/models/course_order_detail_model.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/models/course_order_model.dart'; // For Enum
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/interactor/course_order_detail_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/interactor/course_order_detail_event_state.dart';

class CourseOrderDetailPage extends AppCubitStateFulWidget<CourseOrderDetailInteractor, CourseOrderDetailState> {
  CourseOrderDetailPage({super.key, required super.interactor});

  @override
  State<CourseOrderDetailPage> createState() => _CourseOrderDetailPageState();
}

class _CourseOrderDetailPageState extends AppCubitState<CourseOrderDetailPage,
    CourseOrderDetailInteractor, CourseOrderDetailState> {
  @override
  String? getTitle() => "Chi tiết đơn hàng";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<CourseOrderDetailInteractor, CourseOrderDetailState>(
      builder: (context, state) {
        if (state.isLoading) return getLoadingView();
        
        final order = state.order;
        if (order == null) {
          return getEmptyItemView(caption: state.errorMessage ?? "Không tìm thấy dữ liệu");
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusHeader(order),
                    _buildProductInfo(order),
                    _buildPaymentSummary(order),
                    _buildOrderDetails(order),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: _buildBottomActions(order),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusHeader(CourseOrderDetailModel order) {
    Color bgColor;
    Color textColor;
    String statusTitle;
    String? subTitle;

    switch (order.status) {
      case CourseOrderStatus.pending:
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange;
        statusTitle = "Chờ thanh toán";
        break;
      case CourseOrderStatus.completed:
        bgColor = Colors.green.shade50;
        textColor = Colors.green;
        statusTitle = "Đã hoàn thành";
        break;
      case CourseOrderStatus.cancelled:
        bgColor = TMLabsColor.bgLight;
        textColor = TMLabsColor.grey;
        statusTitle = "Đã hủy";
        subTitle = order.cancelReason ?? "Đã quá thời gian thanh toán";
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLabel(
            statusTitle,
            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          if (order.status == CourseOrderStatus.pending && order.expiredAt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Thời gian thanh toán còn lại: ", style: TextStyle(fontSize: 14)),
                Expanded(
                  child: AppCountdownTimer(
                    expiryDate: order.expiredAt,
                    textStyle: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                    onFinished: () {
                      // Refresh data or update UI
                    },
                  ),
                ),
              ],
            ),
          ],
          if (subTitle != null) ...[
            const SizedBox(height: 8),
            Text(subTitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ],
      ),
    );
  }

  Widget _buildProductInfo(CourseOrderDetailModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DbCachedImageWidget(
            imageUrl: order.imageUrl,
            width: 80,
            height: 80,
            borderRadius: 8,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  order.description,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  order.price.toFormatPrice(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(CourseOrderDetailModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow("Giá sản phẩm", order.price.toFormatPrice()),
          if (order.pointDiscount > 0)
            _buildSummaryRow("Khấu trừ điểm", "- ${order.pointDiscount.toFormatPrice()}", valueColor: TMLabsColor.error),
          const Divider(height: 24),
          _buildSummaryRow(
            order.status == CourseOrderStatus.pending ? "Cần thanh toán" : "Tổng tiền",
            (order.discountPrice - order.pointDiscount).toFormatPrice(),
            isBold: true,
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, double fontSize = 14, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: fontSize))),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(CourseOrderDetailModel order) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Thông tin đơn hàng", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          _buildDetailRow("Mã đơn hàng", order.orderCode, isCopyable: true),
          _buildDetailRow("Thời gian đặt hàng", dateFormat.format(order.createdAt)),
          if (order.paymentAt != null) _buildDetailRow("Thời gian thanh toán", dateFormat.format(order.paymentAt!)),
          if (order.completedAt != null) _buildDetailRow("Thời gian hoàn thành", dateFormat.format(order.completedAt!)),
          if (order.cancelledAt != null) _buildDetailRow("Thời gian hủy", dateFormat.format(order.cancelledAt!)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isCopyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: TMLabsColor.grey, fontSize: 13)),
          const SizedBox(width: 8),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isCopyable)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TapEffect(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: value));
                        DbToast.show("Mã đơn hàng: $value copied");
                      },
                      child: const AppLabel(
                        "Sao chép",
                        backgroundColor: Color(0xFFE3F2FD),
                        style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        borderRadius: 4,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(CourseOrderDetailModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: _getActionsByStatus(order),
      ),
    );
  }

  List<Widget> _getActionsByStatus(CourseOrderDetailModel order) {
    switch (order.status) {
      case CourseOrderStatus.pending:
        return [
          AppButton(
            text: "Hủy đơn hàng",
            mainAxisSize: MainAxisSize.min,
            style: TMLabsButtonStyle.white.copyWith(
              borderColor: TMLabsColor.lightGrey,
            ),
            onPressed: () => interactor.cancelOrder(),
          ),
          const SizedBox(width: 12),
          AppButton(
            text: "Thanh toán ngay",
            mainAxisSize: MainAxisSize.min,
            style: TMLabsButtonStyle.primary,
            onPressed: () => interactor.payNow(),
          ),
        ];
      case CourseOrderStatus.completed:
        return [
          if (!order.isRated) ...[
            AppButton(
              text: "Đánh giá",
              mainAxisSize: MainAxisSize.min,
              style: TMLabsButtonStyle.white.copyWith(
                borderColor: TMLabsColor.lightGrey,
              ),
              onPressed: () => interactor.rateOrder(),
            ),
            const SizedBox(width: 12),
          ],
          AppButton(
            text: "Học ngay",
            mainAxisSize: MainAxisSize.min,
            style: TMLabsButtonStyle.primary,
            onPressed: () => interactor.goToCourse(),
          ),
        ];
      case CourseOrderStatus.cancelled:
        return [
          AppButton(
            text: "Quay lại",
            mainAxisSize: MainAxisSize.min,
            style: TMLabsButtonStyle.white.copyWith(
              borderColor: TMLabsColor.lightGrey,
            ),
            onPressed: () => interactor.router?.pop(),
          ),
        ];
    }
  }
}
