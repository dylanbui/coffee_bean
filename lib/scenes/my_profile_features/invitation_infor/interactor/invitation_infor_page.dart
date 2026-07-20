import 'package:coffee_bean/scenes/my_profile_features/invitation_infor/interactor/invitation_infor_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_infor/interactor/invitation_infor_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvitationInforPage extends AppCubitStateFulWidget<InvitationInforInteractor, InvitationInforState> {
  InvitationInforPage({super.key, required super.interactor});

  @override
  State<InvitationInforPage> createState() => _InvitationInforPageState();
}

class _InvitationInforPageState extends AppCubitState<InvitationInforPage, InvitationInforInteractor, InvitationInforState> {
  @override
  String? getTitle() => "Lời mời của tôi";

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    return CoffeeAppBar(
      title: getTitle(),
      style: TmLabAppBarStyle.whiteStyle,
    );
  }

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return wrapTapToUnfocus(
      Scaffold(
        backgroundColor: TMLabsColor.bgMain,
        appBar: appBar,
        body: body,
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<InvitationInforInteractor, InvitationInforState>(
      builder: (context, state) {
        if (state.isLoading && state.overview == null) {
          return getLoadingView();
        }

        return RefreshIndicator(
          onRefresh: () async => interactor.refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserHeader(state),
                const SizedBox(height: 16),
                _buildStatsGrid(state),
                const SizedBox(height: 16),
                _buildActionButtons(),
                const SizedBox(height: 16),
                _buildInviteCodeCard(state),
                const SizedBox(height: 24),
                Text(
                  "Quy tắc mời",
                  style: TMLabsTextStyle.h2,
                ),
                const SizedBox(height: 12),
                _buildRulesCard(state),
                const SizedBox(height: 24),
                _buildRankingFooter(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserHeader(InvitationInforState state) {
    return GestureDetector(
      onTap: () => interactor.router?.openUserProfile(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            AvatarWidget(
              size: 50,
              imageUrl: state.userInfo?.avatar ?? "",
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                state.userInfo?.nickname ?? "Người dùng",
                style: TMLabsTextStyle.h2,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(InvitationInforState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              value: "${state.overview?.totalInvites ?? 0}",
              unit: " người",
              label: "Mời thành công",
            ),
          ),
          Container(height: 40, width: 1, color: Colors.grey.withValues(alpha: 0.2)),
          Expanded(
            child: _buildStatItem(
              value: "${state.overview?.totalRewardPoints ?? 0}",
              unit: " điểm",
              label: "Thưởng tích lũy",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({required String value, required String unit, required String label}) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TMLabsTextStyle.h1.copyWith(fontSize: 24),
              ),
              TextSpan(
                text: unit,
                style: TMLabsTextStyle.caption.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TMLabsTextStyle.caption.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            label: "Poster mời của tôi",
            icon: Icons.image_outlined,
            onTap: () => interactor.router?.openPoster(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            label: "Link mời của tôi",
            icon: Icons.link,
            onTap: () => interactor.router?.openInviteLink(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: TMLabsColor.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TMLabsTextStyle.bodyBold.copyWith(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteCodeCard(InvitationInforState state) {
    final code = state.overview?.inviteCode ?? "------";
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.qr_code_scanner, size: 20, color: TMLabsColor.primary),
          const SizedBox(width: 8),
          Text(
            "Mã mời của tôi",
            style: TMLabsTextStyle.body,
          ),
          const Spacer(),
          Text(
            code,
            style: TMLabsTextStyle.h2.copyWith(color: TMLabsColor.primary),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => interactor.copyInviteCode(code),
            child: Icon(Icons.copy, size: 18, color: TMLabsColor.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesCard(InvitationInforState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.config?.description ?? "Chưa có quy tắc cụ thể.",
            style: TMLabsTextStyle.body.copyWith(height: 1.6),
          ),
          const SizedBox(height: 16),
          // Placeholder for the illustration in mockup
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: TMLabsColor.bgMain,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2), style: BorderStyle.solid),
            ),
            child: Center(
              child: Text(
                "Ảnh minh họa quy tắc",
                style: TMLabsTextStyle.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bảng xếp hạng mời",
                  style: TMLabsTextStyle.h2,
                ),
                Text(
                  "Xem thứ hạng của bạn",
                  style: TMLabsTextStyle.caption.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          AppButton(
            text: "Xem ngay",
            width: 100,
            height: 36,
            style: TMLabsButtonStyle.primary.copyWith(
              borderRadius: 18,
            ),
            rightIcon: const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
            onPressed: () => interactor.router?.openRanking(),
          ),
        ],
      ),
    );
  }
}
