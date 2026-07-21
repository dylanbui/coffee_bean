import 'package:coffee_bean/data/model/response/user/invite_models.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_record/interactor/invitation_record_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_record/interactor/invitation_record_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class InvitationRecordPage extends AppCubitStateFulWidget<InvitationRecordInteractor, InvitationRecordState> {
  InvitationRecordPage({super.key, required super.interactor});

  @override
  State<InvitationRecordPage> createState() => _InvitationRecordPageState();
}

class _InvitationRecordPageState extends AppCubitState<InvitationRecordPage, InvitationRecordInteractor, InvitationRecordState> {
  
  @override
  String? getTitle() => "Lịch sử mời".tr(); // Or use a translation key if available, but requested Vietnamese

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<InvitationRecordInteractor, InvitationRecordState>(
      builder: (context, state) {
        if (state.isLoading) return getLoadingView();
        
        return RefreshIndicator(
          onRefresh: () => interactor.fetchRecords(isRefresh: true),
          child: _buildList(state),
        );
      },
    );
  }

  Widget _buildList(InvitationRecordState state) {
    if (state.records.isEmpty) {
      return getEmptyItemView(caption: "Không có dữ liệu".tr());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.records.length + (state.canLoadMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.records.length) {
          interactor.fetchRecords(isRefresh: false);
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final item = state.records[index];
        return _buildItem(item);
      },
    );
  }

  Widget _buildItem(InviteRecord item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AvatarWidget(
            size: 48,
            imageUrl: item.avatar,
            backgroundColor: TMLabsColor.bgLight,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nickname ?? "Người dùng ẩn danh".tr(),
                  style: TMLabsTextStyle.bodyBold,
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.displayCreateTime} ${_getStatusName(item.status ?? 3, item.statusName ?? "Hết hạn")}",
                  style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusName(int statusId, String defaultName) {
      switch (statusId) {
        case 0:
          return "Chờ xử lý";
        case 1:
          return "Đăng ký thành công";
        case 2:
          return "Đã nhận thưởng";
        case 3:
          return "Hết hạn";
        default:
          return defaultName ?? "";
      }    
  }

}
