import 'package:coffee_bean/data/model/response/user/invite_models.dart';

class InvitationMockData {
  static InviteOverview get mockOverview => InviteOverview(
        inviteCode: "EX378G",
        totalInvites: 256,
        totalRewardPoints: 1279,
        todayInvites: 2,
        todayRewardPoints: 40,
        pendingCount: 1,
      );

  static InviteRewardConfig get mockConfig => InviteRewardConfig(
        eachInvitePoints: 20,
        firstInviteBonus: 100,
        dailyLimit: 200,
        totalLimit: -1,
        inviteExpireDays: 30,
        description: "1. Mời mỗi người bạn mới đăng ký thành công sẽ nhận ngay 20 điểm thưởng.\n2. Lần đầu mời thành công nhận thêm 100 điểm thưởng bonus.\n3. Điểm thưởng có thể dùng để đổi voucher hoặc thanh toán trực tiếp.",
      );
}
