import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/model/response/user/auth_login_response.dart';
import 'package:coffee_bean/data/network/network_response.dart';

class AuthRepository extends BaseRepository {
  AuthRepository({super.client});

  /// 1. Send SMS Code
  Future<ResultType<bool>> sendSmsCode(String mobile, int scene) async {
    return await networkClient
        .request('/app-api/member/auth/send-sms-code', 
            type: NetworkType.post, 
            params: {'mobile': mobile, 'scene': scene})
        .mapResponse()
        .toValue<bool>();
  }

  /// 2. SMS Login
  Future<ResultType<AuthLoginResponse>> smsLogin(String mobile, String code) async {
    return await networkClient
        .request('/app-api/member/auth/sms-login', 
            type: NetworkType.post, 
            params: {'mobile': mobile, 'code': code})
        .mapResponseTo(AuthLoginResponse.fromJson)
        .toObject();
  }

  /// 3. Login with Mobile & Password
  Future<ResultType<AuthLoginResponse>> login(String mobile, String password) async {
    return await networkClient
        .request('/app-api/member/auth/login', 
            type: NetworkType.post, 
            params: {'mobile': mobile, 'password': password})
        .mapResponseTo(AuthLoginResponse.fromJson)
        .toObject();
  }

  /// 4. Logout
  Future<ResultType<bool>> logout() async {
    return await networkClient
        .request('/app-api/member/auth/logout', type: NetworkType.post)
        .mapResponse()
        .toValue<bool>();
  }

  /// 5. Reset/Set Password
  Future<ResultType<bool>> resetPassword(String mobile, String code, String password) async {
    return await networkClient
        .request('/app-api/member/user/reset-password', 
            type: NetworkType.put, 
            params: {'mobile': mobile, 'code': code, 'password': password})
        .mapResponse()
        .toValue<bool>();
  }
}
