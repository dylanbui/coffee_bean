import 'dart:convert';
import 'package:coffee_bean/data/model/response/user/invite_models.dart';
import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/model/response/promotion/point_breakdown.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:db_core/commons_constants.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/model/user.dart';
import 'package:coffee_bean/data/network/network_response.dart';

/// A repository that handles user related API requests.
class UserRepository extends BaseRepository {
  UserRepository({super.client});

  /// Lấy thông tin cá nhân (Profile)
  Future<DbResult<UserInfo>> getUserInfo() async {
    return await networkClient
        .request('/app-api/member/user/get', type: NetworkType.get)
        .mapResponseTo(UserInfo.fromJson)
        .toObject();
  }

  /// Lấy danh sách users (Sử dụng cấu trúc Wrapper Project)
  Future<DbResult<List<User>>> fetchUsers() async {
    return await networkClient
        .request('/users')
        .mapResponseTo(User.fromJson)
        .toList();
  }

  /// Lấy chi tiết user
  Future<DbResult<User>> fetchUserDetail(int userId) async {
    return await networkClient
        .request('/users/$userId')
        .mapResponseTo(User.fromJson)
        .toObject();
  }

  /// Tạo user mới với POST data (Theo yêu cầu của bạn)
  Future<DbResult<User>> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final Dictionary postData = {
      'name': name,
      'email': email,
      'password': password,
      'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=$name',
    };

    return await networkClient
        .request(
          '/users',
          type: NetworkType.post,
          params: postData,
        )
        .mapResponseTo(User.fromJson)
        .toObject();
  }

  /// Cập nhật thông tin cá nhân
  Future<DbResult<bool>> updateUserInfo({
    required String nickname,
    required String avatar,
    required int sex,
    String? background,
  }) async {
    return await networkClient
        .request('/app-api/member/user/update',
            type: NetworkType.put,
            params: {
              'nickname': nickname,
              'avatar': avatar,
              'sex': sex,
              'background': background,
            })
        .mapResponse()
        .toValue<bool>();
  }

  /// Thay đổi số điện thoại
  Future<DbResult<bool>> updateMobile({
    required String mobile,
    required String code,
    String? oldCode,
  }) async {
    final Dictionary params = {
      'mobile': mobile,
      'code': code,
    };
    if (oldCode != null) params['oldCode'] = oldCode;

    return await networkClient
        .request('/app-api/member/user/update-mobile',
            type: NetworkType.put,
            params: params)
        .mapResponse()
        .toValue<bool>();
  }

  /// Điểm danh hàng ngày
  Future<DbResult<Dictionary>> createSignInRecord() async {
    return await networkClient
        .request('/app-api/member/sign-in/record/create', type: NetworkType.post)
        .mapResponse()
        .toValue<Dictionary>();
  }

  /// Lấy cấu hình điểm danh
  Future<DbResult<List<Dictionary>>> getSignInConfigList() async {
    return await networkClient
        .request('/app-api/member/sign-in/config/list', type: NetworkType.get)
        .mapResponseTo<Dictionary>((json) => json)
        .toList();
  }

  /// Lấy tóm tắt điểm danh cá nhân
  Future<DbResult<Dictionary>> getSignInRecordSummary() async {
    return await networkClient
        .request('/app-api/member/sign-in/record/get-summary', type: NetworkType.get)
        .mapResponseTo<Dictionary>((json) => json)
        .toObject();
  }

  /// Lấy lịch sử tích điểm (Point History)
  Future<ResultPageType<PointBreakdownItem>> fetchPointBreakdown({int pageNo = 1, int pageSize = 20}) async {
    return await networkClient
        .request('/app-api/member/point/record/page', params: {
          'pageNo': pageNo,
          'pageSize': pageSize,
        })
        .mapResponseToPage(PointBreakdownItem.fromJson)
        .toObject();
  }

  /// Xóa tài khoản (Cancel/Disable account)
  Future<DbResult<bool>> cancelUserAccount() async {
    return await networkClient
        .request('/app-api/member/user/cancel', type: NetworkType.put)
        .mapResponse()
        .toValue<bool>();
  }

  /// Lấy thông tin tổng quan về mời bạn bè (Invite Overview)
  Future<DbResult<InviteOverview>> getInviteOverview() async {
    return await networkClient
        .request('/app-api/member/invite/overview', type: NetworkType.get)
        .mapResponseTo(InviteOverview.fromJson)
        .toObject();
  }

  /// Lấy cấu hình phần thưởng mời bạn bè (Invite Reward Config)
  Future<DbResult<InviteRewardConfig>> getInviteRewardConfig() async {
    return await networkClient
        .request('/app-api/member/invite/reward-config', type: NetworkType.get)
        .mapResponseTo(InviteRewardConfig.fromJson)
        .toObject();
  }
}
