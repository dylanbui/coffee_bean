import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/shared/service/upgrade_service.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MyProfileLoggedOutPanel extends StatelessWidget {
  final MyProfileInteractor interactor;

  const MyProfileLoggedOutPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    // 1. Header Profile
                    _buildHeader(),

                    // 2. Points & Rewards Card
                    _buildPointsCard(),

                    const SizedBox(height: 40),

                    // 3. Auth Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          AppButton(
                            text: "Đăng nhập",
                            style: TMLabsButtonStyle.primary,
                            onPressed: () => interactor.router?.doLoginFlow(interactor),
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            text: "Đăng ký",
                            style: TMLabsButtonStyle.outline,
                            onPressed: () {
                              // Navigate to register if available
                              interactor.router?.doRegisterFlow(interactor);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildVersionInfo(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVersionInfo() {
    return Column(
      children: [
        // Nút check update giả lập
        GestureDetector(
          onTap: () {
            // Giả lập việc bắn event để App.dart bắt được và hiện UpgradeWidget
            locator<DbEventBus>().fire(UpgradeSimulateEvent());
          },
          child: Text(
            "Kiểm tra cập nhật",
            style: TMLabsTextStyle.caption.copyWith(
              color: TMLabsColor.secondary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 8),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final version = snapshot.data?.version ?? "1.0.0";
            return Text(
              "Phiên bản $version",
              style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: TMLabsColor.primary,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: TMLabsColor.white,
            child: Icon(Icons.person, size: 40, color: TMLabsColor.primary),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Khách hàng",
                style: TMLabsTextStyle.h2.copyWith(color: TMLabsColor.white),
              ),
              const SizedBox(height: 4),
              const Text(
                "Đăng nhập để nhận ưu đãi",
                style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TMLabsColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPointItem("Điểm tích lũy", "0", Icons.stars),
          Container(width: 1, height: 40, color: TMLabsColor.lightGrey),
          _buildPointItem("Voucher của tôi", "0", Icons.confirmation_number_outlined),
        ],
      ),
    );
  }

  Widget _buildPointItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: TMLabsColor.primary),
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey)),
      ],
    );
  }
}
