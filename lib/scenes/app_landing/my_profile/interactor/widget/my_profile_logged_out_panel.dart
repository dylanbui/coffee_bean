import 'package:coffee_bean/core/utils/app_button.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';

class MyProfileLoggedOutPanel extends StatelessWidget {
  final MyProfileInteractor interactor;

  const MyProfileLoggedOutPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                  style: TMLabsStyle.primaryButton,
                  onPressed: () => interactor.router?.doLogin(),
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: "Đăng ký",
                  style: TMLabsStyle.outlineButton,
                  onPressed: () {
                    // Navigate to register if available
                    interactor.router?.doRegister();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B3E),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Color(0xFF0D1B3E)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Khách hàng",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPointItem("Điểm tích lũy", "0", Icons.stars),
          Container(width: 1, height: 40, color: Colors.grey[200]),
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
            Icon(icon, size: 18, color: const Color(0xFF0D1B3E)),
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
