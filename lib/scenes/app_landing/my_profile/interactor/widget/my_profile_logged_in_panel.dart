import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:flutter/material.dart';

class MyProfileLoggedInPanel extends StatelessWidget {
  final MyProfileInteractor interactor;

  const MyProfileLoggedInPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    final user = UserManager().currentUser;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Header Profile
          _buildHeader(
            fullName: user?.fullName ?? "Dylan Bui",
            avatarUrl: user?.avatarUrl ?? 'https://i.pravatar.cc/150?u=gigi',
          ),
          
          // 2. Points & Rewards Card
          _buildPointsCard(),

          const SizedBox(height: 10),

          // 3. Settings List
          _buildMenuItem(Icons.history, "Lịch sử mua hàng"),
          _buildMenuItem(Icons.person_outline, "Thông tin cá nhân"),
          _buildMenuItem(Icons.location_on_outlined, "Địa chỉ đã lưu"),
          _buildMenuItem(Icons.payment_outlined, "Phương thức thanh toán"),
          _buildMenuItem(Icons.notifications_none, "Thông báo"),
          _buildMenuItem(Icons.help_outline, "Hỗ trợ & Góp ý"),
          _buildMenuItem(Icons.info_outline, "Về Coffee Bean"),
          
          const SizedBox(height: 20),
          
          // 4. Auth Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    final res = await FlashDialogHelper.show<int>(
                      context: context,
                      persistent: true,
                      title: "Xác nhận đăng xuất",
                      content: "Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này?",
                      icon: const Icon(Icons.logout, color: Colors.red, size: 40),
                      actions: [
                        FlashDialogAction(label: "Hủy", value: 1, color: Colors.grey),
                        FlashDialogAction(label: "Đăng xuất", value: 2, color: Colors.red),
                      ],
                    );
                    if (res == 2) {
                      interactor.doLogout();
                    }
                  },
                  child: const Text("Đăng xuất", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(
      {required String fullName, required String avatarUrl}) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B3E),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Thành viên Vàng",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white70),
            onPressed: () {},
          )
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPointItem("Điểm tích lũy", "1,250", Icons.stars),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          _buildPointItem("Voucher của tôi", "05", Icons.confirmation_number_outlined),
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

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0D1B3E), size: 22),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
