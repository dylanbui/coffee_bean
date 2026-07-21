import 'package:coffee_bean/data/model/response/user/invite_models.dart';

class InvitationRankingMockData {
  static List<InviteRanking> getRanking(String timeRange) {
    // Return different mock data based on timeRange if needed
    return List.generate(20, (index) {
      return InviteRanking(
        rank: index + 1,
        userId: 1000 + index,
        nickname: _getNickname(index),
        avatar: 'https://picsum.photos/id/${index + 10}/200',
        totalInvites: 100 - (index * 3),
        mobile: '****${7260 + index}',
      );
    });
  }

  static String _getNickname(int index) {
    final names = [
      'Trần Văn A', 'Lê Thị B', 'Nguyễn Văn C', 'Phạm Hồng D', 'Hoàng Văn E',
      'Đặng Thị F', 'Bùi Văn G', 'Đỗ Thị H', 'Ngô Văn I', 'Lý Thị K'
    ];
    return names[index % names.length] + (index >= names.length ? ' ${index ~/ names.length}' : '');
  }
}
