import 'package:coffee_bean/data/model/response/user/invite_models.dart';

class InvitationRecordMockData {
  static List<InviteRecord> getRecords() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return [
      InviteRecord(
        inviteeId: 1024,
        nickname: "Trương Tam",
        avatar: "https://i.pravatar.cc/150?u=1",
        status: 2,
        statusName: "Đã nhận thưởng",
        createTime: now - 86400000 * 1, // 1 day ago
      ),
      InviteRecord(
        inviteeId: 1025,
        nickname: "Lý Tứ",
        avatar: "https://i.pravatar.cc/150?u=2",
        status: 1,
        statusName: "Đăng ký thành công",
        createTime: now - 86400000 * 2,
      ),
      InviteRecord(
        inviteeId: 1026,
        nickname: "Vương Ngũ",
        avatar: "https://i.pravatar.cc/150?u=3",
        status: 1,
        statusName: "Đăng ký thành công",
        createTime: now - 86400000 * 10,
      ),
      InviteRecord(
        inviteeId: 1027,
        nickname: "Triệu Lục",
        avatar: "https://i.pravatar.cc/150?u=4",
        status: 1,
        statusName: "Đăng ký thành công",
        createTime: now - 86400000 * 10,
      ),
    ];
  }
}
